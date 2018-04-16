---
layout: post
category: tech
tagline: ""
tags : [jekyll]
comments: true
---
{% include JB/setup %}

### 简介
Jekyll 提供了功能强大的博客功能，但是还是缺乏用户统计的功能。缺的这一块当前github io Pages  
考虑使用麻雀虽小五脏俱全的MixPanel。Jekyll 本身带有分析统计的框架，需要客制化代码后才能正常运作。  
### Git Hub 配置
#### _config.xml 配置Token 变量
```
analytics :
    provider : mixpanel # 设置provider 为 mixpanel
    gauges : 
        site_id : 'SITE ID'
    google : 
        tracking_id : 'UA-123-12'
    getclicky : 
      site_id : 
    mixpanel : 
        token : 'Mixpanel Token' # 配置Token
    piwik : 
        baseURL : 'myserver.tld/piwik' # Piwik installation address (without protocol)
        idsite : '1'                   # the id of the site on Piwik

```


#### 修改analytics-providers/mixpanel
**路径**  
> _includes/JB/analytics-providers/mixpanel  
**内容**  
```
script type="text/javascript">
(function(e,a){if(!a.__SV){var b=window;try{var c,l,i,j=b.location,g=j.hash;c=function(a,b){return(l=a.match(RegExp(b+"=([^&]*)")))?l[1]:null};g&&c(g,"state")&&(i=JSON.parse(decodeURIComponent(c(g,"state"))),"mpeditor"===i.action&&(b.sessionStorage.setItem("_mpcehash",g),history.replaceState(i.desiredHash||"",e.title,j.pathname+j.search)))}catch(m){}var k,h;window.mixpanel=a;a._i=[];a.init=function(b,c,f){function e(b,a){var c=a.split(".");2==c.length&&(b=b[c[0]],a=c[1]);b[a]=function(){b.push([a].concat(Array.prototype.slice.call(arguments, 0)))}}var d=a;"undefined"!==typeof f?d=a[f]=[]:f="mixpanel";d.people=d.people||[];d.toString=function(b){var a="mixpanel";"mixpanel"!==f&&(a+="."+f);b||(a+=" (stub)");return a};d.people.toString=function(){return d.toString(1)+".people (stub)"};k="disable time_event track track_pageview track_links track_forms register register_once alias unregister identify name_tag set_config reset people.set people.set_once people.unset people.increment people.append people.union people.track_charge people.clear_charges people.delete_user".split(" "); for(h=0;h<k.length;h++)e(d,k[h]);a._i.push([b,c,f])};a.__SV=1.2;b=e.createElement("script");b.type="text/javascript";b.async=!0;b.src="undefined"!==typeof MIXPANEL_CUSTOM_LIB_URL?MIXPANEL_CUSTOM_LIB_URL:"file:"===e.location.protocol&&"//cdn.mxpnl.com/libs/mixpanel-2-latest.min.js".match(/^\/\//)?"https://cdn.mxpnl.com/libs/mixpanel-2-latest.min.js":"//cdn.mxpnl.com/libs/mixpanel-2-latest.min.js";c=e.getElementsByTagName("script")[0];c.parentNode.insertBefore(b,c)}})(document,window.mixpanel||[]); mixpanel.init("{{ site.JB.analytics.mixpanel.token}}");
</script>
```

#### 修改 posts 的内容
>  _includes/themes/bootstrap-3/post.html  
  
```
{% include JB/analytics %}
<script>
 mixpanel.track("View posts");
</script>
```

### Mixpanel 统计截图
![Mix Panel 统计](/resources/images/2018/4/sc-mixpanel-1.png){:height="100%" width="100%"}  