package main

import (
	"errors"
	"io"
	"net/http"
	"strconv"
	"strings"
	"time"

	"github.com/anaskhan96/soup"
)

var USER_AGENT = "Mozilla/5.0 (X11; Linux x86_64; rv:131.0) Gecko/20100101 Firefox/131.0"

func makeGetRequest(link string) (*string, error) {
	httpClient := http.Client{
		Timeout: 30 * time.Second,
	}
	req, err := http.NewRequest("GET", link, nil)
	if err != nil {
		warnLogWithPrefix(link, "GET request failed")
		return nil, err
	}
	req.Header = http.Header{
		"User-Agent": {USER_AGENT},
	}
	res, err := httpClient.Do(req)
	if err != nil {
		warnLogWithPrefix(link, "GET request failed")
		return nil, err
	}
	defer res.Body.Close()
	if res.StatusCode != 200 {
		warnLogWithPrefix(link, "GET request failed with status code "+strconv.Itoa(res.StatusCode))
		return nil, errors.New("non-200 status")
	}
	bodyBytes, err := io.ReadAll(res.Body)
	if err != nil {
		warnLogWithPrefix(link, "Failed to read response body")
		return nil, err
	}
	bodyString := string(bodyBytes)
	return &bodyString, nil
}

func cleanLink(link, base string) string {
	if !strings.HasPrefix(link, "http") {
		if strings.HasSuffix(base, link) {
			return base
		}
		link = base + "/" + link
	}
	link = strings.ReplaceAll(link, "//", "/")
	link = strings.ReplaceAll(link, "//", "/")
	link = strings.ReplaceAll(link, "//", "/")
	link = strings.ReplaceAll(link, "http:/", "http://")
	link = strings.ReplaceAll(link, "https:/", "https://")
	return link
}

func descend(org Organization) (*string, error) {
	link0 := org.Link
	if len(link0) == 0 {
		debugLogWithPrefix(org.Login, "No website link")
		return nil, errors.New("no website link")
	}
	if !strings.HasPrefix(link0, "http") {
		link0 = "https://" + link0
	}
	infoLogWithPrefix(org.Login, "L0Link acquired")

	res, err := makeGetRequest(link0)
	if err != nil {
		return nil, errors.New("GET request failure")
	}
	var link1 string
	doc := soup.HTMLParse(*res)
	links := doc.FindAll("a")
	for _, link := range links {
		if containsAnyCaseInsensitive(link.FullText(), L1_KEYWORDS[:]) {
			link1 = link.Attrs()["href"]
			break
		}
	}
	if link1 == "" {
		debugLogWithPrefix(org.Login, "No L1Link found")
		return nil, errors.New("no L1Link")
	}
	link1 = cleanLink(link1, link0)
	infoLogWithPrefix(org.Login, "L1Link found")

	var finalLink string

	// TODO: Handle edge cases better
	res, err = makeGetRequest(link1)
	if err != nil {
		return nil, errors.New("GET request failure")
	}
	var link2 string
	doc = soup.HTMLParse(*res)
	links = doc.FindAll("a")
	for _, link := range links {
		if containsAnyCaseInsensitive(link.FullText(), L2_KEYWORDS[:]) {
			link2 = link.Attrs()["href"]
			break
		}
	}
	if link2 == "" {
		debugLogWithPrefix(org.Login, "No L2Link found")
		finalLink = link1
	} else {
		link2 = cleanLink(link2, link0)
		infoLogWithPrefix(org.Login, "L2Link found")
		finalLink = link2
	}

	return &finalLink, nil
}
