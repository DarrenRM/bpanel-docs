---
id: api-reducers
title: Reducers
sidebar_label: reducers
---

The plugin API also exposes certain parts of the store's reducer. You can target these reducers by exporting one of the decorating functions described on this page (more may be added in the future).

Available extensions:

<AUTOGENERATED_TABLE_OF_CONTENTS>

A description of reducers in redux from the [docs](https://redux.js.org/basics/reducers):

>Reducers specify how the application's state changes in response to actions sent to the store. Remember that actions only describe the fact that something happened, but don't describe how the application's state changes.

So with these extensions, you are indicating how you want the app state to change based on specific actions that have been [dispatched](/docs/api-map-state-dispatch.html) to the store. Each individual reducer extension is targeting a specific part of the state.

To get information about the shape of the part of the state you would like to interact with, we recommend using the [Redux DevTools Extension](https://github.com/zalmoxisus/redux-devtools-extension).

__NOTE__: The state in bPanel is kept immutable using the [`seamless-immutable`](https://www.npmjs.com/package/seamless-immutable) library. Read more about their API in the docs to learn how to update the state.

## Available Reducers:
### `reducePlugins`
This is a "catch-all" reducer. Its initial state with no plugins is simply an empty object and
its only built-in action type is `ADD_PLUGIN`. This reducer lets you add a new plugin
store when dispatched, keyed to an id passed inside the payload. This is not strictly necessary
to add to the plugins store, but it's useful if you want bPanel to check for conflicts (it won't
allow for two plugin stores with the same id). Doing it on your own, there is no guarantee that
your reducer won't overwrite the state from another plugin, so adding a unique prefix
as identifier to your store id, regardless is a good idea and the responsibility of each
plugin developer.

(We plan to add a more robust custom reducer system in the future)

The first step is to setup your initial state by catching the `APP_LOADED` action
in your middleware, and dispatching `ADD_PLUGIN` with the unique id and the rest of your state
in the payload (this step isn't necessary with other reducers since their state is already
initialized).
```javascript
// index.js
export const middleware = store => next => action {
  const { dispatch } = store;
  if (action.type === 'APP_LOADED') {
    dispatch({
      type: 'ADD_PLUGIN',
      payload: {
        id: 'myplugin_store1',
        arrayToStore: [],
        children: {},
        otherProps: {}
      }
    });
  }
  // make sure to call next so other
  // plugins can see app has loaded
  next(action);
}
```

Then just extend the reducer like you would for any other:

```javascript
// index.js
export const reducePlugins = (state, action) => {
  switch (action.type) {
    case 'ADD_MY_UNIQUE_ARRAY': {
      // using seamless immutable API
      const pluginStore = state.getIn(['myplugin_store1']);
      const arr = [...pluginStore.arrayToStore];
      arr.push('some item');
      return state.setIn(['myplugin_store1', arrayToStore], arr);
    }
  }
}
```

### `reduceChain`
Actions types currently implemented in the chain reducer are:

- `SET_CHAIN_INFO`
- `SET_GENESIS`

Example:
```javascript
// This will return an immutable version of state with a new `snapshot` property that is a snapshot of the current tip hash.
// Pretty useless reducer but gives an idea of functionality
export const reduceChain = (state, action) => {
  switch (action.type) {
    case 'MY_CUSTOM_ACTION': {
      const snapshot = state.getIn(['tip']);
      return state.set('snapshot', snapshot);
    }
  }
}
```

### `reduceNode`
(See [`reduceChain`](#reduceChain))
### `reduceWallets`
(See [`reduceChain`](#reduceChain))