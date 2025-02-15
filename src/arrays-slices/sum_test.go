package main

import (
	"reflect"
	"testing"
)

func TestSum(t *testing.T) {
	t.Run("Collection of any size", func(t *testing.T) {
		numbers := []int{1, 2, 3, 4, 5, 6, 7, 8, 9}

		got := Sum(numbers)
		want := 45

		if got != want {
			t.Errorf("Got %d, want %d, given %v", got, want, numbers)
		}
	})
}

func TestSumAllTails(t *testing.T) {
	assert := func(t testing.TB, got, want []int) {
		t.Helper()
		if !reflect.DeepEqual(got, want) {
			t.Errorf("Got %v, want %v", got, want)
		}
	}

	t.Run("Sum tails of slices", func(t *testing.T) {
		got := SumAllTails([]int{1, 2}, []int{0, 9})
		want := []int{2, 9}
		assert(t, got, want)
	})

	t.Run("Safely sum empty slices", func(t *testing.T) {
		got := SumAllTails([]int{}, []int{3, 4, 5})
		want := []int{0, 9}
		assert(t, got, want)
	})
}
