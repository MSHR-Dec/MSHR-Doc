package main

import (
	"github.com/MSHR-Dec/task/go_task/internal/infrastructure"
	. "github.com/MSHR-Dec/task/go_task/internal/interfaces/persistence/dto"
)

func main() {
	gdb := infrastructure.NewMySQLConnection(infrastructure.Environment)
	gdb.AutoMigrate(
		&User{},
	)
}
