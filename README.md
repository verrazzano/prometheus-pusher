Prometheus Pusher Image
pipeline status

Prometheus Pusher Docker image customized for Sauron.

Tag, build and push prometheus-pusher image

Go to Gitlab -> Repository -> Tags
Create "New Tag" with a tag name e.g. 0.2
Provide Release notes with changes that went in
Click "Create Tag" button
A new build and push pipeline will be triggered
New gitlab-ci image will be available at phx.ocir.io/odx-sre/sauron/prometheus-pusher:${TAG_NAME}
Environment Variables Expose

EnvironmentVariable Name	Description
PUSHGATEWAY_URL	Prometheus Pushgateway's URL
PUSHGATEWAY_USER	Basic Auth username to push to the pushgateway
PUSHGATEWAY_PASSWORD	Basic Auth password to push to the pushgateway
PULL_HOSTS	Hostname of the source to pull the metrics from (default: localhost)
PULL_PORTS	Port number of the source to pull the metrics from (default: 9102)
METRIC_PATHS	Path specifier to fetch the metrics (default /metrics)
SPLIT_SIZE	integer that says how many metrics to push to prometheus at a time
LOGLEVEL	integer that set the loglevel. 0-panic, 1-fatal, 2-error, 3-warn, 4-info, 5-debug.
INSTANCE_NAME	Prometheus the instance label that helps uniquely identifies the job (defaults to pusher FQDN)
PUSH_INTERVAL	Push interval in seconds
Note - only basic auth is supported for pushing to Prometheus Push Gateway.
Usage as a Standalone Docker Image

Disable SELinux in docker if it is enabled Comment out OPTIONS='--selinux-enabled' in /etc/sysconfig/docker
docker run -e LOGLEVEL=5 \
    -e log_field_region=us-phoenix-1 -e log_field_ad=ad1 \
    -e PUSHGATEWAY_URL=http://129.146.85.101:19091 \
    -e PUSHGATEWAY_USER=admin -e PUSHGATEWAY_PASSWORD=welcome123 \
    -e PULL_URL_target1=http://129.213.29.90:31609/metrics \
    -e http_proxy=http://www-proxy-hqdc.us.oracle.com:80  \
    phx.ocir.io/odx-sre/sauron/prometheus-pusher:1.0.1_4
Using this image in kubernetes
