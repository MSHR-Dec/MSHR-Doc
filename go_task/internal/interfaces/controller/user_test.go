package controller

import (
	"bytes"
	"encoding/json"
	"net/http"
	"net/http/httptest"
	"reflect"
	"testing"

	"github.com/gin-gonic/gin"
	"github.com/golang/mock/gomock"

	"github.com/MSHR-Dec/task/go_task/internal/usecase"
)

func TestUserController_SignIn(t *testing.T) {
	type fields struct {
		userUsecase usecase.UserUsecase
	}
	type args struct {
		ctx *gin.Context
	}
	tests := []struct {
		name   string
		fields fields
		args   args
	}{
		// TODO: Add test cases.
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			c := UserController{
				userUsecase: tt.fields.userUsecase,
			}
			c.SignIn(tt.args.ctx)
		})
	}
}

func TestUserController_SignUp(t *testing.T) {
	mockCtrl := gomock.NewController(t)
	defer mockCtrl.Finish()
	mockUserUsecase := NewMockUserUsecase(mockCtrl)
	mockUserUsecase.EXPECT().SignUp(usecase.SignUpInput{
		Name:     "success",
		Password: "success",
	}).Return(usecase.SignUpOutput{ID: 1}, nil)

	type fields struct {
		userUsecase usecase.UserUsecase
	}
	type want struct {
		code int
		body interface{}
	}
	tests := []struct {
		name        string
		fields      fields
		requestBody string
		want        want
	}{
		{
			name: "success",
			fields: fields{
				userUsecase: mockUserUsecase,
			},
			requestBody: "{\"name\":\"success\", \"password\":\"success\"}",
			want: want{
				code: 200,
				body: usecase.SignUpOutput{
					ID: 1,
				},
			},
		},
		{
			name: "invalid type of the form",
			fields: fields{
				userUsecase: mockUserUsecase,
			},
			requestBody: "{\"name\":1, \"password\":\"success\"}",
			want: want{
				code: 400,
				body: map[string]interface{}{
					"message": "invalid request body",
				},
			},
		},
		{
			name: "missing the required form",
			fields: fields{
				userUsecase: mockUserUsecase,
			},
			requestBody: "{\"password\":\"success\"}",
			want: want{
				code: 400,
				body: map[string]interface{}{
					"message": "invalid request body",
				},
			},
		},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			recorder := httptest.NewRecorder()

			ctx, _ := gin.CreateTestContext(recorder)
			ctx.Request, _ = http.NewRequest("POST", "/signup", bytes.NewBufferString(tt.requestBody))

			c := UserController{
				userUsecase: tt.fields.userUsecase,
			}
			c.SignUp(ctx)

			wantBody, _ := json.Marshal(tt.want.body)
			if !reflect.DeepEqual(recorder.Code, tt.want.code) {
				t.Errorf("SignUp() code = %v, want %v", recorder.Code, tt.want.code)
			}
			if !reflect.DeepEqual(recorder.Body.Bytes(), wantBody) {
				t.Errorf("SignUp() body = %v, want %v", recorder.Body.Bytes(), wantBody)
			}
		})
	}
}
