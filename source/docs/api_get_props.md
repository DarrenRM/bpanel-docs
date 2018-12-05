---
title: Get Props
---
For situations where you have a parent component that is connected to the Redux state (e.g. Panel, Header, or Footer) and have a child component you are decorating that needs access to specific props from the component (e.g. `Route`s, which are children of Panel), you need some mechanism to tell the parent what props it needs to pass down to the child.

Currently only `getRouteProps` is used anywhere in the core bPanel app, but `getProps` is also made available with the same API in case plugin developers want to utilize it in their own [widget-enabled plugins](/docs/api-decorate-plugins.html).

### `getRouteProps`
If you are making a plugin that has it's own view (i.e. a [`Panel`](/docs/api-decorate.html#decoratePanel)), then you are passing Panel a new component as a route. Often that component will need access to props from the state (or to dispatch to the state). You can use `mapComponentState` and have Panel get those props, but your route still needs be passed them.

The export is an object where the value matches the name of your plugin (also the url route). The value is a function that receives `parentProps` and `props` as arguments (where `props` is the existing map of props for the child component which you will be extending).

```
export const getRouteProps = {
  'my-view': (parentProps, props) => Object.assign(props, {
    newProp: parentProps.newProp
    })
}
```

### `getProps`
`getProps` works exactly the same, except that whatever component you are targeting to get the props from needs to implement `getProps` itself somewhere in its own class so that the props getter can be applied, e.g. `const newProps = getProps('MyComponent', this.props)`. Then a plugin could pass props through like this:

```
export const getProps = {
  MyComponent: (parentProps, props) => Object.assign(props, {
    newProp: parentProps.newProp
    })
}
```

Again, as this is not currently implemented on any bPanel components, it is unlikely you will need to use `getProps` directly.