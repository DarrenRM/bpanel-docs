<li class="plugin on" id="resources">
  <div align="left"><img id="resources" src="/templates/thumbnails/{{ template.thumbnail }}" style="display: block" /></div>
  <a href="{{ template.link }}" class="plugin-name" id="resources" target="_blank">{{ template.name }}</a>
  <p class="plugin-desc">{{ template.description }}</p>
  <!--<p class="plugin-install">Install: <div class="plugin-install-cmd">{{ template.install }}</div></p>-->
  <div class="plugin-tag-list">
    {% for tag in template.tags %}
      <a href="#{{ tag }}" class="plugin-tag">{{ tag }}</a>
    {% endfor %}
  </div>
</li>
