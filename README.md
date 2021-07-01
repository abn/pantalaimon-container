# Pantalaimon Container
[![Docker Repository on Quay](https://quay.io/repository/abn/pantalaimon/status "Docker Repository on Quay")](https://quay.io/repository/abn/pantalaimon)

This is an unofficial container for the [Pantalaimon Matrix Reverse Proxy](https://github.com/matrix-org/pantalaimon).

## Configuration
The container defaults to using provided [matrix.conf](matrix.conf) as configuration.

For using a custom configuration, you can mount the file similar to what is shown here.

```sh
podman run --rm -it \
	-v `pwd`/matrix.conf:/opt/pantalaimon/matrix.conf:z \
    -p 8008:8008 \
	quay.io/abn/pantalaimon:0.10.0
```

For configuration specifics, you can refer to the [Pantalaimon README.md](https://github.com/matrix-org/pantalaimon#readme).

## Data Persistence
The default data path is configured to use `/opt/pantalaimon/data`. You can mount a host directory similar to what is shown here.

```sh
# this is required for rootless containers
podman unshare chown 1000:1000 /var/lib/pantalaimon
podman run --rm -it \
	--user 1000:1000 \
	-v /var/lib/pantalaimon:/opt/pantalaimon/data:z \
    -p 8008:8008 \
	quay.io/abn/pantalaimon:0.10.0
```

> **Note:** The container users non-root default user. This means that mounted `data` directory requires correct permissions set. Additionally, [ensure user namespaces are dealt with as required for rootless containers](https://www.redhat.com/sysadmin/user-namespaces-selinux-rootless-containers).

## Building From Source
You can build the container with custom `VERSION` and `UID` (default: `1000`).

```sh
podman build \
	--build-arg VERSION=0.10.0 \
	--build-arg UID=1000 \
	-t local/pantalaimon
```
