---
layout: post
title: "Search Using DuckDuckGo"
date: 2012-10-26 12:28
comments: true
categories: ["Octopress"]
keywords: "octopress, duckduckgo, search"
---

It is very easy to change the default search engine from <a href="http://www.google.com">Google</a>
to <a href="http://duckduckgo.com/">DuckDuckGo</a>.

First, you will have to change the simple seach URL in your <code>_config.yml</code> file
to <code>http://www.duckduckgo.com/</code>

Then, you will have to update your navigation include in <code>source/_includes/navigation.html</code>
in this way:

{% codeblock source/_includes/navigation.html %}
{% raw %}
{% if site.simple_search %}
<form action="{{ site.simple_search }}" method="get">
  <fieldset role="search">
    <input type="hidden" name="sites" value="duckduckgo.com" />
    <input class="search" type="text" name="q" results="0" placeholder="Search&hellip;"/>
  </fieldset>
</form>
{% endif %}
{% endraw %}
{% endcodeblock %}

Generate and deploy your blog to start using DuckDuckGo as your default search
engine.