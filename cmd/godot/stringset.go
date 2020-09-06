package main

type set map[string]struct{}

func newSet(items ...string) set {
	set := map[string]struct{}{}
	for _, i := range items {
		set[i] = struct{}{}
	}
	return set
}

func (s set) Contains(i string) bool {
	_, ok := s[i]
	return ok
}
