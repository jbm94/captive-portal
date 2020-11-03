# captive-portal

Simple captive portal with Apache2 (httpd) running in a Docker container.

> All network traffic should be redirected to this docker container (e.g., with iptables. See [Usage](#Usage "Usage section") and [Notes](#Notes "Notes section") sections.

---

## Usage

1. Create a wireless access point using your preferred method (e.g., hostapd + dnsmasq, [create_ap](https://github.com/oblique/create_ap)).

2. Put all your static files (e.g., html, css, js, images) in the `public` folder.

3. Modify the `httpd.conf` file to add your own VirtualHosts and settings.

- ### Automatic configuration

  ```bash
  $ chmod +x ./setup.sh
  ```

  ```bash
  $ ./setup.sh hotspot_interface
  ```

  > Change `hotspot_interface` with a real AP interface. See the [Notes](#Notes "Notes section") section below.

- ### Manual configuration

  1. Create your Docker image by running the following command:

  ```docker
  $ docker build -t captive-portal .
  ```

  2. Run your Docker image with:

  ```docker
  $ docker run --rm --name cp-container -d -p 80:80 captive-portal
  ```

  3. Redirect all network traffic to this docker container:

  ```cmd
  $ sudo iptables --append FORWARD --in-interface hotspot_interface -j ACCEPT
  ```

  > Change `hotspot_interface` with a real AP interface. See the [Notes](#Notes "Notes section") section below.

  ```cmd
  $ sudo iptables -t nat -A PREROUTING -p tcp --dport 80 -j DNAT --to-destination container_ip:80
  ```

  > Change `container_ip` with real cp-container ip. See the [Notes](#Notes "Notes section") section below.

---

## Notes

- `container_ip` can be obtained with:

  ```docker
  $ docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' cp-container
  ```

- `hotspot_interface` is your AP interface, usually `wlan0`, or ʻap0` when using [create_ap] (https://github.com/oblique/create_ap). It can be obtained with::

  ```cmd
  $ ip addr
  ```
