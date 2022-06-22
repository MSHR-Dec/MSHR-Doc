package infrastructure

import (
	"github.com/MSHR-Dec/task/go_task/internal/interfaces/controller"
	"github.com/MSHR-Dec/task/go_task/internal/interfaces/persistence"
	"github.com/MSHR-Dec/task/go_task/internal/usecase"
)

func injectUser() controller.UserController {
	mysql := NewMySQLConnection(Environment)
	userRepository := persistence.NewUserRepository(mysql)
	userInteractor := usecase.NewUserInteractor(userRepository)
	return controller.NewUserController(userInteractor)
}
