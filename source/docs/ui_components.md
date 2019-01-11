---
title: UI Components
---

The easiest way to learn about and experiment with bPanel UI components is through the demo plugin `BUI` bPanel. This plugin adds a view to your bPanel install that demonstrates the use of all available components in the bPanel UI library.

## Consistent Styling
The best part about using bPanel UI components in your plugin views is that they will automatically reflect updates to your active theme. Since all components are connected to the themeVariables and themeConfig via the [`connectTheme` HOC](/docs/ui_utilities.html#connectTheme), if you change your app's theme, the changes will be reflected in the component. These can even be extended via theme prop if you want.

## Get Started with BUI
Try it out for yourself!

```bash
npm install --save @bpanel/bui
```

Add `BUI` to your bPanel install to see what's available.
```javascript
// ~/.bpanel/config.js
export const localPlugins = [];
export const plugins = ['@bpanel/bui'];
export default { localPlugins, plugins };
```

Using components is as easy as:
```bash
npm install @bpanel/bpanel-ui
```

``` javascript
import { Text, Header } from '@bpanel/bpanel-ui';

export default () => (
  <div>
    <Header type="h2">Hello World</Header>
  </div>
);
```