---
title: Reducers
---
The accepted convention for reducers and the application state in bPanel is for top level store, e.g. `node`, `chain`, etc., to be representative of the state of your bcoin node. So if a plugin wants to retrieve the chain height, or update it based on an event, you know you can access it from `state.chain.height`. For plugin specific reducers, there is a special `plugins` store you can use. See `reducePlugins` extension below which also helps avoid naming collisions.

## The API

The plugin API exposes certain parts of the store's reducer. You can target these reducers by exporting one of the decorating functions described on this page (more may be added in the future).

Available extensions:

- pluginReducers
- navStore
- persistReducers
- reducePlugins (deprecated)
- reduceChain
- reduceNode
- reduceWallets

A description of reducers in redux from the [docs](https://redux.js.org/basics/reducers):

>Reducers specify how the application's state changes in response to actions sent to the store. Remember that actions only describe the fact that something happened, but don't describe how the application's state changes.

So with these extensions, you are indicating how you want the app state to change based on specific actions that have been [dispatched](/docs/api_map_state.html#mapComponentDispatch) to the store. Each individual reducer extension is targeting a specific part of the state.

To get information about the shape of the part of the state you would like to interact with, we recommend using the [Redux DevTools Extension](https://github.com/zalmoxisus/redux-devtools-extension).


## Available Reducers:

### `pluginReducers`
Often a plugin will want to add its own store and corresponding reducers to the app state. This can have numerous advantages including simplifying the control flow of the state for your components. Significantly, it can also enable other plugins to interact with your plugin by providing an interface, via redux, for reading your plugin's state and even hooking into action dispatches via middleware.

You can also have the app persist your plugin state across browser sessions using the browser's localStorage. See [`persistReducers`](#persistReducers) below for more.

#### combineReducers
bPanel uses redux's `combineReducers` utility method to implement and merge the state of all plugins with their own store. This happens during the build stage when bPanel will take all plugin reducers merge them into a single object, and add them to the root reducer under the store `plugins`.

Shape of the store:
```javascript
{
  node: {...},
  chain: {...},
  wallets: {...},
  theme: {...},
  pluginMetadata: {...},
  plugins: {
    myCustomPlugin: {...}, // this will be initialized w/ your initial state and updated w/ your reducer
    otherPlugin: {...}
  }
};
```

To add your own custom reducer and initial state, simply create your reducer as you normally would with redux and pass it in via an object, exported with `pluginReducers`. You can pass as many top level reducers as you want or nest multiple reducers under your own top level reducer.

```javascript
function bp_foo(state = { foo: 'bar' }, action) {
  const newState = { ...state };
  switch (action.type) {
    case 'SET_FOO':
      newState.foo = action.payload;
      return newState;
    default:
      return state;
  }
};

```

### `navStore`
Currently the nav store doesn't support decoration. By dispatching the appropriate actions however, you can add and remove items from the App's navigation.

#### ADD_SIDE_NAV
To add a new item to the side navigation, simply send a payload with an object that mirrors the shape of the [`metadata`](/docs/api_metadata.html) object for new plugins.

In addition you will also need to add a unique id. The built in `addSideNav` action creator in bPanel generates one automatically by taking the first 6 characters of the hash of your object.

##### Properties
| Property       | Required?     | Type        | Details     |
| -------------  | ------------- | --------    | -------     |
| `name`         | yes           | `string`    | Used to identify your plugin. Must follow npm naming rules  |
| `id`         | yes           | `string`      | unique id. This will be added to the link component in the DOM  |
| `displayName`  | no            | `string`    | Will default to `name` if none is provided |
| `pathName`     | yes            | `string`    | If building a view/panel, will be passed to react-router to use as URL of your view|
| `order`        | no            | `int`       | If including in sidebar, useful for ordering nav.<br>If order conflicts between plugins, will sort alphabetically |
| `icon`         | no            | `string`    | Also for sidebar navigation.<br>The name of the font awesome icon to use for your view nav  |
| `sidebar` or `nav`| no            | `bool`      | Default: `false`<br>If true, bPanel will automatically add sidebar navigation for your plugin view  |
| `parent`       | no            | `string`    | Currently no support, but will be used for<br>adding a plugin as child (both in path and in navigation) |

```javascript
// webapp/store/actions/navActions.js

function addSideNav(metadata) {
  assert(metadata.name, 'nav items must include a name');
  const { pathName, name } = metadata;

  // get hash for unique id
  const id = helpers.getHash(metadata, 'sha256', 0, 6); // utility available in bpanel-utils
  metadata.pathName = pathName ? pathName : name;
  return {
    type: 'ADD_SIDE_NAV',
    payload: { ...metadata, sidebar: true, id }
  };
}

export const pluginReducers = {
  bp_foo: bp_foo
  // export as many properties w/ corresponding reducers as you want
  // or use combineReducers to nest them under a single top level reducer
};
```

Now you can update your plugin state by dispatching an action:

``` javascript
 {
  type: 'SET_FOO',
  payload: 'baz'
 }
```

> Make sure you prefix your store with a unique id to avoid any conflicts
with other plugins.

### `persistReducers`
bPanel uses the [redux-persist package](https://www.npmjs.com/package/redux-persist) to allow plugin developers to persist state across browser sessions. This means that if you indicate you want a part of your store to persist, the app will rehydrate with the last known state whether you refresh or open in a new window or tab.

Note that currently the only capability you have as a plugin developer is to whitelist what you would like to persist. The default, top-level stores do not currently persist and simply hydrate from the node bPanel is communicating with. Make sure to take this into account to avoid your plugin being inconsistent with the state of the rest of the app.

The interface to persist a store is straightforward, simply export an array of strings matching to the plugin store you would like to persist:

```javascript
export const persistReducers = ['bp_foo'];
```

#### REMOVE_SIDE_NAV
To remove a sidebar item, you must pass an object with at least an `id` or `name` property matchingthe  item you would like to remove.

```javascript
// webapp/store/actions/navActions.js
function removeSideNav(metadata) {
  if (!metadata.id || !metadata.name)
    // eslint-disable-next-line no-console
    console.warn('Must pass an id or name to delete nav item');
  return {
    type: 'REMOVE_SIDE_NAV',
    payload: metadata
  };
};
```

### `reducePlugins` (deprecated)
`reducePlugins` has been deprecated and is no longer supported in bPanel. If you have a plugin that currently uses this interface, please upgrade to the [pluginReducers](#pluginReducers) API instead

### `reduceChain`
Actions types currently implemented in the chain reducer are:

- `SET_CHAIN_INFO`
- `SET_GENESIS`

Example:
```javascript
// This will return a new `snapshot` property that is
// a snapshot of the current tip hash.
// Pretty useless reducer but gives an idea of functionality
export const reduceChain = (state, action) => {
  const newState = { ...state };
  switch (action.type) {
    case 'MY_CUSTOM_ACTION': {
      const snapshot = action.payload;
      newState.snapshot = snapshot;
      return newState;
    }
  }
};
```

### `reduceNode`
(See [`reduceChain`](#reduceChain))
### `reduceWallets`
(See [`reduceChain`](#reduceChain))