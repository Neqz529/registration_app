package postresql

import (
	"database/sql"

	_ "github.com/lib/pq"
)

const (
	dbname   = "register_app"
	host     = "127.0.0.1"
	port     = "5432"
	user     = "postgres"
	password = "200020105"
	sslmode  = "disable"
)

var instance *sql.DB

func GetInstance() (*sql.DB, error) {
	if instance == nil {
		connStr := "dbname=" + dbname + " host=" + host + " port=" + port + " user=" + user + " password=" + password + " sslmode=" + sslmode
		db, err := sql.Open("postgres", connStr)
		if err != nil {
			return nil, err
		}

		err = db.Ping()
		if err != nil {
			return nil, err
		}

		instance = db
	}
	return instance, nil
}
