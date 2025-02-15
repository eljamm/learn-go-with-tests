package main

import (
	"reflect"
	"testing"
)

type Person struct {
	Name    string
	Profile Profile
}

type Profile struct {
	Age  int
	City string
}

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
		{
			"Nested fields",
			Person{
				"Alphonse",
				Profile{22, "London"},
			},
			[]string{"Alphonse", "London"},
		},
		{
			"Pointers to strings",
			&Person{
				"Alphonse",
				Profile{22, "London"},
			},
			[]string{"Alphonse", "London"},
		},
		{
			"Slices",
			[]Profile{
				{22, "London"},
				{42, "Barcelona"},
			},
			[]string{"London", "Barcelona"},
		},
		{
			"Arrays",
			[2]Profile{
				{22, "London"},
				{42, "Barcelona"},
			},
			[]string{"London", "Barcelona"},
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

	t.Run("With maps", func(t *testing.T) {
		var got []string

		aMap := map[string]string{
			"Cat": "Meow",
			"Dog": "Woof",
		}

		walk(aMap, func(input string) {
			got = append(got, input)
		})

		assertContains(t, got, "Meow")
		assertContains(t, got, "Woof")
	})

	t.Run("With channels", func(t *testing.T) {
		var got []string
		want := []string{"London", "Barcelona"}

		aChannel := make(chan Profile)

		go func() {
			aChannel <- Profile{22, "London"}
			aChannel <- Profile{42, "Barcelona"}
			close(aChannel)
		}()

		walk(aChannel, func(input string) {
			got = append(got, input)
		})

		if !reflect.DeepEqual(got, want) {
			t.Errorf("Got %v, wanted %v", got, want)
		}
	})

	t.Run("With function", func(t *testing.T) {
		var got []string
		want := []string{"London", "Barcelona"}

		aFunction := func() (Profile, Profile) {
			return Profile{22, "London"}, Profile{42, "Barcelona"}
		}

		walk(aFunction, func(input string) {
			got = append(got, input)
		})

		if !reflect.DeepEqual(got, want) {
			t.Errorf("Got %v, wanted %v", got, want)
		}
	})
}

func assertContains(t testing.TB, haystack []string, needle string) {
	t.Helper()
	contains := false
	for _, x := range haystack {
		if x == needle {
			contains = true
			break
		}
	}
	if !contains {
		t.Errorf("Expected %v to contain %q, but it didn't", haystack, needle)
	}
}
