package dto

import (
	"database/sql"
	"time"
)

type User struct {
	ID         uint         `gorm:"primaryKey"`
	Name       string       `gorm:"unique;not null"`
	Password   string       `gorm:"not null"`
	CreatedAt  time.Time    `gorm:"not null"`
	ModifiedAt sql.NullTime `gorm:"default:NULL"`
	// TODO
	//Tasks      []Task
}
