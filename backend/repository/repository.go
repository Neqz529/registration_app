package repository

import (
	db "bloc_example/interfaces"
	"database/sql"
	"fmt"

	model "bloc_example/models"
)

type Repository struct {
	PostgresqlClient *sql.DB
}

func New() (*Repository, error) {
	postgresqlClient, err := db.GetInstance()
	if err != nil {
		return nil, err
	}

	return &Repository{
		PostgresqlClient: postgresqlClient,
	}, nil
}

func (r *Repository) CreateUserDB(first_name string, second_name string, email string, password string) (int, error) {
	_, err := r.PostgresqlClient.Exec("insert into users (first_name, second_name, email, password) VALUES ($1, $2, $3, $4)", first_name, second_name, email, password)
	if err != nil {
		return 0, err
	}
	rows, err1 := r.PostgresqlClient.Query("SELECT * FROM users WHERE email = $1", email)
	if err1 != nil {
		return 0, err1
	}
	defer rows.Close()
	user := &model.User{}
	for rows.Next() {
		err := rows.Scan(&user.Id, &user.Email, &user.Password, &user.FirstName, &user.SecondName)
		if err != nil {
			return 0, err
		}
	}
	return user.Id, nil
}

func (r *Repository) CheckUserCredentialsDB(email string) (*model.User, error) {
	rows, err := r.PostgresqlClient.Query("SELECT * FROM users WHERE email = $1", email)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	user := &model.User{}
	for rows.Next() {
		err := rows.Scan(&user.Id, &user.Email, &user.Password, &user.FirstName, &user.SecondName)
		if err != nil {
			return nil, err
		}
	}
	return user, nil
}

func (r *Repository) CreateUsersTable() error {

	query := `
	CREATE TABLE IF NOT EXISTS users (
		id SERIAL PRIMARY KEY,
		first_name TEXT NOT NULL,
		second_name TEXT NOT NULL,
		email TEXT NOT NULL UNIQUE,
		password TEXT NOT NULL
	);`

	_, err := r.PostgresqlClient.Exec(query)
	if err != nil {
		panic(err)
	}

	fmt.Println("Table users created or already exists")
	return nil
}
