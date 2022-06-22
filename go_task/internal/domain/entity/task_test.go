package entity

import (
	"reflect"
	"testing"
	"time"

	"github.com/MSHR-Dec/task/go_task/pkg/watch"
)

func TestNewTask(t *testing.T) {
	now := watch.Hands{
		Now: watch.ParseTime("1999-07-01 00:00:00"),
	}
	startAt := watch.ParseTime("2005-07-25")
	endAt := watch.ParseTime("2008-12-30")

	type args struct {
		name    string
		startAt time.Time
		endAt   time.Time
		now     watch.Hands
	}
	tests := []struct {
		name    string
		args    args
		want    *Task
		wantErr bool
	}{
		{
			name: "success",
			args: args{
				name:    "test",
				startAt: startAt,
				endAt:   endAt,
				now:     now,
			},
			want: &Task{
				Name:       "test",
				StartAt:    startAt,
				EndAt:      endAt,
				CreatedAt:  now,
				ModifiedAt: now,
			},
			wantErr: false,
		},
		{
			name: "less name",
			args: args{
				name:    "x",
				startAt: startAt,
				endAt:   endAt,
				now:     now,
			},
			want:    &Task{},
			wantErr: true,
		},
		{
			name: "more name",
			args: args{
				name:    "xxxxxxxxxxxxxxxxxxxxxxxxx",
				startAt: startAt,
				endAt:   endAt,
				now:     now,
			},
			want:    &Task{},
			wantErr: true,
		},
		{
			name: "no description",
			args: args{
				name:    "test",
				startAt: startAt,
				endAt:   endAt,
				now:     now,
			},
			want:    &Task{},
			wantErr: true,
		},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			got, err := NewTask(tt.args.name, tt.args.startAt, tt.args.endAt, tt.args.now)

			if (err != nil) != tt.wantErr {
				t.Errorf("NewTask() error = %v, wantErr %v", err, tt.wantErr)
				return
			}
			if !reflect.DeepEqual(got, tt.want) {
				t.Errorf("NewTask() got = %v, want %v", got, tt.want)
			}
		})
	}
}
