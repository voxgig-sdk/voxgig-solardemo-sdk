package voxgigsolardemosdk

import (
	"testing"
)

func TestExists(t *testing.T) {
	t.Run("test-mode", func(t *testing.T) {
		testsdk := TestSDK(nil, nil)
		if testsdk == nil {
			t.Fatal("expected non-nil SDK")
		}
	})
}
