package main

import "testing"

func TestHello(t *testing.T) {
	t.Run("say hello to people in German", func(t *testing.T) {
		got := Hello("Bob", "German")
		want := "Hallo, Bob"
		assert(t, got, want)
	})
	t.Run("say hello to people in French", func(t *testing.T) {
		got := Hello("Bob", "French")
		want := "Bonjour, Bob"
		assert(t, got, want)
	})
	t.Run("say hello to people in Spanish", func(t *testing.T) {
		got := Hello("Bob", "Spanish")
		want := "Hola, Bob"
		assert(t, got, want)
	})
	t.Run("say hello to people", func(t *testing.T) {
		got := Hello("Bob", "English")
		want := "Hello, Bob"
		assert(t, got, want)
	})
	t.Run("say 'Hello, World' when no name supplied", func(t *testing.T) {
		got := Hello("", "")
		want := "Hello, World"
		assert(t, got, want)
	})
}

func assert(t testing.TB, got, want string) {
	t.Helper()
	if got != want {
		t.Errorf("Got %q, want %q", got, want)
	}
}
