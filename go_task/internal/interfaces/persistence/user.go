package persistence

import (
	"database/sql"
	"errors"

	"gorm.io/gorm"

	"github.com/MSHR-Dec/task/go_task/internal/domain/entity"
	"github.com/MSHR-Dec/task/go_task/internal/domain/repository"
	"github.com/MSHR-Dec/task/go_task/internal/interfaces/persistence/dto"
	"github.com/MSHR-Dec/task/go_task/pkg/oops"
	"github.com/MSHR-Dec/task/go_task/pkg/watch"
)

type userRepository struct {
	gdb *gorm.DB
}

func NewUserRepository(gdb *gorm.DB) repository.UserRepository {
	return userRepository{
		gdb: gdb,
	}
}

func (r userRepository) GetByName(name string) (entity.User, error) {
	var user dto.User
	if err := r.gdb.Where("name = ?", name).First(&user).Error; err != nil {
		if errors.Is(err, gorm.ErrRecordNotFound) {
			return entity.User{}, oops.NotFound{Message: err.Error()}
		} else {
			return entity.User{}, oops.InternalServerError{Message: err.Error()}
		}
	}

	return r.toEntity(user), nil
}

func (r userRepository) Create(user entity.User) (uint, error) {
	tx := r.gdb.Begin()

	if err := tx.Create(r.toDto(user)).Error; err != nil {
		tx.Rollback()
		return 0, oops.InternalServerError{Message: err.Error()}
	}

	if err := tx.Commit().Error; err != nil {
		tx.Rollback()
		return 0, oops.InternalServerError{Message: err.Error()}
	}

	return user.ID, nil
}

func (r userRepository) toEntity(user dto.User) entity.User {
	createdAt := watch.Hands{Now: user.CreatedAt}
	modifiedAt := watch.Hands{Now: user.ModifiedAt.Time}

	return entity.User{
		ID:         user.ID,
		Name:       user.Name,
		Password:   user.Password,
		CreatedAt:  createdAt,
		ModifiedAt: modifiedAt,
	}
}

func (r userRepository) toDto(user entity.User) *dto.User {
	return &dto.User{
		Name:      user.Name,
		Password:  user.Password,
		CreatedAt: user.CreatedAt.Now,
		ModifiedAt: sql.NullTime{
			Time:  user.ModifiedAt.Now,
			Valid: true,
		},
	}
}
