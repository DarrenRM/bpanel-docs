---
title: Interacting with the Blockchain
---
bPanel offers several ways to interact directly with the Bitcoin Blockchainthrough bcoin. All functionality that is available through the bcoin API (which supports: RPC, WebSockets, and REST) can be accesed in bPanel plugins.

Whether you want to manage wallets, get node information, blacklist peers, even mining operations, if it's available in bcoin, you can build a plugin that interacts with the interface.

For the REST API and RPC, simply use the [clients available in bpanel-utils](/docs/api_bpanel_utils.html#Clients).
>Read more about working with sockets in bPanel [here](/docs/api_sockets.html).

The [Node Info](/docs/node_info.html) guide has working examples of working with sockets and the REST API.