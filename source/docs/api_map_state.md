---
title: Map State & Dispatch
---

Plugins can share state between each other thanks to redux's state being a single source of truth. Anything in the application state can be accessed by other plugins via [`mapComponentState`](#mapcomponentstate) and the state can be updated with reducers via [`mapComponentDispatch`](#mapcomponentdispatch).

The idea here is that you are telling a target component what you need it to pull from the state (or dispatch to it). That will get passed as a prop to that component (the next step in some cases is to use [`getProps`](/docs/api-getprops.html) to tell that component to pass it down to your plugin)

In order to generalize these extensions, the export is expected to just be an object with at least one key that maps exactly to the name of the component you are mapping (what this is basically doing is extending the default `connect` from the [`react-redux`](https://github.com/reactjs/react-redux/blob/master/docs/api.md#connectmapstatetoprops-mapdispatchtoprops-mergeprops-options) library for the target component). The value is a function that accepts two properties: the first is either `state` or `dispatch` and the second is a `map` property that contains all other existing state/dispatch decorators for that component.

Only these components are valid keys for either mapper:
- `Header`
- `Footer`
- `Panel`
- `App`
- `Sidebar`

### `mapComponentState`
As an example, let's say we want to display the network our node is connected to (e.g. mainnet, testnet, regtest) in our header. This information is available in our store. So all we have to do is map the state to the props for the header.

```
export const mapComponentState = {
  Header: (state, map) =>
    Object.assign(map, {
      network: state.node.node.network
    })
};
```

That's it! Then when we use [`decorateHeader`](/docs/api-decorate.html#decorateHeader), `network` will be available as a prop in `this.props`.

### `mapComponentDispatch`
Dispatch is almost exactly the same except here you're mapping a prop to a dispatched action.

```
const addWallet = id => {
  type: 'ADD_WALLET',
  payload: id
}

export const mapComponentState = {
  Header: (dispatch, map) =>
    Object.assign(map, {
        addWallet: id => dispatch(addWallet(id))
      })
}