#/usr/bin/env python3

import feedparser

feed = feedparser.parse('https://stackoverflow.com/jobs/feed')

d = {}
for entry in feed.entries:
    for tag in entry.tags:
        if tag.term in d:
            d[tag.term] += 1
        else:
            d[tag.term] = 1

for key, value in sorted(d.items(), key=lambda item: item[1]):
    print(key + ": " + str(value))
