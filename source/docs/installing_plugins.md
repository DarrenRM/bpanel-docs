---
title: Installing Plugins
---
The plugin system built into bPanel is the best and most flexible way to customize your bPanel install while also ensuring compatibility with the platform. Use a custom skin, add functionality, or extend existing views. All with a couple simple steps!

## bpanel-cli
The command line utility `bpanel-cli` makes it easy to interact with your local version of bPanel. Use it to [bootstrap a new plugin project](/docs/plugin_started.html), search for existing plugins, install and uninstall plugins from npm, or interact with plugins you are developing locally.

Available commands include:

- `bpanel-cli install [--local|-l ] [...list of plugins]` to install plugins, `-l` will install local plugins
- `bpanel-cli uninstall [--local|-l ] [plugin name]` to uninstall plugins, `-l` will uninstall local plugins
- `bpanel-cli list` to list out all currently installed plugins
- `bpanel-cli search [...search terms]` By default searches for all packages on npm with the keyword `bpanel`
- `bpanel-cli create` Walks through process of creating a boilerplate plugin project

### Note about remote plugins
bpanel-cli will check that a remote plugin exists on the public npm registry before adding it to your config. It does not check that the plugin itself is fully compatible however. If the build encounters any errors after installation, try removing the plugin and checking with the plugin developer to confirm compatibility.
Try to only install packages that at least have the keyword `bpanel`.

Also note that bpanel-cli will only check existence on npm and add the plugin to your `config.js`. You will still have to wait for it to be downloaded and built into your app's JS bundle before it is activated.

### Note about local plugins
bpanel-cli will look for local plugin in a `local_plugins` in your bpanel configs directory (`~/.bpanel` by default) before installing but this can be overriden with the `--prefix` option.


## How it works
This section is targeted for developers curious about how the plugin installation system works.

Plugins that should be built into bPanel are tracked by a `config.js` file stored in your local project's main directory. By default this is in your system's home directory at `~/.bpanel`, which is created, along with other boilerplates necessary to run bPanel, by an npm pre-install script. (This is customizable but beyond the scope of this tutorial. Wherever your project's config directory is though, it _must_ include a `config.js` file).

Remote plugins to be installed from npm are listed in a `plugins` array and local plugins are in a `localPlugins` array both of which are exported from `config.js`. The bPanel server will watch for changes in this file, and if it notices anything, a script `build-plugins.js` is run (this is actually triggered by Webpack which is restarted by the server when `config.js` is changed, this could be changed in the future with [HMR support](https://webpack.js.org/guides/hot-module-replacement/)) which handles installing new plugins, creating entry points for the new plugins into the app, and updating the JS bundle.

All bpanel-cli does, aside from certain sanity checks, is add or remove plugin names from the appropriate arrays. `build-plugins` takes care of the rest. So if you don't want to use bpanel-cli, or run into any problems with it, you can accomplish the same thing by editing `config.js`.

## Developing your own plugins
If you want to learn how to develop and publish your own plugins, head on over to our [Developers section](/docs/intro_plugin.html).