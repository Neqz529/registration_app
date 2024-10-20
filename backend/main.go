package main

import (
	repo "bloc_example/repository"
	rout "bloc_example/router"
	"os"

	"gopkg.in/paytm/grace.v1"
)

func main() {
	repository, err := repo.New()
	if err != nil {
		panic(err)
	}
	err = repository.CreateUsersTable()
	if err != nil {
		panic(err)
	}
	router, err := rout.New(*repository)
	if err != nil {
		panic(err)
	}
	router.StartService()
	port := os.Getenv("PORT")
	if port == "" {
		port = "9006" // Default port if not specified
	}
	grace.Serve(":"+port, router.Router)
}
