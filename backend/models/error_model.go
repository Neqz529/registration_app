package model

type Error struct {
	ErrorCode int    `json:"error_code"`
	Message   string `json:"message"`
}

func NewError(code int, message string) Error {
	return Error{
		ErrorCode: code,
		Message:   message,
	}
}
