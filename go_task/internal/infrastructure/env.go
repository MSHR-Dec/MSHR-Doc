package infrastructure

import (
	"github.com/kelseyhightower/envconfig"
)

type environment struct {
	Env           string `default:"local"`
	MysqlUser     string `default:"task" split_words:"true"`
	MysqlPassword string `default:"task" split_words:"true"`
	MysqlDatabase string `default:"task" split_words:"true"`
	MysqlHost     string `default:"mysql:3306" split_words:"true"`
}

var Environment environment

func init() {
	envconfig.Process("", &Environment)
}
