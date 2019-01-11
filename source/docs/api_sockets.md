---
title: Sockets
---
In bPanel, sockets are almost entirely managed via a [redux middleware](/docs/api_middleware.html) called [`bsock-middleware`](https://www.npmjs.com/package/bsock-middleware) which implements the Socket.io-compatible [bsock library](https://github.com/bcoin-org/bsock). This helps to simplify and standardize web socket interaction with your node (and avoids having a situation where an instance of bPanel has many plugins all with their own socket connection to the server). As long as you dispatch actions that are properly formatted with a `bsock` property, the middleware will catch it.

(For an example of how to implement this in a working plugin, see [this guide](/docs/node_info.html#6-Connect-to-sockets)).

### Emit and Listen
These are the two main actions you are typically concerned with when dealing with sockets: either listening for events from the server or emitting your own (sometimes [expecting an acknowledgement](#dispatch)).

With listening, you are [passing constants](#addSocketConstants-register-listeners) to the middleware indicating which events you would like to listen for, and which action to dispatch when it is heard.

For emitting, you will dispatch an [`EMIT_SOCKET`](#EMIT-SOCKET) action creator with a `bsock` property containing an object with the information that describes the event you would like to emit. This object should include a `type` of event you would like to emit: `broadcast`, `dispatch`, or `subscribe` (read more below).

### Sockets API

- CONNECT_SOCKET and SOCKET_CONNECTED
- addSocketConstants (register listeners)
- EMIT_SOCKET
- broadcast
- dispatch
- subscribe

### `CONNECT_SOCKET` and `SOCKET_CONNECTED`
`CONNECT_SOCKET` is an action that is dispatched once the main app component has been mounted to the DOM. This goes through all the normal motions of connecting to the socket server. Once the connection has been established, `bsock-middleware` will dispatch a `SOCKET_CONNECTED` action. You can use this in your plugins to know when it is safe to establish subscriptions (join a wallet, watch the chain, etc.).

#### Example:
``` javascript
export const middleware = store => next => action => {
  if (type === 'SOCKET_CONNECTED') {
    console.log('Our socket is connected! Now we can interact with it');
  }
}
```

### `addSocketConstants` (register listeners)
This should export a function that receives a sockets argument. Sockets should be an object with a `listeners` property that is an array. Each item in that array is expected to be an object with an `event` property and an `actionType` property. The event is the name of the event you are listening for and actionType is what action you want dispatched when it is heard (you will want to add [`middleware`](/docs/api_middleware.html) or a [reducer](/docs/api_reducers.html) in order to act on this action).

#### Example:
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


### `EMIT_SOCKET`
The way that sockets work in the bPanel archicture is:

> client -> appServer -> bcoin node

When dealing with the bcoin socket API, what's actually happening is that in the `EMIT_SOCKET` action type, you're telling the `bsock-middleware` that manages the client what message you would like the appServer to transmit to the bcoin node (it's basically a proxy socket server). So in the action creator, you have a `bsock` property that contains an object and this object is used to tell the appServer what to emit to the bcoin node.

The `bsock` object expects the following properties:

| Property       | Required             | Type     | Example     |
| -------------  | -------------        | -----    | -------     |
| `type`         | yes                  | `string` |'broadcast'  |
| `message`      | yes                  | `string` |'watch chain'|
| `acknowledge`  | yes (for `dispatch`) |`function`|() => console.log('event acknowledged!')|
| `responseEvent`| yes (for `subscribe`)| `string` | 'new block' |

You can send whatever message you want to the server through the `bsock` property of the action. Generally, however, you want to send a `type` of `broadcast`, `dispatch`, or `subscribe` and a `message` that includes the event that you would like relayed to the bcoin (or bcoin compatible) node. All remaining arguments will be passed through as additional arguments in the relayed socket event (this is necessary sometimes for example when you need to send a filter for watching for transactions or to pass the idea of a wallet you want to watch).

Typically in a plugin you will dispatch an `EMIT_SOCKET` action through [`middleware`](/docs/api-middleware.html) or via [`mapComponentDispatch`](/docs/api_map_state.html#mapComponentDispatch). See below for examples.

### EMIT_SOCKET Types

### `broadcast`
A `broadcast` sends a message to the bcoin node. No acknowledgement is expected.

``` javascript
function watchChain() {
  return {
    type: 'EMIT_SOCKET',
    bsock: {
      type: 'broadcast',
      message: 'watch chain' // message to be emitted to node by appServer
      // you can send other arguments to the node by adding properties
    }
  };
}

export const middleware = ({ dispatch }) => next => action => {
  const { type } = action;
  if (type === SOCKET_CONNECTED) {
    dispatch(watchChain());
  }
  next(action)
}
```

### `dispatch`
A `dispatch` is just like a broadcast except that it expects a response. You must pass an `acknowledge` property with a function to fire when the event has been acknowledged. This function can even dispatch an action to the store (thanks to `redux-thunk`).

``` javascript
const leaveWallet = id => dispatch => {
    dispatch({
      type: EMIT_SOCKET,
      bsock: {
        type: 'dispatch',
        message: 'wallet leave',
        id,
        acknowledge: () => dispatch(removeWallet(id))
      }
    });
  };
}

const removeWallet = id => {
  return {
    type: REMOVE_WALLET,
    payload: { id }
  };
};

export const mapComponentDispatch = {
  Panel: (dispatch, map) =>
    Object.assign(map, {
      leaveWallet: id => dispatch(leaveWallet(id)),
    })
};
```

### `subscribe`
`subscribe` tells your appServer what events you want to listen for and the event to fire when it is heard. Because of this, you will generally want to also add a socket listener so your plugin can react when the subscribed to event is fired.

``` javascript
function subscribeBlockConnect() {
  return {
    type: 'EMIT_SOCKET',
    bsock: {
      type: 'subscribe',
      message: 'block connect',
      responseEvent: 'new block' // add a listener for this below
    }
  };
}

export const addSocketConstants = (sockets = { listeners: [] }) => {
  sockets.listeners.push({
    event: 'new block', // the responseEvent that will be fired on `block connect` from the node server
    actionType: ADD_NEW_BLOCK
  });
};

export const middleware = ({ dispatch }) => next => async action => {
  if (action.type === 'SOCKET_CONNECTED') {
    // subscribe to this event once our socket is connected
    dispatch(subscribeBlockConnect());
  }
  next(action);
};

```