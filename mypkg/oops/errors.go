package oops

import (
	"net/http"

	"github.com/gin-gonic/gin"
)

type NotFound struct {
	Message string
}

func (e NotFound) Error() string {
	return e.Message
}

type InternalServerError struct {
	Message string
}

func (e InternalServerError) Error() string {
	return e.Message
}

type BadRequest struct {
	Message string
}

func (e BadRequest) Error() string {
	return e.Message
}

type Unauthorized struct {
	Message string
}

func (e Unauthorized) Error() string {
	return e.Message
}

func ResponseError(ctx *gin.Context, err error) {
	switch err.(type) {
	case NotFound:
		ctx.JSON(http.StatusNotFound, gin.H{"message": err.Error()})
	case InternalServerError:
		ctx.JSON(http.StatusInternalServerError, gin.H{"message": err.Error()})
	case BadRequest:
		ctx.JSON(http.StatusBadRequest, gin.H{"message": err.Error()})
	case Unauthorized:
		ctx.JSON(http.StatusUnauthorized, gin.H{"message": err.Error()})
	}
}
