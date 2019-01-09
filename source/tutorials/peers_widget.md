title: Peers Widget
layout: tutorial

---
![Badges](badges/bpanel-widget.svg)
![Badges](badges/chain-bitcoin.svg) ![Badges](badges/chain-bitcoincash.svg) ![Badges](badges/chain-handshake.svg)
# Description
This is a simple widget for the bPanel Dashboard plugin that displays peer information in two widget areas.

In the bottom widgets an expandable list of peers are displayed. In the customChildrenAfter area, a map is displayed.

You will need API keys for two different services for the map to work. The map uses an external API to get approximate geolocations of nodes based on IP Address. To get your free API Key, head to [ipstack](https://ipstack.com/) and add your key to your secrets.json located in your bpanel config directory (defaults to `~/.bpanel`). Must be running bPanel version 0.3.1 or above for secrets support. You can also get a premium account to support SSL for your map ($10/month). The second key is a Google Maps API key which you can get
[here.](https://developers.google.com/maps/documentation/javascript/get-api-key)

Your secrets.json should look something like this:
```
{
  "ipstack": "my-secret-key",
  "googleMaps": "my-google-key"
}
```
# Install
<pre>
<button class="btn" data-clipboard-target="#code-1"><img class="clippy" width="13" src="/docs/img/clippy.svg" alt="Copy to clipboard"></button>
<code class="shell">$ <mark id="code-1">npm i @bpanel/peers-widget</mark></code></pre>

# Images
![Screenshot](img/peers-widget1.png)
![Screenshot](img/peers-widget2.png)