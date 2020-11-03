#!/bin/bash

# Build Docker image
docker build -t captive-portal .

# Run Docker image
docker run --rm --name cp-container -d -p 80:80 captive-portal

# Get captive-portal container ip
container_ip=`docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' cp-container`

# Redirect network traffic to captive-portal container
sudo iptables --append FORWARD --in-interface $1 -j ACCEPT
sudo iptables -t nat -A PREROUTING -p tcp --dport 80 -j DNAT --to-destination $container_ip:80

# Show traffic to localhost
#sudo dnsspoof -i $1 &
