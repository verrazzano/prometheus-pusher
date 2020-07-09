# Copyright (C) 2020, Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

build:
	CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o $(GOPATH)/bin/prometheus-pusher

#
# Tests-related tasks
#
.PHONY: unit-test
unit-test:
	go test -v .
