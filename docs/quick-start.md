---
id: quick-start
title: Quick Start
sidebar_label: Quick Start
---
bPanel is still in alpha, so while we wish there was a one click install (and it is on the road map), there is a small amount of setup required to get things running first.

- [Start bPanel](#start-bpanel)
- [Customizing your Setup](#customizing-your-setup)
- [Setup without docker](#running-without-docker)
- [Connecting to your own node](#connecting-to-your-own-node)

First, download the project files with the link below:

<p style="text-align:center;">
  <a class="button" href="https://github.com/bpanel-org/bpanel/archive/master.zip">Download bPanel</a>
</p>

Configuration for the quick start with docker is all done with the local
docker-compose.yml file.

If you don't have docker installed locally, download and install here:

<p style="text-align:center;">
  <a class="button" href="https://www.docker.com/get-docker">Get Docker</a>
</p>

To spin up a bPanel http server, a bcoin node on regtest,
and mine 101 blocks (and generate lots of fake Satoshis for you to play with), navigate to your repo and run:

## Start bPanel
This is primarily a setup for development purposes
(though it could be used in production with some modification).

### Running with docker

To start the application, clone the repository and navigate to the root of the project.
1. Run `npm install` to setup dependencies and configuration directories.
1. Run `docker-compose up -d`
1. Navigate to http://localhost:5000 or https://localhost to see your webapp
(might take a few minutes if running for the first time).

This will build the web application, start the http server, reverse proxy,
bcoin node and wallet server in containers.

#### Persistent DBs
To persist your bcoin node information (and skip the setup if the walletdb is persisted),
uncomment and edit the volumes in the bcoin service (this should be uncommented by default).
This is useful if you're working on testnet or mainnet and don't want to wait for a full sync
to happen every time you create a new container.

#### Running without docker

If you want to run bPanel outside of the container, e.g. for development purposes:
1. Run `npm install`
1. Run `docker-compose up -d bcoin` to run just the bcoin service as a
background daemon
1. For mac users, run `npm run start:poll` otherwise run `npm run start:dev`. Add `-- --client-id=_docker` to the end of the command to indicate you want to
connect to the docker container.
1. Navigate to http://localhost:5000 to see your webapp.

Requests to `/bcoin` are routed to the bcoin node.
Requests to `/bwallet` are routed to the bcoin wallet server.

## Connecting to your own node
bPanel can be run entirely independent of any local bcoin node. This can be
using configuration files. If you already have configuration files setup
in `~/.bpanel/clients`, just pass in the id of the conf file when starting up
bPanel

```javascript
npm run start:poll -- --client-id=my-conf
```

Read more about bPanel configuration [here](/docs/configuration.html).

## Extending bPanel
The bPanel UI is built entirely around plugins.
All visual elements can be extended or overridden via the plugin system
including the header, footer, sidebar, and main panel/view element.
To get started making your own plugin, use the
[bPanel-cli](/docs/plugin-started.html)

### Server extensions
The simplest thing to do, is to create your own server file that includes `server/index.js`.
```
const bpanel = require('./index.js')({
  network: 'main', // Put bPanel configs here (optional)
});
const app = require('express')();
app.use( /* Put your own middleware here */ );
app.use( bpanel );
app.listen();
```
