package main

import (
	"fmt"
	"io"
	"os"
	"time"
)

const (
	finalWord      = "Go!"
	countdownStart = 3
)

const (
	write = "write"
	sleep = "sleep"
)

type Sleeper interface {
	Sleep()
}

type (
	SpySleeper struct {
		Calls int
	}
	ConfigurableSleeper struct {
		duration time.Duration
		sleep    func(time.Duration)
	}
)

type SpyTime struct {
	durationSlept time.Duration
}

type SpyCountdownOperations struct {
	Calls []string
}

func main() {
	sleeper := &ConfigurableSleeper{1 * time.Second, time.Sleep}
	Countdown(os.Stdout, sleeper)
}

func Countdown(out io.Writer, sleeper Sleeper) {
	for i := countdownStart; i > 0; i-- {
		fmt.Fprintln(out, i)
		sleeper.Sleep()
	}
	fmt.Fprint(out, finalWord)
}

func (s *SpySleeper) Sleep() {
	s.Calls++
}

func (c *ConfigurableSleeper) Sleep() {
	c.sleep(c.duration)
}

func (s *SpyTime) Sleep(duration time.Duration) {
	s.durationSlept = duration
}

func (s *SpyCountdownOperations) Sleep() {
	s.Calls = append(s.Calls, sleep)
}

func (s *SpyCountdownOperations) Write(p []byte) (n int, err error) {
	s.Calls = append(s.Calls, write)
	return
}
