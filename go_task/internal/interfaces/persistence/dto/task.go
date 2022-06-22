package dto

import (
	"time"
)

type Task struct {
	ID   uint   `gorm:"primaryKey"`
	Name string `gorm:"not null"`
	//UserID      uint
	StartAt    time.Time `gorm:"not null"`
	EndAt      time.Time `gorm:"not null"`
	CreatedAt  time.Time `gorm:"not null"`
	ModifiedAt time.Time `gorm:"not null"`
}
