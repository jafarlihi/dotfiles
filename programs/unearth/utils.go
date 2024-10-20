package main

import (
	"log/slog"
	"strings"
)

func debugLogWithPrefix(prefix string, log string) {
	slog.Debug("[" + prefix + "] " + log)
}

func infoLogWithPrefix(prefix string, log string) {
	slog.Info("[" + prefix + "] " + log)
}

func warnLogWithPrefix(prefix string, log string) {
	slog.Warn("[" + prefix + "] " + log)
}

func errorLogWithPrefix(prefix string, log string) {
	slog.Error("[" + prefix + "] " + log)
}

func containsAnyCaseInsensitive(str string, substrings []string) bool {
	for _, substr := range substrings {
		if strings.Contains(strings.ToLower(str), strings.ToLower(substr)) {
			return true
		}
	}
	return false
}

func containsAnyCaseSensitive(str string, substrings []string) bool {
	for _, substr := range substrings {
		if strings.Contains(str, substr) {
			return true
		}
	}
	return false
}
