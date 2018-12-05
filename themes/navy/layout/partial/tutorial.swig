{% for tag in tutorial.tags %}
<li class="plugin on mix sortby-{{ tag }}">
{% endfor %}
  <div align="left"><img src="/tutorials/thumbnails/{{ tutorial.thumbnail }}" style="display: block" /></div>
  <a href="{{ tutorial.link }}" class="plugin-name">{{ tutorial.name }}</a>
  <p class="plugin-desc">{{ tutorial.description }}</p>
  <div class="plugin-tag-list">
    {% for tag in tutorial.tags %}
      <a href="#{{ tag }}" class="plugin-tag">{{ tag }}</a>
    {% endfor %}
  </div>
</li>