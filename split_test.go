// Copyright (C) 2020, Oracle and/or its affiliates.
// Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

package main

import (
	"testing"
)

func TestSplitMetrics(t *testing.T) {

	input := `#
1
2
#
3
#
1
#
2
#
3
1
2
3`
	expected := []string{`#
1
2
#
3
`,
		`#
1
#
2
#
3
`,
		`1
2
3
`}
	s, part := splitMetrics([]byte(input), 3)
	for i := 0; i < 3; i++ {
		if string(part) != expected[i] {
			t.Fatalf("[%d] got  ==%s==, expected ==%s==", i, string(part), expected[i])
		}
		part = s.Read()
	}
	part = s.Read()
	if part != nil {
		t.Fatalf("expected nil")
	}
}
