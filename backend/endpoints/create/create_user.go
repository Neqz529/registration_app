package endpoints

import (
	"bloc_example/auth"
	model "bloc_example/models"
	repository "bloc_example/repository"
	"encoding/json"
	"net/http"
	s "strings"
)

type CreateUser struct {
	repo repository.Repository
}

func NewUser(repo repository.Repository) (*CreateUser, error) {
	return &CreateUser{
		repo: repo,
	}, nil
}
func (c *CreateUser) RegisterUser(w http.ResponseWriter, r *http.Request) {
	var user model.User
	json.NewDecoder(r.Body).Decode(&user)
	if len([]rune(user.Password)) > 6 && s.Contains(user.Email, "@") && s.Contains(user.Email, ".") {
		if err := user.HashPassword(user.Password); err != nil {
			w.WriteHeader(http.StatusInternalServerError)
			json.NewEncoder(w).Encode(model.NewError(http.StatusInternalServerError, err.Error()))
			return
		}

		result, err1 := c.repo.CreateUserDB(user.FirstName, user.SecondName, user.Email, user.Password)
		if err1 != nil {
			w.WriteHeader(http.StatusBadRequest)
			json.NewEncoder(w).Encode(model.NewError(http.StatusBadRequest, "user exists"))
			return
		}
		tokenString, err := auth.GenerateJWT(result)
		if err != nil {
			w.WriteHeader(http.StatusBadRequest)
			json.NewEncoder(w).Encode(model.NewError(http.StatusBadRequest, err.Error()))
			return
		}

		w.WriteHeader(http.StatusOK)
		json.NewEncoder(w).Encode(model.NewToken(tokenString))
	} else {
		w.WriteHeader(http.StatusBadRequest)
		json.NewEncoder(w).Encode(model.NewError(http.StatusBadRequest, "email or password is incorrect"))
	}
}
