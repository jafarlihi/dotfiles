# unearth

Unearth unadvertised job positions by crawling GitHub organizations' web pages!

## Architecture

`pull.go` -> Pulls organizations using GitHub API and saves them in an SQLite database.

`descend.go` -> Follows "Careers" (or similar) links from the main page to position listing.

`unearth.go` -> Extracts positions and locations from the listings page using OCR and saves in the database.

## Run

Edit `config.ini` and add your GitHub API token.

`go build && ./unearth [pull] [process]`

Application accepts two arguments of string literals `pull` and `process`.

Passing in `pull` without `process` will just fetch the organizations and save them in the database for later processing.

Passing in `process` without `pull` will descend/unearth the organizations that are in the database.

Passing in both will fetch organizations and descend/unearth them at the same time.

## Config

Example config:
```
GITHUB_API_TOKEN =
L1LINK_KEYWORDS = careers,career,jobs,join us,hiring,vacancies
L2LINK_KEYWORDS = vacancies,job,position,opportunities
POSITION_KEYWORDS = Software,Developer,Programmer,Engineer,Backend,Frontend
POSITION_ANTI_KEYWORDS = Engineering
LOCATION_KEYWORDS = Remote
PULL_THREAD_COUNT = 1
PROCESS_THREAD_COUNT = 4
```
