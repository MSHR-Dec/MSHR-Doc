package entity

import (
	"unicode/utf8"

	"github.com/MSHR-Dec/task/go_task/pkg/oops"
	"github.com/MSHR-Dec/task/go_task/pkg/watch"
)

type User struct {
	ID         uint
	Name       string
	Password   string
	CreatedAt  watch.Hands
	ModifiedAt watch.Hands
	// TODO
	//Tasks      []Task
}

func NewUser(name string, password string, now watch.Hands) (User, error) {
	nameLength := utf8.RuneCountInString(name)
	if nameLength <= 2 || nameLength >= 16 {
		return User{}, oops.BadRequest{Message: "invalid number of characters"}
	}

	passwordLength := utf8.RuneCountInString(password)
	if passwordLength <= 8 || passwordLength >= 24 {
		return User{}, oops.BadRequest{Message: "invalid number of characters"}
	}

	return User{
		Name:       name,
		Password:   password,
		CreatedAt:  now,
		ModifiedAt: now,
	}, nil
}

func (u User) IsCollectPassword(p string) bool {
	return u.Password == p
}
