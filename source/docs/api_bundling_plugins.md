---
title: Bundling Plugins
---
The idea with bundling plugins is to allow for the ability to create whole themes that are made up of plugins to serve specific use cases. Imagine a published theme "exchange-admin" that has node management and advanced block explorer visualization tools. Or an "advanced-wallet" theme that has HD wallet management and hardware signing capabilities. You can even bundle a [theming plugin](/docs/theming_started.html) together with the other plugins to create a totally unique application (even allowing for white labeling your own distributions).

Plugin bundling also allows you to account for plugin dependencies. When the app is built and it goes through all the plugins to include in the final script, it will check if a bundled plugin already exists in the build, and only use the one with the latest semver version. So if you have a plugin that will [decorate another plugin](/docs/api_decorate_plugins.html) or a dependency on [a plugin that handles some socket management](/docs/node_info.html#6-Connect-to-sockets), you can bundle that plugin in your final published plugin.

## How It Works
All you have to do for this to work, is install the plugin as a local dependency, import the module into your plugin's entry point, and export a `pluginConfig` module that has a `plugin` property pointing to an array of the plugin dependencies.

First:
```bash
npm install --save @bpanel/bmoon-theme @bpanel/chain-sockets
```

Then in your index.js
```javascript
// index.js
import * as bMoon from '@bpanel/bmoon-theme';
import * as sockets from '@bpanel/chain-sockets';
...
export const pluginConfig = {
  plugins: [bMoon, sockets]
};
...
```

You can bundle any number of plugins in this way, same as with the normal appConfig.js. Add plugins to decorate the header and footer, add new views, decorate other plugins, whatever you want!

## With bPanel CLI
If you're using [bPanel CLI](/docs/intro_plugin.html#bPanel-CLI) to create your plugin, there is a step that asks you if your plugin will depend on any other plugins. If you know ahead of time that it will, then you can enter the names of these plugins as they can be found in the npm registry and the creation script will automatically install them, import them to your plugin entry point, and setup the `pluginConfig` extension.