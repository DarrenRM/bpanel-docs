---
title: Decorate
---
This is the part of the API where you are generally extending your views (i.e. the visual components). If you're familiar with how [Higher Order Components](https://medium.com/@franleplant/react-higher-order-components-in-depth-cf9032ee6c3e) work in React, then you should be comfortable with this interface. The short version is that you want to export a function that accepts a React component (and an object with `React` and `PropTypes`) as arguments and then returns a new React Component that has been decorated by your component.

(**NOTE**: In most cases you will also want to pass props down from the parent component that you are decorating down to your custom component. In order to do this you will need to use [`getProps`](/docs/api_get_props.html)).

In most cases, the `render` method of your returned component should return the component it was originally passed with props for any custom children you want to decorate it with.

The available decorators are:
- `decoratePanel`
- `decorateHeader`
- `decorateFooter`
- `decorateSidebar`
- `decoratePlugin`

## Decorators
### `decoratePanel`
This is probably one of the most important decorators as it allows you to create entire routes for your plugin (i.e. a full page view that you can navigate to by a URL path or the page navigation). Because you are creating a new route, the `customChildren` prop you pass to the returned component is a little different from the others as well: The Panel component in the app is basically an array of routes, and you will be concatenating this array with an object that has your view's name and the component.

``` javascript
import MyPanel from './components/MyPanel';

export const decoratePanel = (Panel, { React, PropTypes }) => {
  return class extends React.Component {
    static displayName() {
      return 'my panel';
    }

    static get propTypes() {
      return {
        customChildren: PropTypes.node
      };
    }

    render() {
      const { customChildren = [] } = this.props;
      const routeData = {
        metadata, // this should be the metadata object from your plugin
        Component: MyPanel
      };
      return (
        <Panel
          {...this.props}
          customChildren={customChildren.concat(routeData)}
        />
      );
    }
  };
};
```

You can create a custom navigation for your view via [`decorateSidebar`](#decorateSidebar) or use the built in system via your plugin's metadata:

``` javascript
export const metadata = {
  name: 'my-plugin',
  author: 'bcoin-org',
  sidebar: true, // set to true to show nav item in sidebar
  icon: 'home', // the name of the font awesome icon you would like to use
  order: 0, // what order to include it in the sidebar, uses alphabetical as a fallback in case of collisions)
  parent: '' // if is meant to be a sub-view, indicate name of parent
};
```

#### Multiple Views in One Plugin
Since the Panel container is just being decorated, with each new view being concatenated in a `routeData` property, you can add as many views as you want. The only thing you need to do is manually add the navigation since `metadata` only supports adding one sidebar item. Using `decorateSidebar`](#decorateSidebar) and the `SidebarNavItem` from the `bpanel-ui` library, you can easily add new sidebar items that match the style of existing navigation.

### `decorateHeader`
For `decorateHeader`, your returned component should have a `customChildren` prop that is a React component. It will also receive a  customChildren` prop though and it is important to pass that through in your component (unless you want to overwrite the decoration of any other plugins that have already decorated the header).

``` javascript
export const decorateHeader = (Header, { React, PropTypes }) => {
  return class extends React.PureComponent {
    static displayName() {
      return 'my header';
    }

    static get propTypes() {
      return {
        customChildren: PropTypes.node,
      };
    }

    render() {
      const { customChildren: existingCustomChildren } = this.props;
      const customChildren = (
        <div className="container">
          {existingCustomChildren}
          My custom header content
        </div>
      );

      return <Header {...this.props} customChildren={customChildren} />;
    }
  };
};
```

### `decorateFooter`
See [`decorateHeader`](#decorateHeader)

### `decorateSidebar`
`decorateSidebar` exposes several hooks via `props` that you can use to extend the sidebar of your app:

- `beforeNav`
- `afterNav`
- `sidebarNavItems`
- `customSidebarHeader`
- `customSidebarFooter`

Most of these are pretty self-explanatory and work the same as `customChildren` in `decorateHeader` and `decorateFooter`. The only one that is a little tricky is `sidebarNavItems`. This is basically the list of navigation links in the sidebar. Hooking into this gives you a lot more control over the appearance of your navigation. In order to use this though, Sidebar also receives the `location` prop necessary for React Router routing.

We have also provided a common UI component called `SidebarNavItem` via `bpanel-ui` that you can use and extend to make sure your navigation stays visually consistent with the rest of the app (it will inherit theming properties).

``` javascript
import { SidebarNavItem } from 'bpanel-ui';

export const decorateSidebar = (Sidebar, { React, PropTypes }) => {
  return class extends React.PureComponent {
    static displayName() {
      return 'my nav';
    }

    static get propTypes() {
      return {
        sidebarNavItems: PropTypes.array,
        location: PropTypes.shape({
          pathname: PropTypes.string
        })
      };
    }

    render() {
      const {
        sidebarNavItems: existingNavItems,
        location: { pathname = '' }
      } = this.props;

      const newNavItem = React.createElement(SidebarNavItem, {
        pathname, // this is the current `window.location` useful for telling your navigation what url you are on
        ...metadata // SidebarNavItem will grab what it needs from here, e.g. name, pathName, icon, etc.
      });

      const _sidebarNavItems = existingNavItems.concat(newNavItem);

      return <Sidebar {...this.props} sidebarNavItems={_sidebarNavItems} />;
    }
  };
};
```

### `decoratePlugin`
Since this requires a plugin that supports decoration by other plugins, this is a more advanced feature. Read more about how to enable this in your own plugin: [Decorating Plugins](/docs/api_decorate_plugins.html).

The only thing you need for the decoratePlugin export is an object with at least one property. The property key should match the exact name of the plugin you are trying to decorate. The value should be a Higher Order Component that returns your decorated plugin component. If the plugin you are decorating follows the [correct convention](/docs/api_decorate_plugins.html), then the API should work the same as when you're decorating other views in the app.

For example, assuming there is a plugin called "myPlugin" that allows itself to be decorated with widgets:

``` javascript
const decoratePlugin = (MyPlugin, { React, PropTypes }) => {
  return class extends React.Component {
    constructor(props) {
      super(props);
    }

    static displayName() {
      return 'my widget';
    }

    static get propTypes() {
      return {
        customChildren: PropTypes.array,
      };
    }

    render() {
      const customChildren = (
        <div>
          Here is the text for my custom widget!
          // make sure to also include customChildren from props
          // otherwise you will lose any other widgets
          {this.props.customChildren}
        </div>
      );

      return <MyPlugin {...this.props} customChildren={customChildren} />;
    }
  };
};

// Note that the name you're passing as the value doesn't actually matter. The decoratePlugin API simply looks for a key that matches the name of the target plugin.
export const decoratePlugin = { myPlugin: decoratePlugin };
```

Make sure to read more about how to [let your own plugin be decorated](/docs/api_decorate_plugins.html) by widgets!