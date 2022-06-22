package infrastructure

import (
	"time"

	ginzap "github.com/gin-contrib/zap"
	"github.com/gin-gonic/gin"
	"go.uber.org/zap"
)

func InitTask() *gin.Engine {
	r := gin.Default()
	setLogger(r)
	setRoute(r)

	return r
}

func setLogger(r *gin.Engine) {
	logger, _ := zap.NewProduction()
	r.Use(ginzap.Ginzap(logger, time.RFC3339, false))
	r.Use(ginzap.RecoveryWithZap(logger, true))
}

func setRoute(r *gin.Engine) {
	user := injectUser()

	r.POST("/signin", user.SignIn)
	r.POST("/signup", user.SignUp)
}
