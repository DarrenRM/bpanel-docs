---
title: bPanel UI Utilities
---

The following utilities help standardize implementation of your components
as well as to work more easily with bPanel themes.

### `connectTheme`
`connectTheme` is what allows you to use the global theme object in your own
components. If you are using the theme state to style your components,
then your plugin will always match the style of the rest of bPanel.

`connectTheme` is a React [Higher Order Component](https://medium.com/@franleplant/react-higher-order-components-in-depth-cf9032ee6c3e)
that takes a component and decorates it with the theme object passed through its context.
Any component decorated by `connectTheme` will automatically have the theme available as a prop.
This also means that all [themeConfigs](/docs/theming-started.html#theme-config), even custom ones you've added, will be available.

```
import React from 'react';
import PropTypes from 'prop-types';
import { utils } from '@bpanel/bpanel-ui';

const { connectTheme } = utils;

const MyComponent = ({ theme }) =>
  <div style={{ borderColor: theme.themeVariables.themeColors.highlight1 }}>
    Hello World
  </div>

MyComponent.propTypes = {
  theme: PropTypes.object
};

export default connectTheme(MyComponent);
```

### `createNestedViews`
`createNestedViews` is a Higher Order Component (HOC) utility to help you create nested view components
for your plugins. This allows you to add more navigation to your plugin rather than have your entire UI
in a single view. This only outputs the view components themselves and not the actual navigation. To add
navigation to your views, you can either create your own custom links using the bpanel-ui `Link` component,
or leverage the [nav reducer](/docs/api-reducers.html#navstore) within bPanel.

The routing system in bPanel uses React Router v4. To learn more about their API, please visit their
[docs](https://reacttraining.com/react-router/web/api).

`createNestedViews` takes three arguments: an array of children views, a "Home" component, and a "Not Found"
component. Only the array of children views is required. A child view should be an object with two properties:
`path` and `component`. `path` is a string representing the relative path where the child component should be rendered
and `component` is a function that takes a `props` arguments and should return a React Component.

Note that the path should include the full, relative path. So if your main plugin view is at `my-plugin` and you
want the child to render at `/my-plugin/child`, the `path` property would be `/my-plugin/child`. If your component
is decorating `Panel`, you will also have access to the [`match`](https://reacttraining.com/react-router/web/api/match)
property from React Router. Using `match.url` is an easy way to build your relative paths.

#### Nested Views Example
Let's look at an example to see how this works. You can add the below code in a plugin index.js file in your local plugins
directory (remember to add the plugin name to your 'localPlugins' list in your plugins config).


```javascript
import {
  Header,
  Button,
  Link,
  Text,
  createNestedViews
} from '@bpanel/bpanel-ui';
import React from 'react';
import PropTypes from 'prop-types';

export const metadata = {
  name: 'test-children',
  displayName: 'Test',
  pathName: 'Tester',
  nav: true,
  icon: 'flask',
  order: 0
};

// The Child component will have access to all custom props
// as well as props passed through from React Router
const Child = props => (
  <div className="child">
    <Header type="h3">Child: {props.displayName}</Header>
    <Text type="p">Name: {props.name}</Text>
    <Text type="p">ID: {props.id}</Text>
  </div>
);

// Home and NoMatch are optional views you can add as defaults
const Home = () => (
  <div className="child">
    <Header type="h3">Home- Click button to generate children</Header>
  </div>
);


const NoMatch = () => (
  <div className="child">
    <Header type="h4">404: Could Not Find That Path</Header>
  </div>
);

// boilerplate for decorating Panel so you can view your component
export const decoratePanel = (Panel, { React, PropTypes }) => {
  return class extends React.Component {
    static displayName() {
      return metadata.displayName;
    }

    static get propTypes() {
      return {
        customChildren: PropTypes.array
      };
    }

    render() {
      const { customChildren = [] } = this.props;
      const routeData = {
        metadata,
        Component: Test
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

class Test extends React.PureComponent {
  constructor(props) {
    super(props);
  }

  static get propTypes() {
    return {
      match: PropTypes.object
    };
  }

  render() {
    const { match } = this.props;

    // create the first route
    const route1 = {
      path: `${match.url}/child-1`,
      component: props => (
        <Child displayName="Child 1" name="child-1" id="1" {...props} />
      )
    };

    // create the second route
    const route2 = {
      path: `${match.url}/child-2`,
      component: props => (
        <Child displayName="Child 2" name="child-2" id="2" {...props} />
      )
    };

    // add the routes to an array
    const routes = [route1, route2];

    // create your new component using the `createNestedViews` HOC
    const NestedViews = createNestedViews(routes, Home, NoMatch);

    return (
      <div>
        <Header type="h3">Main Container</Header>
        <div>
          <Button type="action">
            <Link to={`${route1.path}`}>Child 1</Link>
          </Button>
        </div>
        <div>
          <Button type="action">
            <Link to={`${route2.path}`}>Child 2</Link>
          </Button>
        </div>
        <NestedViews match={match} />
      </div>
    );
  }
};

```

Your nested view component should look something like this:

![nested views](/img/nested-views.gif "nested views")

Not pretty, but it gets the job done!


### `errorWrapper`
`errorWrapper` is a Higher Order Component for catching errors in your plugin or widget.
Top level plugins that decorate Panel already do this by default however for widgets that
are decorating another plugin for example, this helps to make sure that just the widget
crashes and not the whole plugin/view. `widgetCreator` also implements this by default.

Example:
```
import React from 'react';
import { errorWrapper } from '@bpanel/bpanel-ui';

class MyWidget extends React.PureComponent {
  componentDidMount() {
    throw 'A test error';
  }
  render() {
    <div>Hello World</div>
  }
}

export default errorWrapper(MyWidget);
```

### `widgetCreator`
A widget creator is for when you want to create a widget that [decorates another plugin](/docs/api-decorate-plugins.html).
For an example of this in action you can check out the [bPanel Dashboard](https://www.npmjs.com/package/@bpanel/dashboard) plugin
and available widgets for decorating it, such as the [Recent Blocks widget](https://www.npmjs.com/package/@bpanel/recent-blocks) which uses the `widgetCreator`.

Plugins are decorated by making certain hooks available in their render method. For the Dashboard, to add a widget on a decorator,
you can push it onto it as an array. `widgetCreator` will take a Component that's passed to it, wrappet it in `errorWrapper` and return a function that returns a React a component. This might change in the future, but using the widgetCreator to create your widget will ensure
that your component stays up to date with the API if there are any changes.

The returned Widget will expect one argument of a props object.

```
// myPlugin/components/MyWidget.js
import React from 'react';
import PropTypes from 'prop-types'
import { widgetCreator } from '@bpanel/bpanel-ui';

const MyWidget = name => <div>Hello: {name}</div>;
MyWidget.propTypes = { name: PropTypes.string };

export default widgetCreator(MyWidget);
```

```
// myPlugin/index.js
import MyWidget from './components/MyWidget';

const decorateDashboard = (Dashboard, { React, PropTypes }) => {
  return class extends React.PureComponent {
    constructor(props) {
      super(props);
    }
    static get propTypes() {
      bottomWidgets: PropTypes.array
    }

    render() {
      const { bottomWidgets } = this.props;
      bottomWidgets.push(MyWidget({ name: 'FooBar' }));
      return <Dashboard {...this.props} bottomWidgets={bottomWidgets} />;
    }
  }
}

export const decoratePlugin = { '@bpanel/dashboard': decorateDashboard };

```

### `makeRem`
`makeRem` takes a `size`, multiplies it by the `fontSizeBase`, then returns a size string with `'rem'` added to the end.
**Example**
```javascript
import { makeRem } from '@bpanel/bpanel-ui';

makeRem(5); // '5rem';
makeRem(10); // '10rem';
makeRem(0.5, 10); // '5rem';

```
More details on implementation [here](/docs/theming-variables.html#makerem).

### `makeGutter`
This is useful for creating style objects, taking a number and returning relative units
for use in a themeConfig or inline styles in your React Component.

**Example**
```javascript
// Example
import { makeGutter } from `@bpanel/bpanel-ui`;

makeGutter('padding', { left: 5, right: 5 }); // { paddingLeft: '5rem', paddingRight: '5rem' };
makeGutter('padding', { horizontal: 15, vertical: 10 }); // { paddingLeft: '15rem', paddingRight: '15rem', paddingTop: '10rem', paddingBottom: '10rem' };
makeGutter('margin', { all: 8 }); // { marginLeft: '8rem', marginRight: '8rem', marginTop: '8rem', marginBottom: '8rem' };
```

More details on implementation [here](/bpanel-docs/docs/theming-variables.html#makegutter).


