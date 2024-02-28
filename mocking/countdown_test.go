package main

import (
	"bytes"
	"reflect"
	"testing"
)

func TestCountdown(t *testing.T) {
	t.Run("Prints 3 to Go!", func(t *testing.T) {
		buffer := &bytes.Buffer{}
		Countdown(buffer, &SpyCountdownOperations{})
		got := buffer.String()
		want := `3
2
1
Go!`
		if got != want {
			t.Errorf("Got %q, want %q", got, want)
		}
	})
	t.Run("Sleep before every print", func(t *testing.T) {
		spySleepPrinter := &SpyCountdownOperations{}
		Countdown(spySleepPrinter, spySleepPrinter)
		want := []string{
			write,
			sleep,
			write,
			sleep,
			write,
			sleep,
			write,
		}
		if !reflect.DeepEqual(want, spySleepPrinter.Calls) {
			t.Errorf("Wanted calls %v, got %v", want, spySleepPrinter.Calls)
		}
	})
}
