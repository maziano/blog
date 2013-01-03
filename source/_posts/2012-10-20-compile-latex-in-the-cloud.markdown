---
layout: post
title: "Compile LaTeX in the cloud"
date: 2012-10-20 12:36
comments: true
categories: ["LaTeX"]
---

Installing LaTeX on a computer (especially a Windows one) feels so much like 1995.
The most painful aspect of  installing <a href="http://www.latex-project.org/" title="LaTeX -
A document preparation system">LaTeX</a> is downloading all the packets and maintaining your
installation.

Thanks to the <a href="http://en.wikipedia.org/wiki/Internet">Internet</a> and the
<a href="https://openshift.redhat.com/app/">Cloud</a>, this is no longer the case.  You can
install and run your own LaTeX compiling server using open source programs and
enjoy compiling LaTeX on every machine that runs <a href="http://www.python.org/getit/">Python</a>
and has around 5 MB of free space.  Yes, it is right 5 MB of free space to compile
LaTeX documents.

# Some background
The CLSI idea was born out of an attempt to
<a href="http://code.google.com/p/common-latex-service-interface/">integrate LaTeX with Google Docs</a>.<br />
<a href="http://docs.latexlab.org/">LaTeX Lab</a> was the first attempt to provide an online
LaTeX editor.  The core of the server was written in PHP and hosted as a Google App.
The service is still live but it is not under active development anymore.

A spin-off of this project (and a more successful one, in my humble opinion) is
<a href="http://www.scribtex.com/">ScribTex</a> and the supporting LaTeX compiling server
at <a href="http://clsi.scribtex.com/">clsi.scribtex.com</a>.  In this case, the server was
rewritten using <a href="http://rubyonrails.org/">Ruby onRails</a> and <a href="http://rspec.info/">RSpec</a>.
This service comes with a dedicated website and a collaborative online editor.

While the original CLSI required dedicated LaTeX binaries (in fact, it came with
its own TeXLive binaries), the ScribTeX implementation just requires LaTeX to be
installed somewhere on your machine and the CLSI does the rest.

# Why use your own CLSI server
With all this free options online, install and run your own CLSI server might
seem a little to much (and in most cases, it is).

The biggest advantage in running your own CLSI server will give you the freedom
to install and maintain a dedicated LaTeX installation. Since most CLSI servers
run a stripped-down version of LaTeX, it is difficult to compile a document that
requires exotic or new packets.  For example, ScribTeX&#8217;s CLSI runs on a customized 2009
TeXLive installation.  If you need a packet that has been included in TeXLive
after that released, you are out of luck.

# Installing your own CLSI server
It is quite easy to setup and run your own CLSI server.  All it takes is a server,
some experience with Ruby on Rails and the unix console.

<a href="blog/2012/10/07/how-to-install-a-clsi/">In a previous post</a>, I already
discussed how to install and run a CLSI server using
your own web server.  In this case, we will install a CLSI in the cloud, cutting
off the need of maintaining your own physical web server.

## RedHad Cloud
In this case, the best <a href="http://en.wikipedia.org/wiki/Platform_as_a_service">PaaS</a>
service to host a CLSI is provided by <a href="http://www.redhat.com/">RedHat</a>.  To my
knowedge, <a href="https://openshift.redhat.com/">OpenShift</a> is the only PaaS that offers
<a href="http://en.wikipedia.org/wiki/Secure_Shell">SSH</a> access
<a href="https://openshift.redhat.com/community/developers/remote-access">out of the box</a>.
This is a critical aspect since we will use SSH to install and maintain the
TeXLive on the server

## Creating your Application
The first step is to sign-up for an <a href="https://openshift.redhat.com/app/account/new">OpenShift account</a>
and to create a <strong>Ruby 1.8</strong> application from the pre-made cartridge.  Once you
are all set, fork or clone my <a href="https://github.com/pacbard/clsi">GitHub CLSI</a>, since
it is already configured to work on OpenShift and with the LaTeX installation
described further down in this post.

This CLSI server is already configured to work on as a OpenShift app.  It places
the user database in the data folder, so it will not be lost every time you
push a new app and it will look for the LaTeX binaries in the ```data/latex```
folder.  I also modified the server side of the CLSI to support
<a href="http://en.wikipedia.org/wiki/Base64">Base64</a>  file uploads, just in case you want
to include images or you use an encoding other than <a href="http://en.wikipedia.org/wiki/Utf8">UFT-8</a>
for your files.  Note that Base64 support is not yet being implemented or supported
by the standard CSLI server branch.

After you created your application and forked/cloned the CLSI server, you have to
just push it to your application.  Just follow the official <a href="https://openshift.redhat.com/community/get-started">how-to</a>
and everything should run smoothly.

## Installing LaTeX
OpenShift runs a stripped-down version of RedHat Enterprise edition, so it will
run unix LaTeX binaries.  I have opted to a net-install for LaTeX, because a
free OpenShift application comes with only 1 GB of disk space. The
<a href="http://tug.org/texlive/acquire-netinstall.html">TeXLive net-install</a> script
works just fine on OpenShift.

