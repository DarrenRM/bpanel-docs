---
title: Interacting with the Blockchain
---
bPanel offers several ways to interact directly with the Bitcoin Blockchain
through bcoin. All functionality that is available through the bcoin API
(which supports: RPC, WebSockets, and REST) can be accesed in bPanel plugins.

Whether you want to manage wallets, get node information, blacklist peers,
even mining operations, if it's available in bcoin, you can build a plugin
that interacts with the interface.

For the REST API and RPC, simply use the
[clients available in bpanel-utils](/docs/bpanel-utils.html#clients).
Read more about working with sockets in bPanel [here](/docs/api-sockets.html).

The [Node Info](/docs/guide-node-info.html) guide has working examples of working with sockets and the REST API.

Check out the full [bcoin API documentation](http://bcoin.io/api-docs/index.html) for
more information on what is available.