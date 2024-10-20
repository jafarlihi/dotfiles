package main

import (
	"context"
	"errors"
	"log/slog"
	"strconv"
	"time"

	"github.com/google/go-github/v66/github"
	"gorm.io/gorm"
)

type Organization struct {
	gorm.Model
	GithubId    int64 `gorm:"primaryKey"`
	Login       string
	Link        string
	Location    string
	PublicRepos int
	Followers   int
}

func migratePull(db *gorm.DB) {
	db.AutoMigrate(&Organization{})
}

func getMaxGithubIdFromDb(db *gorm.DB) int64 {
	var result int64
	db.Model(&Organization{}).Select("max(github_id)").Scan(&result)
	return result
}

func getMaxGithubId(orgs []*github.Organization) int64 {
	maxObj := orgs[0]
	for _, org := range orgs {
		if *org.ID > *maxObj.ID {
			maxObj = org
		}
	}
	return *maxObj.ID
}

func isRateLimitError(err error) bool {
	var rateLimitErr *github.RateLimitError
	return errors.As(err, &rateLimitErr)
}

func pullOrgs(apiToken string, db *gorm.DB, count *int) error {
	done := 0
	githubClient := github.NewClient(nil).WithAuthToken(apiToken)
	var opt = github.OrganizationsListOptions{}
	opt.PerPage = 100
	opt.Since = getMaxGithubIdFromDb(db)

	for {
		orgs, _, err := githubClient.Organizations.ListAll(context.Background(), &opt)
		if err != nil {
			if isRateLimitError(err) {
				slog.Debug("Rate limit reached, sleeping 60 seconds")
				time.Sleep(time.Second * 60)
				continue
			}
			// TODO: Retry request before returning error
			return err
		}

		if len(orgs) == 0 {
			return errors.New("no orgs left to pull")
		}
		slog.Info("Fetched " + strconv.Itoa(len(orgs)) + " orgs' metadata")
		opt.Since = getMaxGithubId(orgs)

		for _, org := range orgs {
			org, _, err := githubClient.Organizations.Get(context.Background(), *org.Login)
			if err != nil {
				if isRateLimitError(err) {
					slog.Debug("Rate limit reached, sleeping 60 seconds")
					time.Sleep(time.Second * 60)
					continue
				}
				// TODO: Retry request before returning error
				return err
			}

			infoLogWithPrefix(*org.Login, "Fetched org")

			if org.Blog == nil {
				debugLogWithPrefix(*org.Login, "No website link found")
				continue
			}
			if org.Location == nil {
				db.Create(&Organization{GithubId: *org.ID, Login: *org.Login, Link: *org.Blog, PublicRepos: *org.PublicRepos, Followers: *org.Followers})
			} else {
				db.Create(&Organization{GithubId: *org.ID, Login: *org.Login, Link: *org.Blog, Location: *org.Location, PublicRepos: *org.PublicRepos, Followers: *org.Followers})
			}
			infoLogWithPrefix(*org.Login, "Inserted org")

			done += 1
			if count != nil {
				if done == *count {
					return nil
				}
			}
		}
	}
}