## OpenShift and LaTeX
Unless you want to manage your LaTeX installation as part of your application
repository, it is a good idea to install LaTeX on the permanent storage of your
OpenShift application.  Once you connect through SSH to your application, just
open the folder ```app_root/data```.  Everything in this folder will not be
erased every time that you push a new version of your application (as it happens
with the data in your repo).

To install LaTeX using the net-install script, you will have to manually set the
installation directory to your application&#8217;s data directory.  To do so, run the
installer script with ```./install_tl``` once you are in the script folder.

Use option ```d``` and then ```1``` to modify the installation directory to ```~/app-root/data/latex```

This will modify the base installation directory to your app&#8217;s data folder.  Then,
setup your LaTeX installation with the packets that you prefer (note that you
will be allowed to install additional packets through the TeXLive manager script).

In my case, I installed LaTeX using the medium scheme and I removed the ```font/macro doc tree```
and ```font/macro source tree``` to save some precious disk space using the
options menu.

After you are done setting up your installation, the TeXLive script will take
care of the rest.  Just sit tight.  After some time, you should have a working
LaTeX installation on your OpenShift app.

# The CLSI client
Now that you have a running CLSI server and a dedicated LaTeX installation, you
have to grab the CLSI client from <a href="http://pacbard.github.com/RLatex/">GitHub</a>.
The client is written in <a href="http://www.python.org/">Python</a>, so it should work
on most modern computers that can run the Python virtual machine.  

The client connects to the server, downloads the ```pdf``` result, and prints
to screen the LaTeX log.  Read the documentation if you want a different behavior,
since you will be able to modify it using command line options.

The only setting that the client requires is the login file.  As default, the
client looks for the login file in its installation directory.  Update the sample
login file with your own settings and it all should work well.

## MS Windows
If you use <a href="http://en.wikipedia.org/wiki/Microsoft_Windows">MS Windows</a>,
I am maintaining a ```exe``` version of the compiler that does not require
to install Python on the computer.  You can find the executable on
<a href="https://github.com/pacbard/RLatex/downloads">GitHub</a>.  Install it somewhere and
point your LaTeX compiler to that folder.  Disable ```BibTeX``` and ```MakeIndex```,
since the CLSI server will already take care of everything for you. Refer to your
LaTeX editor's manual on how to setup your own LaTeX compiler.

Alternatively, you can install Python and run the script using Python.

## Mac OS
If you are using <a href="http://pages.uoregon.edu/koch/texshop/">TeXShop</a>, you might
want to create a custom Engine.  Here is my own:

{% codeblock lang:bash%}
#!/bin/bash
export TSBIN="$HOME/Library/TeXShop/bin/rlatex.py"

python ${TSBIN} -f ~/.rlatex/login "$1"
{% endcodeblock %}

In this case, I created a ```.rlatex``` folder in my home and the ```login```
file with my login information, so I do not have to go thorugh my Library every
time I want to update my login information.  I also have installed my Python
script in TeXShop&#8217;s ```bin``` directory.  

To install the script there, just run

{% codeblock lang:bash%}
curl https://raw.github.com/pacbard/RLatex/master/rlatex.py > ~/Library/TeXShop/bin/rlatex.py
{% endcodeblock %}

This same command will work if you want to update your script.

## Linux
At this time, I was not able to test my client in Linux, but I think that it will
run without major issues, as long as you are using Python 2.7.

# Final thoughts
This setup should allow you to have a running CLSI server in the cloud that you
can access using a simple client on all your machines, regardless of your operative
system (as long as you can run Python on them).

It can take something like 5 seconds to upload your source, compile it, and download
the result. For my experience, it is comparable (if not even faster) to compiling
the document locally on your machine.

## Downsides
First, you have to be connected to the internet in order to be able to compile
your LaTeX documents.  I think that this is the natural trade-off between installing
LaTeX locally or running a webservice.  Nowadays, it is possible to connect to the
Internet almost everywhere, so this should not be a major issue.

Second, a free OpenShift application just comes with a limited disk space and
computing power.  My informal benchmarks show that compiling using your own
CLSI service takes between two to three times longer that using ScribTeX&#8217;s CLSI
service.  For example, compiling ```simple.tex``` file that comes with the client
takes around 2 seconds on my CLSI and less than 1 second on ScribTeX&#8217;s CLSI.
More complex documents can take double that time to compile on OpenShift.

Last, as everything that is on the Internet, your documents will be publicly accessible
on the internet.  The CLSI server assigns a random URL address to your documents,
so it is unlikely that someone would be able to guess it.  Also, you can use
the ```robots.txt``` in your app public folder to control what you want to index.
By default, robots are disallowed on the whole CLSI public folder.  Communication
with the CLSI uses the <a href="http://en.wikipedia.org/wiki/Hypertext_Transfer_Protocol">HTTP protocol</a>,
so it is not secured in any mean.  If you are compiling sensitive information, the
best thing to do is to do it locally on a secure computer.