# Grafana Loki Server Recipe for mitamae/itamae

This is a recipe for mitamae/itamae to setup Grafana / Loki server on Ubuntu 18.

## Install mitamae

```
curl -L https://github.com/itamae-kitchen/mitamae/releases/latest/download/mitamae-x86_64-linux.tar.gz | tar xvz
sudo mv mitamae-x86_64-linux /usr/local/bin/mitamae
```

## Clone this repository

```
git clone https://github.com/tomothy83/grafana-loki-mitamae.git
```

## Prepare node file

Prepare node file like this.

```yaml
hostname: hostname.example.com
timezone: Asia/Tokyo
docker:
  compose_version: "1.27.4"
grafana:
  version: "7.3.6"
  admin:
    user: "admin"
    password: "admin"
  secret_key: "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"
loki:
  version: "2.1.0"

```

## Run mitamae

```
sudo mitamae local ./grafana-loki-mitamae/roles/grafana.rb -y path_to_node.yml
```
