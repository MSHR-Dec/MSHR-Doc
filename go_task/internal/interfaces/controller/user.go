package controller

import (
	"net/http"

	"github.com/gin-gonic/gin"

	"github.com/MSHR-Dec/task/go_task/internal/usecase"
	"github.com/MSHR-Dec/task/go_task/pkg/oops"
)

type UserController struct {
	userUsecase usecase.UserUsecase
}

func NewUserController(userUsecase usecase.UserUsecase) UserController {
	return UserController{
		userUsecase: userUsecase,
	}
}

func (c UserController) SignIn(ctx *gin.Context) {
	var input usecase.SignInInput
	if err := ctx.ShouldBindJSON(&input); err != nil {
		oops.ResponseError(ctx, oops.BadRequest{Message: "invalid request body"})
		return
	}

	output, err := c.userUsecase.SignIn(input)
	if err != nil {
		oops.ResponseError(ctx, err)
		return
	}

	ctx.JSON(http.StatusOK, output)
}

func (c UserController) SignUp(ctx *gin.Context) {
	var input usecase.SignUpInput
	if err := ctx.ShouldBindJSON(&input); err != nil {
		oops.ResponseError(ctx, oops.BadRequest{Message: "invalid request body"})
		return
	}

	output, err := c.userUsecase.SignUp(input)
	if err != nil {
		oops.ResponseError(ctx, err)
		return
	}

	ctx.JSON(http.StatusOK, output)
}
