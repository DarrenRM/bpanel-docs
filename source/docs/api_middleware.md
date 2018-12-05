---
title: Middleware
---
Middleware is an important and powerful feature of redux that allows you to intercept actions dispatched by the store. One of the most common use cases for this is in debugger tools or async action libraries. bPanel has a few middleware modules installed by default: `redux-thunk`, `bsock-middleware`, `redux-devtools-extension`, and `effects-middleware`.

From the redux documentation:

>Redux middleware solves different problems than Express or Koa middleware, but in a conceptually similar way. It provides a third-party extension point between dispatching an action, and the moment it reaches the reducer. People use Redux middleware for logging, crash reporting, talking to an asynchronous API, routing, and more.

You can read more about how middleware works [here](https://redux.js.org/advanced/middleware).

## Usage
Thanks to some [magic JavaScript currying](https://hackernoon.com/currying-in-js-d9ddc64f162e), the middleware extension gives us access to a lot of useful tools: the store (both `dispatch` and `getState`), `next` (to continue the dispatch), and `action` (the actual action being dispatched).

Example:
```
export const middleware = store => next => action => {
  const { dispatch, getState } = store;

  const chain = getState().chain // getting the current state of the chain from the store

  if (action.type === 'ADD_NEW_BLOCK') {
    // dispatching a custom action
    dispatch({
      type: 'MY_NEW_BLOCK_ACTION',
      payload: { currentTip: chain.tip }
    });
  } else if (action.type === 'NEW_WALLET') {
    const newPayload = Object.assign(action.payload, {foo: 'bar'});
    action.payload = newPayload;
    // now any reducers that react to the 'NEW_WALLET' action,
    // will have a `foo` property in the payload.
    return next(action);
  }
  // Generally, unless you want to stop any subsequent reactions to the action,
  // you want to default to calling next with the action.
  return next(action);
}
```

Middleware can be an extremely powerful tool in your plugin development, especially when used together with the other extensions. For example, you could use [sockets](/docs/api-sockets.html) to listen for a new event on the node, intercept the resulting dispatched action with middleware to mutate the payload, and then update the state using a [custom reducer](/docs/api-reducer.html) in response!