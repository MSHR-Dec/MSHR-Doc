package repository

import (
	"github.com/MSHR-Dec/task/go_task/internal/domain/entity"
)

type UserRepository interface {
	GetByName(name string) (entity.User, error)
	Create(user entity.User) (uint, error)
}
