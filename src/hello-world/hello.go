package main

import (
	"fmt"
)

const (
	french  = "French"
	spanish = "Spanish"
	german  = "German"

	enHello = "Hello, "
	esHello = "Hola, "
	frHello = "Bonjour, "
	deHello = "Hallo, "
)

func Hello(name, language string) string {
	if name == "" {
		name = "World"
	}

	return greetingPrefix(language) + name
}

func greetingPrefix(language string) (prefix string) {
	switch language {
	case french:
		prefix = frHello
	case spanish:
		prefix = esHello
	case german:
		prefix = deHello
	default:
		prefix = enHello
	}
	return prefix
}

func main() {
	fmt.Println(Hello("world", "English"))
}
