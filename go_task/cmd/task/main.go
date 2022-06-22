package main

import (
	"github.com/MSHR-Dec/task/go_task/internal/infrastructure"
)

func main() {
	infrastructure.InitTask().Run(":8080")
}
