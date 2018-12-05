---
title: About Plugins
---
bPanel is built entirely around plugins. All visual elements can be extended or overridden via
the plugin system including the header, footer, sidebar, and main panel/view element. This is
done by leveraging the composable nature of [React](https://reactjs.org) as well as the
[3 principles of redux](https://redux.js.org/introduction/three-principles) (single source of
truth, read only state, and functional reducers (read more about how [below](#design-philosophy))).
Even if you're unfamiliar with either React or Redux, bPanel makes it easy to hook into the underlying
architecture and interact with the blockchain API layer on the backend.

![plugins everywhere](/img/plugin-preview-light.png "plugins everywhere")*Nearly everything you see
here is a plugin*

This plugin system was heavily influenced by the amazing work done on the [Hyper.is](https://hyper.is)
JS terminal emulator by the team at [Zeit.co](https://zeit.co). If you're familiar with their plugin
system then you should be able to pick up the bPanel API pretty easily!


## Design Philosophy
We wanted to make bPanel as extensible as possible. Rather than try and solve all problems with a
single tool, our goal was to enable developers to create many tools to solve problems for any use case.
Whether you wanted to have a footer widget that shows the progress of your node sync or the most recently
generated address for a wallet, you can build that plugin for your specific instance of bPanel.

The bPanel plugin system also allows you to [bundle a group of plugins together](/docs/api-bundling-plugins.html),
creating a theme. By building out themes in this way, a user of bPanel can put together a
bespoke version of bPanel, utilizing a range of plugins from other developers, that
suites their specific needs- from wallet interfaces to transaction management to
block explorers or even advanced scripting.

In order to hook into bPanel, plugins should expose at least one of the
[API extensions](/docs/plugin-started.html#the-plugin-api). These extensions tell bPanel how
you would like your plugin to decorate or extend the app. This works either by [decorating React Components](/docs/api-decorate.html)
(using the power of [Higher Order Components](https://medium.com/@franleplant/react-higher-order-components-in-depth-cf9032ee6c3e)),
extending the [reducer](/docs/api-reducers.html), or [adding middleware](/docs/api-middleware.html)
to respond to actions. You can even interact with the web sockets API of your bcoin backend
via redux, using bsock-middleware (read more [here](/docs/api-sockets.html)).

### A Plugin Ecosystem
The last important part of the design philosophy behind the plugin architecture is the ability to
easily enable an open ecosystem of plugins. Based on the system built into [Hyper.is](https://hyper.is),
bPanel allows you to simply `npm install --save` a plugin into your local bPanel's `node_modules` and
then add it to your app's config file. You can also use `localPlugins` to develop or install plugins
locally. The idea is that with just a few `npm install`s, it will be that easy to compose your
perfect blockchain interface (and eventually we hope to have a GUI to even simplify that).