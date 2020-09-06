package main

import (
	"testing"

	"github.com/stretchr/testify/assert"
)

func TestStringSet(t *testing.T) {
	a, b, c := "a", "b", "c"

	t.Run("single", func(t *testing.T) {
		set := newSet(a)
		assert.True(t, set.Contains(a))
		assert.False(t, set.Contains(b))
		assert.False(t, set.Contains(c))
	})

	t.Run("a few", func(t *testing.T) {
		set := newSet(a, b, c)
		assert.True(t, set.Contains(a))
		assert.True(t, set.Contains(b))
		assert.True(t, set.Contains(c))
	})
}
