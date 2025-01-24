package context

import (
	"net/http"
	"net/http/httptest"
	"testing"
)

type StubStore struct {
	response string
}

func (s *StubStore) Fetch() string {
	return s.response
}

func TestServer(t *testing.T) {
	data := "hello, world"
	srv := Server(&StubStore{data})
	request := httptest.NewRequest(http.MethodGet, "/", nil)
	response := httptest.NewRecorder()
	srv.ServeHTTP(response, request)
	if response.Body.String() != data {
		t.Errorf("Got %q, want %q", response.Body.String(), data)
	}
}
