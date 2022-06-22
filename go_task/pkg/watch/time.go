package watch

import (
	"time"
)

type Hands struct {
	Now time.Time
}

func ParseTime(s string) time.Time {
	const layout = "2006-01-02 15:04:05"
	t, _ := time.ParseInLocation(layout, s, time.Local)
	return t
}
