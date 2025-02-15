package main

import (
	"bytes"
	"testing"
)

func TestGreet(t *testing.T) {
	buffer := bytes.Buffer{}
	Greet(&buffer, "Stanley")
	got := buffer.String()
	want := "Hello, Stanley"
	if got != want {
		t.Errorf("Got %q, want %q", got, want)
	}
}
