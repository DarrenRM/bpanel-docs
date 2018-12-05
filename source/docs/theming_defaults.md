---
title: Theming Defaults
---
Sometimes when creating a theme, we'd like to have access to the default theme we're extending off of, for example getting the default theme colors or default font sizes to use in our new theme. We can do this by declaring our `themeVariables` or `themeConfig` as a function. The default `themeVariables` and `themeConfig` would be passed down as argument to that function. For example,

## Theme Variables
```javascript
/// themeVariables.js
/// ******
/// THEME VARIABLES
/// ******
const themeVariables = defaultThemeVariables => {
  const fontSizeBase = defaultThemeVariables.fontSizeBase * 1.5;
  return { fontSizeBase };
};

export default themeVariables;

```

This example takes the default `fontSizeBase` and increases it by 1.5x.

We can also do this in the `themeConfig`,

## Theme Config
```javascript
/// themeConfig.js
import { utils } from 'bpanel-ui';

const { makeRem, makeGutter } = utils;

/// ******
/// THEME CONFIG
/// ******
const themeCreator = defaultThemeVariables => {
  const logoSize = makeRem(2.25);
  // MAIN APP COMPONENTS
  const sidebar = {
    logoContainer: {
      background: defaultThemeVariables.themeColors.light2Bg,
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
  return { sidebar };
};

export default themeCreator;

```

Using the logoContainer example, we access the default theme's `themeColors`, and pull the color value that we want to use in our modified style sheet.

### Default Theme Config
There is also a 2nd argument that you can add to the function in **`themeConfig` only**, that gives you access to the default `themeConfig` as well.

```javascript
/// themeConfig.js
/// ******
/// THEME CONFIG
/// ******
const themeCreator = (defaultThemeVariables, defaultThemeConfig) => {
  ...
};

```
