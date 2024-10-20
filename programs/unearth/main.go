package main

import (
	"log/slog"
	"os"
	"sync"

	"gopkg.in/ini.v1"
	"gorm.io/driver/sqlite"
	"gorm.io/gorm"
	"gorm.io/gorm/logger"
)

var GITHUB_API_TOKEN string
var L1_KEYWORDS []string
var L2_KEYWORDS []string
var POSITION_KEYWORDS []string
var POSITION_ANTI_KEYWORDS []string
var LOCATION_KEYWORDS []string
var PULL_THREAD_COUNT uint
var PROCESS_THREAD_COUNT uint

func connectDatabase() *gorm.DB {
	db, err := gorm.Open(sqlite.Open("unearth.db"), &gorm.Config{
		Logger: logger.Default.LogMode(logger.Silent)},
	)
	if err != nil {
		panic("failed to connect database")
	}
	migratePull(db)
	migrateUnearth(db)
	return db
}

func pullOrgsRoutine(db *gorm.DB, wg *sync.WaitGroup) {
	err := pullOrgs(GITHUB_API_TOKEN, db, nil)
	if err != nil {
		slog.Error(err.Error())
	}
	wg.Done()
}

func unearthRoutine(db *gorm.DB, screenshotDir string, wg *sync.WaitGroup) {
	unearth(db, screenshotDir)
	wg.Done()
}

func main() {
	slog.SetLogLoggerLevel(slog.LevelDebug)

	pull := false
	process := false

	for _, flag := range os.Args {
		if flag == "pull" {
			pull = true
		} else if flag == "process" {
			process = true
		}
	}

	cfg, err := ini.Load("config.ini")
	if err != nil {
		slog.Error("Failed to read config file")
		os.Exit(1)
	}

	GITHUB_API_TOKEN = cfg.Section("").Key("GITHUB_API_TOKEN").String()
	L1_KEYWORDS = cfg.Section("").Key("L1LINK_KEYWORDS").Strings(",")
	L2_KEYWORDS = cfg.Section("").Key("L2LINK_KEYWORDS").Strings(",")
	POSITION_KEYWORDS = cfg.Section("").Key("POSITION_KEYWORDS").Strings(",")
	POSITION_ANTI_KEYWORDS = cfg.Section("").Key("POSITION_ANTI_KEYWORDS").Strings(",")
	LOCATION_KEYWORDS = cfg.Section("").Key("LOCATION_KEYWORDS").Strings(",")
	PULL_THREAD_COUNT, _ = cfg.Section("").Key("PULL_THREAD_COUNT").Uint()
	PROCESS_THREAD_COUNT, _ = cfg.Section("").Key("PROCESS_THREAD_COUNT").Uint()

	db := connectDatabase()

	var wg sync.WaitGroup
	if pull {
		for i := 0; i < int(PULL_THREAD_COUNT); i++ {
			wg.Add(1)
			go pullOrgsRoutine(db, &wg)
		}
	}

	if process {
		initUnearth(db)
		for i := 0; i < int(PROCESS_THREAD_COUNT); i++ {
			wg.Add(1)
			go unearthRoutine(db, "/tmp/unearth", &wg)
		}
	}

	wg.Wait()
}
