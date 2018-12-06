<div id="content-wrap">
  <div class="wrapper">
    <div class="inner">
      <header id="plugin-list-header" style="margin-bottom: 15px;">
        <h1 id="plugin-list-title"><!--{{ page.title }}-->bPanel Plugins</h1>
      </header>
          <h4>Sort by:</h4>
          <nav class="filter">
            <button type=button class="btn-sort" data-filter="all">All</button>
            <button type="button" class="btn-sort" data-filter=".sortby-plugin">Plugin</button>
            <button type="button" class="btn-sort" data-filter=".sortby-widget">Widget</button>
            <button type="button" class="btn-sort" data-filter=".sortby-skin">Skin</button>
            <button type="button" class="btn-sort" data-filter=".sortby-theme">Theme</button>
          </nav>
      <ul id="plugin-list" class="results">
        {% for tutorial in _.sortBy(site.data[page.data], 'name') %}
          {{ partial('partial/' + page.partial, {tutorial: tutorial}) }}
        {% endfor %}
      </ul>
    </div>
  </div>
</div>

