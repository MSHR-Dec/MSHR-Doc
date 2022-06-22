package infrastructure

import (
	"fmt"

	"gorm.io/driver/mysql"
	"gorm.io/gorm"
	"gorm.io/gorm/logger"
)

func NewMySQLConnection(env environment) *gorm.DB {
	endpoint := fmt.Sprintf("%s:%s@tcp(%s)/%s?charset=utf8&parseTime=True&loc=Local",
		env.MysqlUser,
		env.MysqlPassword,
		env.MysqlHost,
		env.MysqlDatabase)

	conn, err := gorm.Open(mysql.Open(endpoint), &gorm.Config{})
	if err != nil {
		panic("Fail to connect Database.")
	}

	if env.Env != "production" {
		conn.Logger = logger.Default.LogMode(logger.Info)
	}

	return conn
}
