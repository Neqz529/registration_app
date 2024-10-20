package model

type TokenModel struct {
	Token string `json:"token"`
}

func NewToken(token string) TokenModel {
	return TokenModel{
		Token: token,
	}
}
