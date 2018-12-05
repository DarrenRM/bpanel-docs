---
title: Theming Variables
---

Welcome to the theme variables section. This section will lay out the variables you can modify and export from you `themeVariables.js` file to change the look and feel of your theme.

- [Theme Variables](#theme-variables)
  - [Basic themeVariables](#basic-themevariables)
  - [Themed themeVariables](#themed-themevariables)
  - [Theme Variable Layout](#theme-variable-layout)
  - [Fonts](#fonts)
    - [fontFamily](#fontfamily)
    - [fontSizeBase](#fontsizebase)
    - [fontSizeSmall](#fontsizesmall)
    - [fontSizeNormal](#fontsizenormal)
    - [fontSizeLarge](#fontsizelarge)
    - [fontSizeH1](#fontsizeh1)
    - [fontSizeH2](#fontsizeh2)
    - [fontSizeH3](#fontsizeh3)
    - [fontSizeH4](#fontsizeh4)
    - [fontSizeH5](#fontsizeh5)
    - [fontSizeH6](#fontsizeh6)
    - [fontOpacity](#fontopacity)
    - [fontWeights](#fontweights)
  - [Backgrounds](#backgrounds)
    - [appBg](#appbg)
    - [appBgSize](#appbgsize)
  - [Colors](#colors)
    - [themeColors](#themecolors)
  - [Borders](#borders)
    - [borderWidth](#borderwidth)
    - [borderStyle](#borderstyle)
    - [borderTransparent](#bordertransparent)
    - [border1](#border1)
    - [border2](#border2)
    - [borderRadius](#borderradius)
  - [Container](#container-gift)
    - [rowContainer](#rowcontainer)
  - [Transitions](#transitions)
    - [smoothTransition](#smoothtransition)
  - [Component: Header](#component-header)
    - [headerHeight](#headerheight)
  - [Component: Footer](#component-footer)
    - [footerHeight](#footerheight)
  - [Component: Logo](#component-logo)
    - [logoUrl](#logourl)
- [Utils](#utils)
  - [makeRem](#makerem)
  - [makeGutter](#makegutter)
- [License](#license)

### Theme Variable Layout
`appBg` and `themeColors` are only two `themeVariables` out of many that we can modify. The complete list of `themeVariables` we can edit can be found here:

```javascript
const themeVariables = {
  // rawRem holds all the values that will be converted
  // to a stringified rem value based off the fontSizeBase
  rawRem: {
    /// *****
    /// FONTS
    /// *****
    // Font Size
    fontSizeSmall,
    fontSizeNormal,
    fontSizeLarge,
    fontSizeH1,
    fontSizeH2,
    fontSizeH3,
    fontSizeH4,
    fontSizeH5,
    fontSizeH6,
    // Header
    headerHeight,
    // Footer
    footerHeight
  },
  /// *****
  /// FONTS
  /// *****
  // Font Size
  fontSizeBase,
  // Font Family
  fontFamily,
  // Font Opacity
  fontOpacity,
  // Font Weights
  fontWeights,
  /// ***********
  /// BACKGROUNDS
  /// ***********
  appBg,
  appBgSize,
  /// ******
  /// COLORS
  /// ******
  themeColors,
  /// *******
  /// BORDERS
  /// *******
  borderWidth,
  borderStyle,
  border1,
  border2,
  borderTransparent,
  borderRadius,
  /// ***********
  /// TRANSITIONS
  /// ***********
  smoothTransition,
  /// *******************
  /// COMPONENT VARIABLES
  /// *******************
  // Logo
  logoUrl
};

```

### Fonts

#### fontFamily
The fontFamily property describes the font used across bPanel.

Examples:
```javascript
// type: string
const fontFamily = 'Open Sans, sans-serif'; // default

// other examples
const fontFamily = 'Georgia, serif';
const fontFamily = 'serif';
const fontFamily = 'Open Sans';

```

#### fontSizeBase
The fontSizeBase property describes the base font size that all other font sizes are based off of. Increasing or decreasing this value will increase or decrease the font size of all fonts.

Examples:
```javascript
// type: number
const fontSizeBase = 1; // default

// other examples
const fontSizeBase = 2; // 2x the original font size
const fontSizeBase = 0.5; // half the original font size

```

#### fontSizeSmall
The small font size.

Examples:
```javascript
// type: number
const fontSizeSmall = 0.8; // default

// other examples
const fontSizeSmall = 0.2 // very small font size using makeRem
const fontSizeSmall = 0.5 // half the original font size

```

#### fontSizeNormal
The normal font size.

Examples:
```javascript
// type: number
const fontSizeNormal = 1; // default

// other examples
const fontSizeNormal = 1.2; // 1.2x larger than base font size
const fontSizeNormal = 1.5 // 1.5x the base font size

```

#### fontSizeLarge
The large font size.

Examples:
```javascript
// type: number
const fontSizeLarge = 1.2; // default

// other examples
const fontSizeNormal = 1.5; // 1.5 the base font size
const fontSizeNormal = 2; // 2x the base font size;

```

#### fontSizeH1
The font size for h1 tags.

Examples:
```javascript
// type: number
const fontSizeH1 = 3.2; // default

```

#### fontSizeH2
The font size for h2 tags.

Examples:
```javascript
// type: number
const fontSizeH2 = 2.6; // default

```

#### fontSizeH3
The font size for h3 tags.

Examples:
```javascript
// type: number
const fontSizeH3 = 2.1; // default

```

#### fontSizeH4
The font size for h4 tags.

Examples:
```javascript
// type: number
const fontSizeH4 = 1.7; // default

```

#### fontSizeH5
The font size for h5 tags.

Examples:
```javascript
// type: number
const fontSizeH5 = 1.3; // default

```

#### fontSizeH6
The font size for h6 tags.

Examples:
```javascript
// type: number
const fontSizeH6 = 1.1; // default

```

#### fontOpacity
Opacity for decorating text. This is applied to fonts that want a lighter opacity.

Examples:
```javascript
// type: number
const fontOpacity = 0.75; // default

```

#### fontWeights
An object holding font weights.

Examples:
```javascript
// type: object {
//   light: number,
//   regular: number,
//   semiBold: number,
//   bold: number
// }
const fontWeights = {
  light: 300,
  regular: 400,
  semiBold: 600,
  bold: 700
}; // default

```

### Backgrounds

#### appBg
Background used across bpanel. This can be a color, gradient, or image. Anything that the background property allows, this property allows:
https://developer.mozilla.org/en-US/docs/Web/CSS/background

Examples:
```javascript
// type: string
const appBg = 'linear-gradient(-35deg, #835fac, #00558a, #009db6)'; // default

// other examples
const appBg = 'white'; // color
const appBg =
  'linear-gradient( rgba(0, 0, 0, 0.5), rgba(0, 0, 0, 0.5) ), url(htt' +
  'ps://i2.wp.com/trendintech.com/wp-content/uploads/2017/05/477614_1' +
  '280x720.jpg?fit=1280%2C720) no-repeat center center fixed'; // url

```

#### appBgSize
Background size property. If using a background image, this property can be modified to fit your needs.
https://developer.mozilla.org/en-US/docs/Web/CSS/background-size

Examples:
```javascript
// type: string
const appBgSize = 'auto'; // default

// other examples
const appBgSize = 'cover'; // for full sized background images

```

### Colors

#### themeColors
Colors used by bpanel.

Examples:
```javascript
// type: object {
  primary: string,
  highlight1: string,
  highlight2: string,
  lowlight1: string,
  lowlight2: string,
  lightBg: string,
  light2Bg: string,
  mediumBg: string,
  darkBg: string,
  // Constants
  white: string,
  black: string,
  transparent: string
}

const themeColors = {
  // Themeable colors
  primary: '#fff', // white
  highlight1: '#00ffe0', // teal
  highlight2: '#83d9ff', // light blue
  lowlight1: '#1b1464', // dark purple
  lowlight2: '#9e005d', // medium purple
  lightBg: 'rgba(255, 255, 255, 0.1)', // transparent white 1
  light2Bg: 'rgba(255, 255, 255, 0.2)', // transparent white 2
  mediumBg: 'rgba(0, 255, 224, .2)', // transparent teal
  darkBg: 'rgba(0, 0, 0, .4)', // transparent black
  // Constants
  white: '#fff',
  black: '#000',
  transparent: 'transparent'
}; // default

```

### Borders

#### borderWidth
Width of borders used in bPanel
```javascript
// type: string
const borderWidth = '1px'; // default

```

#### borderStyle
Examples:
```javascript
// type: string
const borderStyle = 'solid'; // default

// other examples
const borderStyle = 'dotted';

```

#### borderTransparent
Transparent border. Used for state transitions for :before and :after states that show and hide borders.
```javascript
// type: string
const borderWidth = '1px';
const borderStyle = 'solid';
const borderTransparentColor = `${borderWidth} ${borderStyle} ${themeColors.transparent}`; // default

```

#### border1
```javascript
// type: string
const border1Color = `${borderWidth} ${borderStyle} ${themeColors.white}`; // default

```

#### border2
```javascript
// type: string
const border2 = `${borderWidth} ${borderStyle} ${themeColors.light2Bg}`; // default

```

#### borderRadius
Border radius mainly used for buttons. Can be applied to other styles in the `themeConfig.js`.
```javascript
// type: string
const borderRadius = '5px'; // default

```

### Transitions

#### smoothTransition
```javascript
// type: string
const smoothTransition = '0.3s ease'; // default

```

### Component: Header

#### headerHeight
```javascript
// type: string
const headerHeight = makeRem(7, fontSizeBase); // default

```

### Component: Footer

#### footerHeight
```javascript
// type: string
const footerHeight = makeRem(2, fontSizeBase); // default

```
### Component: Logo

#### logoUrl
```javascript
// type: string
import logo from '../../assets/logo.png';
const logoUrl = logo; // default

```

## Utils

### makeRem
`makeRem` takes a `size`, multiplies it by the `fontSizeBase`, then returns a size string with `'rem'` added to the end.
```javascript
// type: function
// params: {
//   size: number,
//   fontSizeBase: number
// }
// return: string
export default (size, fontSizeBase = 1) =>
  (size * fontSizeBase).toString().concat('rem');

```

**Example**
```javascript
makeRem(5); // '5rem';
makeRem(10); // '10rem';
makeRem(0.5, 10); // '5rem';

```

### makeGutter
```javascript
// type: function
// params: {
//   type: string,
//   options: object: {
//     top: number,
//     bottom: number,
//     left: number,
//     right: number,
//     horizontal: number,
//     vertical: number,
//     all: number
//   }
// }
// return: object
import makeRem from './makeRem';

export default (
  type = 'padding',
  { top, bottom, left, right, horizontal, vertical, all }
) => {
  let gutterTop, gutterRight, gutterBottom, gutterLeft;

  // All gutter calculations
  if (all) gutterRight = gutterLeft = gutterTop = gutterBottom = makeRem(all);

  // Horizontal gutter calculation
  if (horizontal || horizontal === 0) {
    gutterRight = gutterLeft = makeRem(horizontal);
  } else {
    gutterRight = gutterRight || ((right || right === 0) && makeRem(right));
    gutterLeft = gutterLeft || ((left || left === 0) && makeRem(left));
  }

  // Vertical gutter calculation
  if (vertical || vertical === 0) {
    gutterTop = gutterBottom = makeRem(vertical);
  } else {
    gutterTop = gutterTop || ((top || top === 0) && makeRem(top));
    gutterBottom =
      gutterBottom || ((bottom || bottom === 0) && makeRem(bottom));
  }

  return {
    [`${type}Top`]: gutterTop,
    [`${type}Right`]: gutterRight,
    [`${type}Bottom`]: gutterBottom,
    [`${type}Left`]: gutterLeft
  };
};

```

**Example**
```javascript
// Example
makeGutter('padding', { left: 5, right: 5 }); // { paddingLeft: '5rem', paddingRight: '5rem' };
makeGutter('padding', { horizontal: 15, vertical: 10 }); // { paddingLeft: '15rem', paddingRight: '15rem', paddingTop: '10rem', paddingBottom: '10rem' };
makeGutter('margin', { all: 8 }); // { marginLeft: '8rem', marginRight: '8rem', marginTop: '8rem', marginBottom: '8rem' };

```
## License

- Copyright (c) 2017, The Bcoin Devs (MIT License).