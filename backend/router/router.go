package router

import (
	create "bloc_example/endpoints/create"
	"bloc_example/repository"
	"encoding/json"
	"net/http"

	"github.com/gorilla/mux"
)

type router struct {
	Router *mux.Router
	repo   repository.Repository
}

func New(repo repository.Repository) (*router, error) {
	routerMux := mux.NewRouter().StrictSlash(true)
	return &router{
		Router: routerMux,
		repo:   repo,
	}, nil
}
func (r *router) StartService() {
	createUser, err := create.NewUser(r.repo)
	if err != nil {
		panic(err)
	}

	r.Router.HandleFunc("/", homeLink)
	r.Router.HandleFunc("/register", createUser.RegisterUser).Methods("POST")
}

func homeLink(w http.ResponseWriter, r *http.Request) {
	w.WriteHeader(http.StatusCreated)
	json.NewEncoder(w).Encode("Welcome to golang API example!")
}
