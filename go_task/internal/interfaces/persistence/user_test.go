package persistence

import (
	"github.com/DATA-DOG/go-sqlmock"
	"gorm.io/driver/mysql"
	"gorm.io/gorm"
	"gorm.io/gorm/logger"
	"reflect"
	"testing"

	"github.com/MSHR-Dec/task/go_task/internal/domain/entity"
	"github.com/MSHR-Dec/task/go_task/pkg/watch"
)

func TestUserRepository_GetByName(t *testing.T) {
	db, mock, err := sqlmock.New(sqlmock.QueryMatcherOption(sqlmock.QueryMatcherEqual))
	if err != nil {
		t.Errorf("GetByName() error = %s when opening a stub database", err)
	}
	defer db.Close()

	gdb, err := gorm.Open(mysql.Dialector{
		Config: &mysql.Config{
			DriverName:                "mysql",
			Conn:                      db,
			SkipInitializeWithVersion: true,
		},
	}, &gorm.Config{
		Logger: logger.Default.LogMode(logger.Info),
	})
	if err != nil {
		t.Errorf("GetByName() error = %s when opening a stub database", err)
	}

	clock := watch.Hands{
		Now: watch.ParseTime("1999-07-01 00:00:00"),
	}

	type args struct {
		name string
	}
	tests := []struct {
		name    string
		args    args
		want    entity.User
		wantErr bool
	}{
		{
			name: "Success",
			args: args{
				name: "success",
			},
			want: entity.User{
				ID:         1,
				Name:       "success",
				Password:   "success",
				CreatedAt:  clock,
				ModifiedAt: clock,
			},
			wantErr: false,
		},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			rows := sqlmock.NewRows([]string{"id", "name", "password", "created_at", "modified_at"}).
				AddRow(tt.want.ID, tt.want.Name, tt.want.Password, tt.want.CreatedAt.Now, tt.want.ModifiedAt.Now)
			const selected = "SELECT * FROM `users` WHERE name = ? ORDER BY `users`.`id` LIMIT 1"
			mock.ExpectQuery(selected).WithArgs(tt.want.Name).WillReturnRows(rows)

			r := userRepository{
				gdb: gdb,
			}
			got, err := r.GetByName(tt.args.name)

			if (err != nil) != tt.wantErr {
				t.Errorf("GetByName() error = %v, wantErr %v", err, tt.wantErr)
				return
			}
			if !reflect.DeepEqual(got, tt.want) {
				t.Errorf("GetByName() got = %v, want %v", got, tt.want)
			}
		})
	}
}
