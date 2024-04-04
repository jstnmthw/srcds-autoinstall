# SRCDS - Autoinstall

Who's this for? 

If you like to host your own half life dedicated servers on linux, this
software can automatically deploy multiple servers each with their own config and plugins.
LinuxGSM is the underlying server management software, this just set's everything up automatically. Perfect for using in conjunction with AWS's Spot Instances.

## Config

The following is how you should setup your directory structure so the script can pull your configs and plugins.

All of the files are optional, just put which config you want copied over.

```
- /config
  - server1
  - amxx.cfg
    - botnames.cfg
    - foxbot.cfg
    - lgsm.cfg
    - mapcycle.txt
    - motd.txt
    - plugins.ini
    - server.cfg
    - users.ini
  - server2
    ...
```

## Install

Utilize the Makefile included to install configs and plugins.


```bash
// Metamod
make install-metamod

// AMX Mod X
make install-amxmod

// FoxBoT (TFC)
make install-foxbot

// Copy your configs
make setup-config
```

Or install everything:
```bash
make install-all
```

## Deploy

Just start the docker instances, the servers will start up.
```shell
docker-compose up -d;
```

## AWS Spot Instances

The idea here is when launching a spot instance for the first tiem, pull this repo, copy your configs to the appropriate locations and run the make commands through docker.

## TODO:

- Use AWS S3 cli tool to pull the custom configs automatically.
- Refactor folder structure.