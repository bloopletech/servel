# Quick reference

-	**Maintained by**:  
	[Brenton Fletcher](https://github.com/bloopletech)

-	**Where to get help**:  
  Currently there is no official support offered; please use at your own risk
	[Upstream's GitHub Issues](https://github.com/bloopletech/servel/issues)

# Supported tags and respective `Dockerfile` links

-	[`latest`](https://github.com/bloopletech/servel/blob/master/docker/Dockerfile)

# Quick reference (cont.)

-	**Where to file issues**:  
	[https://github.com/bloopletech/servel/issues](https://github.com/bloopletech/servel/issues)

# Servel

Servel is a free and open source personal web server written in Ruby and distributed under the MIT License, designed to simplify the process of making directories and files on your computer available to other computers on your local network.
For example, you might run servel on your desktop computer so that you can access your desktop's files on your tablet when you are at home.

# How to use this image

Mount the existing directories that you want to serve.
This will start a servel instance listening on the default servel port of 9292, serving your entire root filesytem.

```console
$ docker run -d --name some-servel -v /:/mnt -P bloopletech/servel
```

## Docker Desktop on Windows

This will start a servel instance, serving your entire C: drive.
Note: You may need to [enable sharing](https://docs.docker.com/docker-for-windows/#file-sharing) of your C: drive first in the Docker Desktop settings.

```console
$ docker run -d --name some-servel -v C:/:/mnt -P bloopletech/servel
```

## Custom directory

Rather than serving an entire filesystem or drive, you may want to only serve a specific directory:

```console
$ docker run -d --name some-servel -v C:/Users/Public/Downloads:/mnt -P bloopletech/servel
```

## Custom port

If you'd like to be able to access the instance from the host using a different port, standard port mappings can be used:

```console
$ docker run -d --name some-servel -v /:/mnt -p 3001:9292 bloopletech/servel
```

If all goes well, you'll be able to access your filesystem on `http://localhost:3001` (or `http://host-ip:3001`).

## ... via [`docker stack deploy`](https://docs.docker.com/engine/reference/commandline/stack_deploy/) or [`docker-compose`](https://github.com/docker/compose)

Example `stack.yml` for `servel`:

```yaml
version: '3.1'

services:

  servel:
    image: bloopletech/servel:latest
    restart: always
    volumes:
      - C:/:/mnt/c
    ports:
      - 9292:9292
```

Run `docker stack deploy -c stack.yml servel` (or `docker-compose -f stack.yml up`), wait for it to initialize completely, and visit `http://swarm-ip:9292`, `http://localhost:9292`, or `http://host-ip:9292` (as appropriate).

# License

View [license information](https://github.com/bloopletech/servel/blob/master/LICENSE.txt) for the software contained in this image.

As with all Docker images, these likely also contain other software which may be under other licenses (such as Bash, etc from the base distribution, along with any direct or indirect dependencies of the primary software being contained).

As for any pre-built image usage, it is the image user's responsibility to ensure that any use of this image complies with any relevant licenses for all software contained within.