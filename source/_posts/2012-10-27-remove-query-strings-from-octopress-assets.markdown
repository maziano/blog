---
layout: post
title: "Remove Query Strings from Octopress Assets"
date: 2012-10-27 12:18
comments: true
categories: ["Octopress", "Compass"]
keywords: "octopress, compass, query strings, image_url()"
---
Since [Octopress](http://octopress.org/) uses [Compass](http://compass-style.org/)
as the defauls CSS authoring framework, query strings will be added to your image URL by default.

If you want to remove them, you will have to add the following code to your ```config.rb``` file :

{% codeblock config.ru %}
# Disable query string in compass
asset_cache_buster :none
{% endcodeblock %}