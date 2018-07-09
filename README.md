URL: https://docs.docker.com/config/containers/logging/gelf/#usage

Arquivo: /etc/docker/daemon.json

{
  "insecure-registries":["dockerrepo.foton.la:5000"]
}
{
  "log-driver": "gelf",
  "log-opts": {
    "gelf-address": "udp://172.25.0.39:12201"
  }
}


docker-compose:

    logging:
      driver: gelf
      options:
        gelf-address: "udp://172.25.0.39:12201"
        tag: "{{.Name}}"
