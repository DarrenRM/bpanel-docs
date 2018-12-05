---
title: Getting Started
---
Welcome to theming! This guide is meant to ease you into the bPanel theming process. By the end of this guide, you'll have a theme that you can customize to your personal preference. Note that only changing a few theme variables can have a big overall visual change to your bPanel, meaning that compelling themes can come from just a few lines of code. Let's get started.

- [Set up your theme](#set-up-your-theme)
  - [index.js](#bpanel-webapp-plugins-mytheme-themevariablesjs)
  - [themeVariables.js](#bpanel-webapp-plugins-mytheme-themevariablesjs)
  - [appConfig.js](#bpanel-webapp-config-appconfigjs)
- [Customize your theme](#customize-your-theme)
  - [Basic themeVariables.js](#basic-themevariablesjs)
  - [Full themeVariables.js](#full-themevariablesjs)
  - [Theme Config](#theme-config)

## Set up your theme
Themes at their core are just plugins that expose the `decorateTheme` extension. This means that setting up your theme works just like any other plugin. [`bpanel-cli create`](/docs/plugin-started.html#bpanel-cli) even has an option to create a theme. Read [Getting Started](/docs/plugin-started.html) with Plugin Development for more.

To start developing a theme as a local plugin without `bpanel-cli`, create a new folder in your `plugins/local` directory, and name it with the name of your theme. Inside, you'll create the files `index.js` and `themeVariables.js`. There is also an optional file you can create called `themeConfig.js` which allows you to extend the key/value pairs of the existing default theme. For initializing our theme, we'll start out with just the `index.js` and `themeVariables.js` files.

Every theme will have a few lines of code to initialize it. Assuming we create a theme folder named `myTheme`, that code will look like this:

### bpanel/webapp/plugins/local/myTheme/index.js
```javascript
import themeVariables from './themeVariables';

export const metadata = {
  name: 'myTheme', // Input the name of your theme here
  author: 'bpanel-org', // Input your name, alias, or org name here
  theme: true
};

export const decorateTheme = themeCreator => () =>
  themeCreator(themeVariables);

```

### bpanel/webapp/plugins/local/myTheme/themeVariables.js
```javascript
const themeVariables = {};

export default themeVariables;

```

### `~/.bpanel/config.js`
Add your theme to the `~/.bpanel/config.js`.
```javascript
export const localPlugins = [
  'chainSockets',
  'dashboard',
  'mempool',
  'bui',
  'myTheme'
];

export const plugins = [];

export default { localPlugins, plugins };

```

By this point, we will have the scaffolding ready to start theming, and our bPanel should not look any different. After creating these files you can begin to add your custom variables to the `themeVariables.js` file to create your own theme.

## Customize your theme

Now that we have the initial scaffolding set up, we can start to edit the values of our `themeVariables`. You can think of `themeVariables` like the pieces of DNA that determine the visual language of your theme.

**Getting started**
Let's export a `themeVariables` object containing the properties you want to change.

The easiest way to get started is to modify your theme colors and background first. These variables give the best overall change to your theme to create the initial look and feel you're going for.

The base structure of the `themeVariables` can be found here: https://github.com/bpanel-org/bpanel/blob/master/webapp/config/themeConfig/themeVariables.js. Any of these exported values can also be exported out of your custom `themeVariables.js` file to modify their original values. To get started, let's start with this in the `themeVariables.js` file:

### Basic themeVariable.js
```javascript
// Background
const appBg = '#292C44'; // This can be a color, linear-gradient, image url

const themeVariables = {
  appBg
};

export default themeVariables;

```
If you refresh you bPanel app, you'll notice the background has changed.

Here is a more robust example. This is a dark theme which uses the `appBg`, `fontFamily`, and `themeColors` variables:
### Full themeVariables.js
```javascript
// Background
const appBg = 'black';

// Fonts
const fontFamily = 'Andale Mono';

// Colors
const black = 'white';
const blue = '#4F80E1';
const teal = '#18CDCA';
const darkBlue = '#215970';
const darkerBlue = '#122438';
const lightGray = '#F1F1F2';
const mediumGray = '#BEBEBF';
const darkGray = '#383838';

const themeColors = {
  primary: black,
  highlight1: blue,
  highlight2: teal,
  lowlight1: darkBlue,
  lowlight2: darkerBlue,
  lightBg: lightGray,
  mediumBg: mediumGray,
  darkBg: darkGray
};

const themeVariables = {
  appBg,
  fontFamily,
  themeColors,
};

export default themeVariables;

```

Note that only the exported `themeVariables` are what's important. You can declare as many color variables or any other variables that you'd like, but only the exported variables that match the names of the imported variables in the `themeConfig` matter.

### Theme config
If the `themeVariables` are the DNA pieces, then the `themeConfig` is our DNA structure. If we want to extend or change the structure of our style sheets, we can do that by creating a `themeConfig.js` file and exporting our styles from the file.

We'll be introducing the `bpanel-ui` `utils` in this example. If you'd like to see what each of these functions do, you can see it here,
http://bpanel.org/docs/theming-variables.html#utils

```javascript
import { utils } from 'bpanel-ui';
import themeVariables from './themeVariables';

const { makeRem, makeGutter } = utils;

/// ******
/// THEME CONFIG
/// ******
const logoSize = '2.25rem';
// MAIN APP COMPONENTS
const sidebar = {
  logoContainer: {
    border: `1px solid ${themeVariables.themeColors.darkBg}`,
    borderRadius: '50%',
    opacity: 1,
    ...makeGutter('padding', { all: 1.25 }), // Creates the padding
    ...makeGutter('margin', { vertical: 1.875 }) // Creates the vertical margin
  },
  logoImg: {
    height: logoSize,
    width: logoSize
  }
};
const themeConfig = { sidebar };

export default themeConfig;

```

We will also need to add our `themeConfig` to our `index.js`.

```javascript
import themeVariables from './themeVariables';
import themeConfig from './themeConfig';

export const metadata = {
  name: 'myTheme', // Input the name of your theme here
  author: 'bpanel-org', // Input your name, alias, or org name here
  theme: true
};

export const decorateTheme = themeCreator => () =>
  themeCreator(themeVariables, themeConfig); // Add the themeConfig here as the 2nd argument

```

This example extends the original `sidebar.logoContainer` styling to include a `border`, `borderRadius`, `margin`, while also changing the default values of the `opacity`, `padding`, and logoImg's `height` & `width`. To see how this all works, take a look at,
https://github.com/bpanel-org/bpanel/blob/master/webapp/config/themeConfig/themeCreator.js

In short, the `themeCreator` merges the default `themeVariables` and `themeConfigs` with the new plugin theme.

Now that you have a good starting point on theming, you can begin to modify the `themeVariables` and `themeConfig` as you want to create your own unique theme!
