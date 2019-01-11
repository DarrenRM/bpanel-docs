---
title: Introduction
---
Our goal with bPanel was to build a completely new kind of blockchain interface on top of one of the most advanced blockchain implementations. Rather than try and create something that solves all use cases, or focus on one or two of the most common problems, we believe that the best way to create new, effective, and secure user experiences is to enable a diverse ecosystem of developers to come up with novel approaches that no one team could imagine on their own.

In the world of CMS's, projects like WordPress and Drupal started as ways to let people without much specific platform expertise to easily organize simple content, primarily blog posts. This ended up creating a whole industry of developers building diverse categories of websites on these platforms. As of April, 2016, over 26% of all websites run on WordPress, from large newspapers to photography portfolios and ecommerce platforms, far beyond the originally envisioned blogs.

A Blockchain Management System, or BMS, like bPanel aims to do something similar in the world of blockchain interfaces. Rather than relying on one company for your wallet interface, another for hardware wallet interfaces, and another for a block explorer (to say nothing of needing deep technical and command line expertise to run enterprise tasks like transaction and node management), why not have a single platform where you can install plugins and themes that solve each of these problems. This gives the user the ability to mix and match their ideal interface. All of this backed by the enterprise-level security and robustness of [bcoin](http://bcoin.io).

>**Much like how CMS's created a whole new way to interact with _centralized_ databases, a BMS will revolutionize how we interact with, and build on, _decentralized_ databases.**

The possibilities of things that can be built with a BMS are potentially endless:
- Multisignature transaction management
- Advanced wallet feature support
- Peer management on your node
- Block explorers with advanced visualizations
- Advanced transaction scripting and validation
- Time-locked kill switch transactions
- Key management
- Password management built on proven cryptography

## Architecture
The [default configuration](/docs/quick_start.html) for bPanel uses `docker-compose` to manage multiple docker containers. It will launch an app server that acts as a router and static file server, a TLS terminating nginx reverse proxy, a bcoin full node and a bcoin wallet server. Any of these services can be ran on their own - with the proper configuration, it is possible to use bPanel with a remote bcoin node. (It is even possible to create a plugin that runs a bcoin node directly in the client).

![bpanel architecture]( /docs/img/tech-diagram.png "bpanel architecture")

The goal is to enable a flexible developer experience. You could host your app server remotely, allowing for multiple users to access it from different clients and all talking to the same remote node. With bcoin's support for a separate wallet server, you can have a bPanel setup that is only meant to interact with a wallet server or only a node (Full, SPV, or Neutrino). You could use bcoin's built-in wallet services to manage wallets and accounts or handle key management locally in the clients. This also provides an extra layer of security by not giving users direct access to your node.

Some plugins require the webapp to be served over TLS.

![bpanel architecture]( /docs/img/bpanel-architecture.png "tls architecture")

The default `docker-compose` starts a TLS terminating reverse proxy and generates the required certs automatically.

## Tech Stack
The App Server is built entirely with NodeJS and Express. WebSocket management uses bcoin's native WebSocket implementation, bsock (compatible with the Socket.io API). Currently there is no persistent storage support outside of bcoin's own chain and wallet databases and local storage (though it is planned for future releases).

The front-end and plugin system are built with React and Redux. Redux is also used to [manage the socket client](/docs/api_sockets.html) through a middleware called [bsock-middleware](https://www.npmjs.com/package/bsock-middleware).

The Bootstrap grid system (v4) is used to support responsive layouts and a custom [theming system](/docs/theming_started.html) using [aphrodite](https://www.npmjs.com/package/aphrodite-simple) for advanced inline style support are used for styling and CSS.

>You can read more about how the plugin system is designed and how to develop your own plugins [here](/docs/intro_plugin.html).
