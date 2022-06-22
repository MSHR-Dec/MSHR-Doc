package entity

import (
	"time"
	"unicode/utf8"

	"github.com/MSHR-Dec/task/go_task/pkg/oops"
	"github.com/MSHR-Dec/task/go_task/pkg/watch"
)

type Task struct {
	ID         uint
	Name       string
	StartAt    time.Time
	EndAt      time.Time
	CreatedAt  watch.Hands
	ModifiedAt watch.Hands
}

func NewTask(name string, startAt time.Time, endAt time.Time, now watch.Hands) (*Task, error) {
	nameLength := utf8.RuneCountInString(name)
	if nameLength <= 2 || nameLength >= 24 {
		return &Task{}, oops.BadRequest{Message: "invalid number of characters"}
	}

	return &Task{
		Name:       name,
		StartAt:    startAt,
		EndAt:      endAt,
		CreatedAt:  now,
		ModifiedAt: now,
	}, nil
}
