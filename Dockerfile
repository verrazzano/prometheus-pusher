# Copyright (C) 2020, Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

FROM container-registry.oracle.com/os/oraclelinux:7-slim@sha256:9b86d1332a883ee8f68dd44ba42133de518b2e0ec1cc70257e59fb4da86b1ad3 AS build_base

LABEL maintainer = "Verrazzano developers <verrazzano_ww@oracle.com>"
ENV GOBIN=/usr/bin
ENV GOPATH=/go
RUN set -eux; \
    yum update -y ; \
    yum-config-manager --save --setopt=ol7_ociyum_config.skip_if_unavailable=true ; \
    yum install -y oracle-golang-release-el7 ; \
    yum-config-manager --add-repo http://yum.oracle.com/repo/OracleLinux/OL7/developer/golang113/x86_64 ; \
	yum install -y \
        git \
        gcc \
        make \
        golang-1.13.3-1.el7 \
	; \
    yum clean all ; \
    go version ; \
	rm -rf /var/cache/yum

# Need to use specific WORKDIR to match prometheus-pusher's source packages
WORKDIR /go/src/github.com/verrazzano/prometheus-pusher

# Make sure modules are enabled
ENV GO111MODULE=on

# Fetch all the dependencies
COPY go.mod .
COPY go.sum .
#RUN go clean -modcache
RUN go mod download 


FROM build_base AS builder
COPY . .

RUN set -eux; \
    make unit-test; \
    make build;


FROM container-registry.oracle.com/os/oraclelinux:7-slim@sha256:9b86d1332a883ee8f68dd44ba42133de518b2e0ec1cc70257e59fb4da86b1ad3

RUN yum update -y && \
    yum-config-manager --save --setopt=ol7_ociyum_config.skip_if_unavailable=true && \
    yum install -y curl && \
    yum clean all

COPY --from=builder /go/bin/prometheus-pusher /prometheus-pusher
COPY LICENSE README.md THIRD_PARTY_LICENSES.txt /license/

ADD run.sh /

RUN chown -R 1000:1000 /prometheus-pusher /run.sh

USER 1000

ENTRYPOINT ["/run.sh"]
