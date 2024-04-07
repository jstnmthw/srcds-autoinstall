# SRCDS - Autoinstall

If you like to host your own half life dedicated servers on linux, this
software can automatically deploy multiple servers each with their own config and plugins.
LinuxGSM is the underlying server management software, this just set's everything up. Perfect for using in conjunction with AWS's Spot Instances.

## Index
- [Prerequisites](#prerequisites)
- [Config](#config)
  - [Manual](#manual)
  - [Automatic (S3)](#s3-download)
- [Game Servers](#game-server)
- [Commands](#commands)
- [Deploy](#deploy)
  - [Launce Instances](#launch-instances)
  - [AWS Spot Instances](#aws-spot-instances)
- [TODO](#todo)

## Prerequisites
- Docker
- AWS Cli (For S3 config)

## Config

The following config files are supported and will be copied over to the correct directories. 
Place your config files in the `config` directory (create it if one doesn't exit). For example: `config/server1`.

- LinuxGSM
  - lgsm.cfg
- Server
  - mapcycle.txt
  - motd.txt
  - plugins.ini
  - server.cfg
- AMX Mod X
  - users.ini (admins)
- FoxBot (TFC)
  - botnames.cfg
  - foxbot.cfg

### Manual

You can create multiple directories:

```bash
- config
  - server1
    - server.cfg
    - users.ini
  - server2
    - server.cfg
    - users.ini
```

### Automatic (S3)

You can set `CONFIG_SETUP=s3` variable in your `.env` file to enable automatic download of your config files from an s3 bucket.

Supported files: `.zip`, `.gzip` or `.tar`.

In order to download from S3 you must set the appropriate AWS Cli credentials in your `.env` as well.

**Note**: This script will run on the host machine. Which means AWS Cli must be installed.

```bash
CONFIG_SETUP=s3

S3_BUCKET=your-bucket
S3_FILE_PATH=/path/to/file

AWS_REGION=
AWS_ACCESS_KEY_ID=
AWS_SECRET_ACCESS_KEY=
```

The directory structure of the file should mirror our root directory:
```bash
- config
  - server1
    - server.cfg
    - plugins.ini
- plugins
  - server1
    - map_vote.amxx
```

## Game Servers

All srcds instances run on docker and defined in the `docker-compose.yml`. You can define multiple instances on different ports to run on the same host.

You can browse all the supported [LinuxGSM docker images](https://hub.docker.com/repository/docker/gameservermanagers/gameserver).

Take note of the container name as that's what is passed when using the `make` commands.

```yaml
cstrike:
  image: gameservermanagers/gameserver:cstrike
  ...
dod:
  image: gameservermanagers/gameserver:dod
  ...
tfc:
  image: gameservermanagers/gameserver:tfc
  ...
```

## Commands

Utilize the Makefile included to install configs and plugins.

```bash
# Metamod
make install-metamod

# AMX Mod X
make install-amxmod

# FoxBoT (TFC)
make install-foxbot

# Copy your configs
make setup
```

Or install everything:
```bash
make install-all
```

## Deploy

### Launch Instances

Just start the docker instances, the servers will start up.
```shell
docker-compose up -d;
```

### AWS Spot Instances

The idea here is when launching a spot instance for the first tiem, pull this repo, copy your configs to the appropriate locations and run the make commands through docker.

## Contributing

See our [contributing](CONTRIBUTING.md) guidelines.

## License

See our [licensing](LICENSE.md) information.