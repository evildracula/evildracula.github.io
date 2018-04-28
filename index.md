---
layout: page
title: Buchers'
tagline: 不吃屎 23333
---
{% include JB/setup %}

Recent
===
<ul class="posts">
  {% for post in site.posts limit:20 %}
    <li><span>{{ post.date | date_to_string }}</span> &raquo; <a href="{{ BASE_PATH }}{{ post.url }}">{{ post.title }}</a></li>
  {% endfor %}
</ul>


Todo
===
**2018 Planning**
- Enrich THIS
- Training

