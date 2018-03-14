---
layout: page
title: Buchers'
tagline: 不吃屎 23333
---
{% include JB/setup %}


Recent
===
<ul class="posts">
  {% for post in site.posts %}
    <li><span>{{ post.date | date_to_string }}</span> &raquo; <a href="{{ BASE_PATH }}{{ post.url }}">{{ post.title }}</a></li>
  {% endfor %}
</ul>


Todo
===
**2018 计划**
- 丰富这个网站
- 实现小愿望
- 减肥


|||
|---|---|
|![Splash](/resources/images/system/splash.jpg){:height="50%" width="50%"}|![Splash](/resources/images/system/splash.jpg){:height="50%" width="50%"}|