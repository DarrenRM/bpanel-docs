---
title: Constants
---

Currently only the constants for listening to sockets are exposed. Read more about interacting with bcoin via [sockets](/docs/api_sockets.html).

### `addSocketConstants`
Should export a function that receives a sockets argument. Sockets should be an object with property `listeners` that is an array. Each item in that array is expected to be an object with an `event` property and an `actionType` property. The event is the name of the event you are listening for and actionType is what action you want dispatched when it is heard (you will want to add [`middleware`](/docs/api_middleware.html) or a [reducer](/docs/api_reducers.html) in order to act on this action).

Example:
``` javascript
export const addSocketConstants = (sockets = { listeners: [] }) => {
  // note that you will also have to `join` a wallet
  // before you can listen for transactions
  // learn more at the bcoin API docs at bcoin.io
  sockets.listeners.push({
    event: 'wallet tx',
    actionType: WALLET_TX
  });
}
```

Read more about working with sockets in bPanel [here](/docs/api_sockets.html).
