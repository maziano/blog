---
layout: post
title: "Installing Fancybox with Octopress"
date: 2013-01-05 12:37
comments: true
categories: [Octopress, Fancyox]
keywords: "Octopress, Fancybox, Images, Photo Gallery"
fancybox: false
---

I wanted to use Lightbox to display images in a photogallery in my Octopress blog.
I modified the [Fancybox Plugin](https://gist.github.com/2631877) from 
[Tritarget](http://tritarget.org/blog/2012/05/07/integrating-photos-into-octopress-using-fancybox-and-plugin/) 
and [szm](http://www.forceappx.com/blog/2011/12/28/getting-fancybox-to-play-nice-with-octopress/) 
to play nice with my blog.

The biggest problem with installing Fancybox is its dependency on [jQuery](http://jquery.com/).
Because Octopress is not based on jQuery - at least not versions <2.0, I do not want
to load Fancybox if it is not necessary.

# Installation
This [gist](https://gist.github.com/4057421) has all the files necessary to install 
Fancybox.

## Fancybox CSS
This file goes in your ```sass``` folder.  You can either include it in your ```screen.css```
or leave it as a stand-alone file.  I prefer the latter, so I can load this file
as needed.

## Loading Fancybox
To load Fancybox, you will have to include the Fancybox code in ```_includes/custom/head.html```.
The code is designed to be loaded only if the page or post has the option ```fancybox: true```.
If the variable ```fancybox``` is not defined or is set as ```false```, Jekyll will 
not include the code in the compiled file.

## The plugin
Copy ```photos_tag.rb``` into your ```plugins``` folder.  This plugin is
a slightly modified version of Tritarget's plugin.  I just included his CSS tricks
into the default CSS file.  It just looks cleaner to use to me.

## Fancybox files
Finally, download [Fancybox](http://fancyapps.com/fancybox/) and move 
```jquery.fancybox.pack.js``` to the javascript folder and all the images 
(```pgn``` and ```gif```) to ```images/fancybox```.