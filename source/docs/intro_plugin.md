---
title: Intro to Plugin Development
---
Before getting started, you may want to install the [Redux DevTools extension](https://github.com/zalmoxisus/redux-devtools-extension)
(Chrome and Firefox extensions are available). The developer build of bPanel will expose these tools in the browser which will give you a lot of information about what data is available in the store, what actions are fired, etc.

You'll also want to make sure your server is configured properly to connect to compatible nodes. Head on over to [Configuration](/docs/configuration.html) if you're having any trouble. You can also read more about how bPanel makes it easy to [interact with the blockchain](/docs/blockchain_api.html).
## bPanel CLI
We've built a CLI tool to help spec out the initial skeleton of your plugin and let you hit the ground running in your development. This will setup a project directory for you that is ready to be published onto NPM. It will also install the project directly to your local bpanel config directory by default, which means all you have to do is install it to bPanel with `bpanel-cli install --local [YOUR_PLUGIN_NAME]` and it will automatically be built into your local bPanel.

### Install bpanel-cli
The CLI tool is available via npm: [bpanel-cli](https://www.npmjs.com/package/@bpanel/bpanel-cli).
```shell
npm install -g @bpanel/bpanel-cli
```

Once installed, run the command below to create your plugin boilerplate. This will walk you through thesteps necessary to setup your development environment. If you've ever run `npm init`,many of the initial steps will feel familiar to you (and in fact, this will fill out a lotof the same information in your plugin's package.json). The later steps however are more advanced,specific to your plugin and the bPanel API, so feel free to skip these if you're not exactly sure whatyou want to build or how to built it.

```shell
bpanel-cli create
```

Once the script is complete you should have a plugin project directory ready to work on (and even `npm publish` if you wanted to).

## Developing your Plugin
If you're using the default plugin structure, index.js in the `dist` directory of your plugin directory is the entry point to your plugin. Your plugin extensions should be exposed in this file (see the API docs for more on the available extensions).

If you're using `bpanel-cli create` though, you can/should build in the `lib` directory, exposing an `index.js` file there, and the build commands (`make watch`, `make build`, or `npm publish` described below) will build your files into the `dist` directory (the build really just converts any modern ES6+ into more widely supported JavaScript).

To build your plugin anytime you make changes, simply `cd` to your plugin's directory in your terminal and run the watch command (you can also manually run `make babel` after each change).

``` bash
cd /path/to/your-plugin
make watch
```

## A Note about Dependencies
Since you will only be using your plugin in bPanel, you can assume a number of tools and packages will be available by default. This means there is no need to include them in your plugin's dependencies. The best thing to do (especially to make the linter happy) is to add them to your `peerDependencies` in `package.json`.`bpanel-cli create` will take care of the most important ones for you automatically, but if there are others you depend on, and/or you want to ensure a minimum version, make sure to update those yourself.

Important packages your plugin can expect to have access to include:

- "bcoin"
- "hsd"
- "bcash"
- "@bpanel/bpanel-ui"
- "@bpanel/bpanel-utils"
- "react"
- "react-dom"
- "react-redux"
- "react-router-dom"
- "redux"
- "redux-thunk"

## Publishing your Plugin
If you're using `bpanel-cli` to spec your plugin files, then this is as easy as `npm publish`. Just make sure you've got your npm registry credentials setup on your local machine (more [at npm](https://docs.npmjs.com/cli/publish)). Once published, other bPanel developers can install and import your plugin into their own app!

`bpanel-cli create` will automatically add `bpanel` and `bcoin` keywords to your package.json. This makes it easy for other users to find your plugin with a simple `bpanel-cli search`.

## The Plugin API
You will need to hook into the extension API in order to make sure your functionality is added to bPanel. Read about the API to learn more about the available extensions and how to use them. All you have to do is make sure that at least one of these are exported from the entry point of your module (e.g. index.js when using `bpanel-cli`).

The API can roughly be broken down as follows (click the links to learn more about implementation):
- [Metadata](/docs/api_metadata.html)
- [Decorate](/docs/api_decorate.html)
- [Get Props](/docs/api_get_props.html)
- [Reducers](/docs/api_reducers.html)
- [Middleware](/docs/api_middleware.html)
- [Constants](/docs/api_constants.html)
- [Sockets](/docs/api_sockets.html)
  - Connect
  - Listen and Emit
  - Broadcast
  - Dispatch
  - Subscribe
- [Decorate Plugins](/docs/api_decorate_plugins.html)
- [Bundling Plugins](/docs/api_bundling_plugins.html)
- [bPanel Utils](/docs/api_bpanel_utils.html)
  - clients
  - Chain
  - Helpers
    - now()
- [decorateTheme](/docs/theming_started.html)