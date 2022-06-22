package usecase

import (
	"reflect"
	"testing"

	"github.com/golang/mock/gomock"
	"gorm.io/gorm"

	"github.com/MSHR-Dec/task/go_task/internal/domain/entity"
	"github.com/MSHR-Dec/task/go_task/internal/domain/repository"
	"github.com/MSHR-Dec/task/go_task/pkg/watch"
)

func Test_userInteractor_SignIn(t *testing.T) {
	mockCtrl := gomock.NewController(t)
	defer mockCtrl.Finish()
	mockUserRepository := NewMockUserRepository(mockCtrl)

	clock := watch.Hands{
		Now: watch.ParseTime("1999-07-01 00:00:00"),
	}

	type fields struct {
		userRepo repository.UserRepository
	}
	type args struct {
		input SignInInput
	}
	tests := []struct {
		name        string
		fields      fields
		args        args
		mockClosure func(userMock *MockUserRepository, a args)
		want        SignInOutput
		wantErr     bool
	}{
		{
			name: "success",
			fields: fields{
				userRepo: mockUserRepository,
			},
			args: args{
				input: SignInInput{
					Name:     "success",
					Password: "success",
				},
			},
			mockClosure: func(userMock *MockUserRepository, a args) {
				userMock.EXPECT().GetByName(a.input.Name).Return(entity.User{
					ID:         1,
					Name:       "success",
					Password:   "success",
					CreatedAt:  clock,
					ModifiedAt: clock,
				}, nil)
			},
			want: SignInOutput{
				ID: 1,
			},
			wantErr: false,
		},
		{
			name: "not found",
			fields: fields{
				userRepo: mockUserRepository,
			},
			args: args{
				input: SignInInput{
					Name:     "not-found",
					Password: "not-found",
				},
			},
			mockClosure: func(userMock *MockUserRepository, a args) {
				userMock.EXPECT().GetByName(a.input.Name).Return(entity.User{}, gorm.ErrRecordNotFound)
			},
			want:    SignInOutput{},
			wantErr: true,
		},
		{
			name: "invalid password",
			fields: fields{
				userRepo: mockUserRepository,
			},
			args: args{
				input: SignInInput{
					Name:     "invalid-password",
					Password: "invalid-password",
				},
			},
			mockClosure: func(userMock *MockUserRepository, a args) {
				userMock.EXPECT().GetByName(a.input.Name).Return(entity.User{
					ID:         1,
					Name:       "invalid-password",
					Password:   "dummy",
					CreatedAt:  clock,
					ModifiedAt: clock,
				}, nil)
			},
			want:    SignInOutput{},
			wantErr: true,
		},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			tt.mockClosure(mockUserRepository, tt.args)

			i := userInteractor{
				userRepo: tt.fields.userRepo,
			}
			got, err := i.SignIn(tt.args.input)

			if (err != nil) != tt.wantErr {
				t.Errorf("SignIn() error = %v, wantErr %v", err, tt.wantErr)
				return
			}
			if !reflect.DeepEqual(got, tt.want) {
				t.Errorf("SignIn() got = %v, want %v", got, tt.want)
			}
		})
	}
}

func Test_userInteractor_SignUp(t *testing.T) {
	type fields struct {
		userRepo repository.UserRepository
	}
	type args struct {
		input SignUpInput
	}
	tests := []struct {
		name    string
		fields  fields
		args    args
		want    SignUpOutput
		wantErr bool
	}{
		// TODO: Add test cases.
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			i := userInteractor{
				userRepo: tt.fields.userRepo,
			}
			got, err := i.SignUp(tt.args.input)
			if (err != nil) != tt.wantErr {
				t.Errorf("SignUp() error = %v, wantErr %v", err, tt.wantErr)
				return
			}
			if !reflect.DeepEqual(got, tt.want) {
				t.Errorf("SignUp() got = %v, want %v", got, tt.want)
			}
		})
	}
}
