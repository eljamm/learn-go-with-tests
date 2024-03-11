package main

import (
	"reflect"
	"testing"
)

func TestWalk(t *testing.T) {
	cases := []struct {
		Name          string
		Input         interface{}
		ExpectedCalls []string
	}{
		{
			"Struct with one string field",
			struct {
				Name string
			}{"Alphonse"},
			[]string{"Alphonse"},
		},
		{
			"Struct with two string fields",
			struct {
				Name string
				City string
			}{"Alphonse", "London"},
			[]string{"Alphonse", "London"},
		},
		{
			"Struct with non string field",
			struct {
				Name string
				Age  int
			}{"Alphonse", 22},
			[]string{"Alphonse"},
		},
	}

	for _, test := range cases {
		t.Run(test.Name, func(t *testing.T) {
			var got []string

			walk(test.Input, func(input string) {
				got = append(got, input)
			})

			if !reflect.DeepEqual(got, test.ExpectedCalls) {
				t.Errorf("Got %q, wanted %q", got, test.ExpectedCalls)
			}
		})
	}
}
