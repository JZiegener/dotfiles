#!/bin/sh

sudo apt-get update
sudo apt-get -y install wget systemctl
wget https://github.com/open-telemetry/opentelemetry-collector-releases/releases/download/v0.88.0/otelcol_0.88.0_linux_amd64.deb
sudo dpkg -i otelcol_0.88.0_linux_amd64.deb
sudo cp config/otel-collector-config.yml /etc/otel-contrib-collector/config.yaml
