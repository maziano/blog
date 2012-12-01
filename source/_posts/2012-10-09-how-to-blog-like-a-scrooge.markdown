---
layout: post
title: "How to blog scrooge style"
date: 2012-10-09 14:42
comments: true
tags: [How To, Blog, Web Hosting, CloudFlare, Heroku, Octopress]
---

{% img right http://static.pacbard.tk/media/2012/scrooge.jpeg 319 338 Scrooge style%}
When I decided to revamp my blog, I was looking for an option that would have
been nerdy but at the same time cool. I decided to use [Octopress](http://octopress.org)
ad my blogging platform.  After some tries on my own computer, I have moved the
entire project on [Cloud9](https://c9.io), [Heroku](http://www.heroku.com), and
[CloudFlare](https://www.cloudflare.com).  This allows me to have a free platform
for blogging, a web hosting server, and a CDN system all for free (more on the
domain later on).

## Setting up Octopress
Setting up [Octopres](http://octopress.org) is quite easy.  Just open up
[Cloud9](https://c9.io), and clone the official [Octopress repository](https://github.com/imathis/octopress).

See the instructions in the [Octopress Setup](http://octopress.org/docs/setup/)
page for more details.

## Setting up Heroku
After you are done creating your Octopress blog, it is time to sign up for a free
Heroku account.

For this blog, I decided to generate (or bake, in hacker speak) my website on
Cloud9 and then push only my public folder to Heroku.  I have noticed that my repo's
size is almost neglectable and my app uses around 1Mb of slug size.

To do this, I created the folder ```_heroku```.  Then, I initialized ```git```
there and I created a new Heroku app.  After I had your Heroku app up and running,
I modified my ```Rakefile``` in order to be able to use the command ```rake deploy```
with Heroku.  [Joshua Wood](http://joshuawood.net/how-to-deploy-jekyll-slash-octopress-to-heroku/)
has a handy how to on know to achieve it.  Hopefully, in a future this will be
included into the regular Octopress distribution.

I modified my ```Gemfile``` in the folder ```_heroku```, because the only gem that
I needed on Heroku is ```sinatra```, since the blog generation is done locally.

## .tk domain
This is the very cheap part of my setup.  Since I do not want to pay for a domain,
I decided to go with the most scroogy (is this even a word?) domain possible.
Anyways, I created my domain with the [.tk registrar](http://www.dot.tk/).
The whole operation probably took me five minutes.  I logged in using my social
account (i.e., my Google account) and I was online.  Even the DNS server updated
at a lighting speed.  It was quite surprising after all.

## CloudFlare
Since I wanted to serve my blog using a [CDN](http://en.wikipedia.org/wiki/Content_delivery_network),
I signed up for CloudFlare as well.  At first, I had my doubts about them accepting
a .tk domain, but it was accepted.

First, I had to redirect my .tk domain to their NameServers.  To to it, I had to
login into [DNS dashboard](http://my.dot.tk) and change my settings in 'custom DNS'.
I pointed the NameServer to CloudFlare's servers.  It took CloudFlare
around one hour to verify that the NameServers were set up correctly, but it the
meantime the DNS redirect was already working as well as all my subdomains.

I followed the guide on [Heroku](https://devcenter.heroku.com/articles/custom-domains)
on how to setup custom domains.  At this time, ```www.pacbark.tk``` and ```blog.pacbard.tk```
point to my Heroku app.  I also created the ```direct``` subdomain in order to skip
CloudFlare servers and access the app directly.

### Root domain
I also redirected my root domain (i.e., ```pacbard.tk```) to ```www.pacbard.tk```.
This because if I ever want to move my blog to [Amazon S3](http://aws.amazon.com/s3/)
I just have to update my app redirects.  I used the free - did I mention **free**? -
naked domain redirect offered by [wwwizer](http://wwwizer.com/naked-domain-redirect).
Basically, I pointed the ```A record``` for ```pacbard.tk``` to ```174.129.25.170```.
That's it.

## Final thoughts
This is essentially my base configuration. At this time, I have no idea on how
Heroku will handle my blog traffic.  I think that this blog will not crash
under heavy traffic anytime soon.
If I have time, I will soon write about how I am using Cloud9 IDE for this blog.
