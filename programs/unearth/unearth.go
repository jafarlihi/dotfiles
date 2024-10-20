package main

import (
	"context"
	"errors"
	"log/slog"
	"os"
	"strings"
	"sync/atomic"
	"time"

	"github.com/chromedp/chromedp"
	"github.com/otiai10/gosseract/v2"
	"gorm.io/gorm"
)

type Enriched struct {
	gorm.Model
	GithubId  int64 `gorm:"primaryKey"`
	Link      string
	Positions string
	Locations string
}

func migrateUnearth(db *gorm.DB) {
	db.AutoMigrate(&Enriched{})
}

func getMaxEnrichedGithubIdFromDb(db *gorm.DB) *uint {
	var result *uint
	db.Model(&Enriched{}).Select("max(github_id)").Scan(&result)
	return result
}

func fullScreenshotChromedpTasks(urlstr string, quality int, res *[]byte) chromedp.Tasks {
	return chromedp.Tasks{
		chromedp.Navigate(urlstr),
		chromedp.FullScreenshot(res, quality),
	}
}

func screenshot(link string, path string) error {
	ctx, cancel := chromedp.NewContext(
		context.Background(),
	)
	defer cancel()
	ctx, cancel = context.WithTimeout(ctx, time.Second*30)
	defer cancel()

	var buf []byte
	if err := chromedp.Run(ctx, fullScreenshotChromedpTasks(link, 70, &buf)); err != nil {
		return errors.New("screenshot failed")
	}
	if err := os.WriteFile(path, buf, 0777); err != nil {
		return errors.New("screenshot file write failed")
	}
	return nil
}

func extractText(screenshotPath string, ch chan string) error {
	client := gosseract.NewClient()
	defer client.Close()
	client.SetImage(screenshotPath)
	text, err := client.Text()
	if err != nil {
		return err
	}
	ch <- text
	return nil
}

func extractTextWithTimeout(screenshotPath string) (*string, error) {
	ch := make(chan string, 1)
	ctxTimeout, cancel := context.WithTimeout(context.Background(), time.Second*30)
	defer cancel()
	go extractText(screenshotPath, ch)
	select {
	case <-ctxTimeout.Done():
		return nil, errors.New("tesseract timed-out")
	case result := <-ch:
		return &result, nil
	}
}

func extractPositions(text string) []string {
	var result []string
	lines := strings.Split(text, "\n")
	for _, line := range lines {
		if containsAnyCaseSensitive(line, POSITION_KEYWORDS[:]) && !containsAnyCaseSensitive(line, POSITION_ANTI_KEYWORDS[:]) {
			result = append(result, strings.ReplaceAll(line, ",", ""))
		}
	}
	return result
}

func extractLocations(text string) []string {
	var result []string
	lines := strings.Split(text, "\n")
	for _, line := range lines {
		if containsAnyCaseInsensitive(line, LOCATION_KEYWORDS[:]) {
			result = append(result, strings.ReplaceAll(line, ",", ""))
		}
	}
	return result
}

func extractData(org Organization, link string, screenshotDir string) ([]string, []string, error) {
	screenshotLocation := screenshotDir + "/" + org.Login + ".png"
	err := screenshot(link, screenshotLocation)
	if err != nil {
		errorLogWithPrefix(org.Login, "Failed to screenshot")
		return nil, nil, errors.New("screenshot failure")
	}
	text, err := extractTextWithTimeout(screenshotLocation)
	if err != nil {
		errorLogWithPrefix(org.Login, "Failed to OCR the page screenshot")
		return nil, nil, errors.New("OCR failure")
	}

	// TODO: Handle edge cases better
	positions := extractPositions(*text)
	locations := extractLocations(*text)

	return positions, locations, nil
}

var nextId atomic.Uint32

func initUnearth(db *gorm.DB) {
	id := getMaxEnrichedGithubIdFromDb(db)
	if id == nil {
		nextId.Store(0)
		return
	}
	var org Organization
	db.First(&org, "github_id = ?", id)
	nextId.Store(uint32(org.ID))
}

func unearth(db *gorm.DB, screenshotDir string) {
	_ = os.Mkdir(screenshotDir, 0777)
	retry := false
	var id uint32

	for {
		if !retry {
			id = nextId.Add(1)
		} else {
			retry = false
		}
		var org Organization
		db.First(&org, "id = ?", id)
		if len(org.Login) == 0 {
			slog.Debug("Organization iteration couldn't find the next record, sleeping 60 seconds")
			time.Sleep(time.Second * 60)
			retry = true
			continue
		}

		link, err := descend(org)
		if err != nil {
			slog.Error(err.Error())
			errorLogWithPrefix(org.Login, "Descend failed, skipping")
			continue
		}
		positions, locations, err := extractData(org, *link, screenshotDir)
		if err != nil {
			errorLogWithPrefix(org.Login, "Unearth failed, skipping")
			continue
		}

		db.Create(&Enriched{GithubId: org.GithubId, Link: *link, Positions: strings.Join(positions, ","), Locations: strings.Join(locations, ",")})
		infoLogWithPrefix(org.Login, "Enriched record inserted")
	}
}
