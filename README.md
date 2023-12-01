# Docker Dev Environment with s6-overlay

| [Project Goals](https://github.com/blitterated/docker_dev_env/wiki/Project-Goals) | [Project Questions](https://github.com/blitterated/docker_dev_env/wiki/Project-Questions) |
| ----- | ----- |

## Intent

This concept is not for creating containers ready for production deployment. Instead the intent is to code without polluting the host development machine, and to deploy the project to a production runtime that is most likely not container based, e.g. a static website whose tooling has live/hot reload built in. It's simply another way to achieve a deeper kind of segregation along the lines of `virtualenv` or `bundle install --local`.

This is meant to be a base image for building more focused build time and dev time images. I really don't like using `echo` or `sed` to add lines to `.bashrc`, so I've opted to have `.bashrc` source all files found in the `~/.dde.rc` directory in the image. Just drop any extra shell configuration in a file in that directory, and it will get sourced.

#### Update

This image was previously based directly on the ubuntu image. I've since split this image in two, separating everything [s6-overlay](https://github.com/just-containers/s6-overlay) related into this one, and basing it on the [Docker Dev Environment](https://github.com/blitterated/docker-dev-env) image, which has everything else. I found too many quick-n-dirty use cases for one off applications where I didn't need s6-overlay.

## Building and Running

### Build the docker-dev-env image

Clone and build this image first: [Docker Dev Environment](https://github.com/blitterated/docker-dev-env)

### Build the docker-dev-env-s6 image from Dockerfile

```sh
docker build -t dde-s6 .
```

or


```sh
docker build --progress=plain -t dde-s6 .
```


### Run the docker-dev-env-s6 image

```sh
docker run -it --rm dde-s6 /bin/bash
```
## Utility Scripts

### Container

These are available in `/usr/bin` in the container. `/usr/bin` is in the container's `PATH` by default, so you can use these from the container's shell. These will also be available to any upstream images.

#### bounce

This execline script bounces any services you've installed with the `s6-rc` method.

#### path

This execline script prints out the system paths found in the `$PATH` environment variable on separate lines.

#### docker-s6-quick-exit / qb

This execline script will shut down the s6 supervisor tree from the top down IMMEDIATELY, and then `exit`.

You must `exec` this script for it to work properly. There is a Bash function called `qb` (quick bail) in `.bashrc` that does this.

Only use this if you don't care about jacking up a container. Typical usage is when iterating quickly on partially completed images to reduce the shutdown from the default 6 seconds to near 0.



##  There's more info in the [wiki](https://github.com/blitterated/docker_dev_env/wiki)
