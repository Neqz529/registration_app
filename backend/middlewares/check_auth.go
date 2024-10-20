package middlewares

import (
	"bloc_example/auth"
	model "bloc_example/models"
	"encoding/json"
	"net/http"
)

func Auth(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		tokenString := r.Header.Get("Authorization")
		if tokenString == "" {
			w.WriteHeader(http.StatusUnauthorized)
			json.NewEncoder(w).Encode(model.NewError(http.StatusUnauthorized, "request does not contain an access token"))
			return
		}
		err := auth.ValidateToken(tokenString)
		if err != nil {
			w.WriteHeader(http.StatusUnauthorized)
			json.NewEncoder(w).Encode(model.NewError(http.StatusServiceUnavailable, err.Error()))
			return
		}
		next.ServeHTTP(w, r)
	})
}
