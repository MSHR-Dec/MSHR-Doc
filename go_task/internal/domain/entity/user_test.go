package entity

import (
	"reflect"
	"testing"

	"github.com/MSHR-Dec/task/go_task/pkg/watch"
)

func TestNewUser(t *testing.T) {
	now := watch.Hands{
		Now: watch.ParseTime("1999-07-01 00:00:00"),
	}

	type args struct {
		name     string
		password string
		now      watch.Hands
	}
	tests := []struct {
		name    string
		args    args
		want    *User
		wantErr bool
	}{
		{
			name: "success",
			args: args{
				name:     "test",
				password: "success-password",
				now:      now,
			},
			want: &User{
				Name:       "test",
				Password:   "success-password",
				CreatedAt:  now,
				ModifiedAt: now,
			},
			wantErr: false,
		},
		{
			name: "less name",
			args: args{
				name:     "x",
				password: "success-password",
				now:      now,
			},
			want:    &User{},
			wantErr: true,
		},
		{
			name: "more name",
			args: args{
				name:     "xxxxxxxxxxxxxxxxx",
				password: "success-password",
				now:      now,
			},
			want:    &User{},
			wantErr: true,
		},
		{
			name: "less password",
			args: args{
				name:     "test",
				password: "xxxxxxx",
				now:      now,
			},
			want:    &User{},
			wantErr: true,
		},
		{
			name: "more password",
			args: args{
				name:     "test",
				password: "xxxxxxxxxxxxxxxxxxxxxxxxx",
				now:      now,
			},
			want:    &User{},
			wantErr: true,
		},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			got, err := NewUser(tt.args.name, tt.args.password, tt.args.now)

			if (err != nil) != tt.wantErr {
				t.Errorf("NewUser() error = %v, wantErr %v", err, tt.wantErr)
				return
			}
			if !reflect.DeepEqual(got, tt.want) {
				t.Errorf("NewUser() got = %v, want %v", got, tt.want)
			}
		})
	}
}
