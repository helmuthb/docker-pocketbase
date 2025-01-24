# Docker PocketBase

This repository contains a minimal Docker setup for [PocketBase](https://pocketbase.io/), using a scratch-based container for minimal size and attack surface.

## Features

- Minimal scratch-based container
- Only contains the PocketBase binary
- Runs as non-root user
- Persistent data through Docker volume
- Exposed on port 8090

## Usage

### Build the container

```bash
docker build -t helmuthb/pocketbase .
```

### Run the container

#### Using a Docker Named Volume

When running the container with a Docker Named Volume,
make sure to have the volume writable by the user running the container (`1000:1000` by default).

Otherwise, the container will fail with a slightly confusing _out of memory (14)_ error.

To create the volume with the correct permissions, you can use
e.g. the following command:

```bash
docker run -v pb_data:/pb_data --rm busybox chown -R 1000:1000 /pb_data
```

_This has only to be taken care of before the first run of the container._

Once the volume is created, you can run the container:

```bash
docker run -p 8090:8090 -v pb_data:/pb_data helmuthb/pocketbase
```

#### Using a Bind Mount

Similarly, when using a bind mount, make sure to have the mount writable by the user running the container.

On many Linux systems, user ID and group ID are `1000` for the first
non-root user by default.
If this is your user and group ID then a folder created by you will suffice for storing the pocketbase data.

### Initial setup

PocketBase requires that you create an admin user first.

One way to do this is to run the following command:

```bash
docker run -v pb_data:/pb_data helmuthb/pocketbase superuser upsert EMAIL PASS
```

Change the words `EMAIL` and `PASS` to your own email and the desired password.
You can then change the password on the admin UI.

### Initial Access

Now you can access the admin UI at `http://localhost:8090/_/`.

### Security

The container:
- Uses scratch as base image (minimal attack surface)
- Runs as non-root user (1000:1000)
- Contains only the PocketBase binary

## Data Persistence

Data is stored in the `/pb_data` volume. Make sure to mount this volume to persist your data between container restarts.

You can also provide the following folders as volume mounts:

* `/pb_public` for static file hosting
* `/pb_migrations` for automatic database migrations
* `/pb_hooks` for custom hooks

