---
layout: page
title: Buchers'
tagline: 不吃屎 23333
---
{% include JB/setup %}

Recent 10
===
<ul class="posts">
  {% for post in site.posts limit:10 %}
    <li><span>{{ post.date | date_to_string }}</span> &raquo; <a href="{{ BASE_PATH }}{{ post.url }}">{{ post.title }}</a></li>
  {% endfor %}
</ul>


Todo
===
**2018 Planning**
- Enrich THIS
- AI
- Training


|||
|---|---|
|![Splash](/resources/images/system/splash.jpg){:height="50%" width="50%"}|![Splash](/resources/images/system/splash.jpg){:height="50%" width="50%"}|