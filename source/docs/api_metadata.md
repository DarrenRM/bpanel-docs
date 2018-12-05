---
title: metadata
---
Metadata is where you tell the app and other users about your plugin.
This includes information like the name of your plugin, a description,
author information, also a display name where relevant.

**Note that the metadata export is required for all plugins.**

If you are using `bpanel-cli` to create your plugin then this will be
taken care of for you. Plugin metadata is also saved in the redux store,
so you can use the redux devtools to see more about plugins that are installed.
In the future, this will help support plugin management through the UI.

Metadata might be expanded in the future to support more flexible
plugin functionality. For now, the following properties can be used:

```javascript
export const metadata = {
  name: 'dashboard',
  displayName: 'My Dashboard',
  pathName: 'home',
  version: require('../package.json').version,
  author: 'bpanel-org',
  order: 0,
  icon: 'home',
  sidebar: true,
  parent: ''
};
```

### Details
| Property       | Required?     | Type        | Details     |
| -------------  | ------------- | --------    | -------     |
| `name`         | yes           | `string`    | Used to identify your plugin. Must follow npm naming rules  |
| `displayName`  | no            | `string`    | Will default to `name` if none is provided |
| `pathName`     | no            | `string`    | If building a view/panel, will be passed to react-router to use as URL of your view|
| `author`       | no            | `string`    | Who you are |
| `order`        | no            | `int`       | If including in sidebar, useful for ordering nav.<br>If order conflicts between plugins, will sort alphabetically |
| `icon`         | no            | `string`    | Also for sidebar navigation.<br>The name of the font awesome icon to use for your view nav  |
| `sidebar` or nav | no            | `bool`      | Default: `false`<br>If true, bPanel will automatically add sidebar navigation for your plugin view  |
| `parent`       | no            | `string`    | Currently no support, but will be used for<br>adding a plugin as child (both in path and in navigation) |