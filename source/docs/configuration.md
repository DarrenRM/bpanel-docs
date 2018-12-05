---
title: Configuration
---
bPanel can be configured to connect to any bcoin-API compatible node you want to
point it to. Save as many different conf files as you want and easily
point your bPanel app to refer to any node you want, not just the docker
container created by the default `docker-compose.yml` configurations.

### Quick Links
- [Connecting to Custom Nodes](#client-configurations)
- [Using Docker](#configuration-between-docker-services)
- [Bcoin Setup Scripts (for Docker)](#bcoin-setup-scripts)

## How bPanel Connects to Nodes
Since bPanel just uses [`bclient`](https://github.com/bcoin-org/bclient) to connect
to and query nodes, all you need to do is pass the appropriate congifurations when starting up
bPanel. This can be done via the command line, environment variables (prefaced with `BPANEL_`),
or through a configuration file. Under the hood, bPanel uses the `bcfg` module
to accomplish this. Learn more about `bcfg` [here](https://github.com/bcoin-org/bcfg).

### Client Configurations
bPanel looks for configuration files in your home directory in `~/.bpanel`.
This can be changed by passing a `prefix` argument at runtime.
Client configurations for connecting to different nodes are loaded from the
`clients` directory, `~/.bpanel/clients/[CLIENT-ID].conf`.

You can have as many different configurations as you want. bPanel will default to a `default.conf`
configuration. To use different configurations, just pass in a `client-id` argument at runtime.
e.g. `npm start -- --client-id=test` (or as an env variable `BPANEL_CLIENT_ID=test`) which
will load configs from `~/.bpanel/clients/test.conf`.

The clients directory can also be customized with the `clients-dir` argument.

Sample conf files for the client can be found
[here](https://github.com/bpanel-org/bpanel/tree/master/etc/sample.client.conf).

Since node and wallet services are run on different servers,
you will likely need different configurations to connect to the wallet. These
should be in the same client conf file, prefaced with `wallet-` (note that bcoin looks for these
in separate config files). See the sample conf file for an example.

## Configuration between Docker services

### About the Docker Environment
There are three docker services in the compose file: `bpanel`, `bcoin` and `securityc`.
The `bpanel` service is an http server that acts as a static file server and as a request router
to backend services as well as a webpack process for building your js files.
The `bcoin` service is an instance of `bcoin` that supports an http
server, a wallet server and a bitcoin p2p server.

The `securityc` service generates TLS keys and certs and runs a TLS terminating reverse proxy.
You can use custom configs to connect to an existing node,
or use the bcoin docker service to spin up a bcoin node that the webapp will connect to.

### Configuring Docker Services
These instructions are for if you want to run bPanel within the `bpanel` service and have it talk to
a bcoin node running in a container from the `bcoin` service. For example, this is how bPanel works
out of the box if you simply run `docker-compose up -d`.

Configurations are shared between the two docker containers using a shared
docker volume called `configs`. Settings for the bcoin nodes in docker
are set using environment variables, either in docker-compose.yml or
an env file (by default in `/etc/bcoin.env` but you can point to whichever and
as many env files as you want using the `env_file` configuration in the bcoin
service). The bcoin node is started with the `bcoin-init.js` script. During this
process, api keys are generated and all required configurations are saved in a config
file called `_docker.conf` in the shared volume.

If the configs volume is mounted to your host machine, you can connect a local
version of bPanel to it by pointing the `client-id` config at `_docker` and it will
use the appropriate configs.

If you are mounting a local bcoin data dir (`~/.bcoin`) or persisting using docker volumes,
you can also pass settings to your bcoin docker container with a `bcoin.conf`
file (read more about bcoin configurations
[here](https://github.com/bcoin-org/bcoin/blob/master/docs/Configuration.md)).

## Bcoin Setup Scripts
(This section is only relevant if you will be running a bcoin node in a docker container
using the `bcoin` service, or using the `bcoin-init.js` script to start a node.)

This setup supports setup scripts for your bcoin node. This will allow you to run
scripts on your node for a repeatable and predictable environment for testing or development.

Three circumstances need to be met to run a script:
1. There needs to be a js file to run in the `scripts` directory that exports a function
1. You need to pass the name of this file (including the extension)
as an environment variable named `BCOIN_INIT_SCRIPT` in the docker-compose or as a
`init-script` setting in your `bcoin.conf` file
1. There should be no walletdb in the container.
This last requirement makes sure that a setup script doesn't overwrite your data
if you're mapping volumes or if you restart a container.

These checks are done in `bcoin-init.js` which is run by the bpanel/bcoin image
that is used to create the `bcoin` container and sets up a node based on the configs
described above. Setup scripts are passed the bcoin node object that has been
created so the scripts have access to the node being started at run time as
well as the relevant configs.

Example setup scripts can be found in the `/scripts` directory (`funded-dummy-wallets.js`
and `setup-coinbase-address.js`).