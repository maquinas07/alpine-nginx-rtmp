# alpine-nginx-rtmp

Dockerfile with minimal install of NGINX and nginx-rtmp-module built on Alpine Linux.

* NGINX - 1.27.4 Latest release
* nginx-rtmp-module - 1.2.2 Latest release

[![Docker Pulls](https://img.shields.io/docker/pulls/maquinas07/alpine-nginx-rtmp.svg?logo=docker)](https://hub.docker.com/r/maquinas07/alpine-nginx-rtmp/)
[![Build Status](https://img.shields.io/docker/cloud/build/maquinas07/alpine-nginx-rtmp?logo=docker)](https://hub.docker.com/r/maquinas07/alpine-nginx-rtmp/)

## Usage
* Pull docker image and run
```bash
docker pull maquinas07/alpine-nginx-rtmp
docker run -p 1935:1935 --rm maquinas07/alpine-nginx-rtmp
```

### For OBS streaming
* Service: `Custom...`
* Server: `rtmp://localhost:1935/stream`
* Stream Key: `whatever` (can be empty)

### How to watch the stream 
For low latency reproduction you can use FFplay:
```bash
ffplay -fflags nobuffer rtmp://localhost:1935/stream/whatever
```

If the Stream Key is empty then just delete the last path of the URL (I.E. `rtmp://localhost:1935/stream`)

VLC can also stream RTMP, just add the URL as network media.

### For transcoding using ffmpeg

Check out [alfg/docker-nginx-rtmp](https://github.com/alfg/docker-nginx-rtmp)
