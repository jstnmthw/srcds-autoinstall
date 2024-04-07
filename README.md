# SRCDS - Autoinstall

If you like to host your own half life dedicated servers on linux, this
software can automatically deploy multiple servers each with their own config and plugins.
LinuxGSM is the underlying server management software, this just set's everything up. Perfect for using in conjunction with AWS's Spot Instances.

## Index
- [Prerequisites](#prerequisites)
- [Config](#config)
  - [Manual](#manual)
  - [S3 Download](#s3-download)
- [Game Server Instances](#game-server-instances)
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

You can create multiple directories:

```bash
- config/
  - server1/
    - server.cfg
    - users.ini
  - server2/
    - server.cfg
    - users.ini
```

### S3 Download

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

## Game Server Instances

All instances run on docker and defined in the `docker-compose.yml`. You can define multiple instances on different ports.

Take note of the container name as that's what is passed when using the `make` commands.

```yaml
cstrike:
  image: gameservermanagers/gameserver:cstrike
  container_name: cstrike
  restart: unless-stopped
  networks:
    - cstrike_network
  volumes:
    - ./servers/cstrike:/data
    - ./scripts:/scripts
  ports:
    - "27015:27015/tcp"
    - "27015:27015/udp"
    - "27020:27020/udp"
    - "27005:27005/udp"
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
make setup-config
```

Or install everything:
```bash
# Install all
make install-all
```

## Deploy

### Launch Instances

Just start the docker instances, the servers will start up.
```shell
# Starts the instances
docker-compose up -d;
```

### AWS Spot Instances

The idea here is when launching a spot instance for the first tiem, pull this repo, copy your configs to the appropriate locations and run the make commands through docker.

## TODO:

- Use AWS S3 cli tool to pull the custom configs automatically.
- Refactor folder structure.