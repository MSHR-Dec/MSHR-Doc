package usecase

import (
	"time"

	"github.com/MSHR-Dec/task/go_task/internal/domain/entity"
	"github.com/MSHR-Dec/task/go_task/internal/domain/repository"
	"github.com/MSHR-Dec/task/go_task/pkg/oops"
	"github.com/MSHR-Dec/task/go_task/pkg/watch"
)

type UserUsecase interface {
	SignIn(input SignInInput) (SignInOutput, error)
	SignUp(input SignUpInput) (SignUpOutput, error)
}

type userInteractor struct {
	userRepo repository.UserRepository
}

func NewUserInteractor(userRepo repository.UserRepository) UserUsecase {
	return userInteractor{
		userRepo: userRepo,
	}
}

type SignInInput struct {
	Name     string `form:"name" binding:"required"`
	Password string `form:"password" binding:"required"`
}

type SignInOutput struct {
	ID uint `json:"id"`
}

func (i userInteractor) SignIn(input SignInInput) (SignInOutput, error) {
	user, err := i.userRepo.GetByName(input.Name)
	if err != nil {
		return SignInOutput{}, err
	}

	if !user.IsCollectPassword(input.Password) {
		return SignInOutput{}, oops.BadRequest{Message: "invalid password"}
	}

	return SignInOutput{
		ID: user.ID,
	}, err
}

type SignUpInput struct {
	Name     string `form:"name" binding:"required"`
	Password string `form:"password" binding:"required"`
}

type SignUpOutput struct {
	ID uint `json:"id"`
}

func (i userInteractor) SignUp(input SignUpInput) (SignUpOutput, error) {
	now := watch.Hands{Now: time.Now()}
	user, err := entity.NewUser(input.Name, input.Password, now)
	if err != nil {
		return SignUpOutput{}, err
	}

	id, err := i.userRepo.Create(user)
	if err != nil {
		return SignUpOutput{}, err
	}

	return SignUpOutput{
		ID: id,
	}, nil
}
