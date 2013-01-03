---
layout: post
title: "How to install a CLSI"
date: 2012-10-07 20:32
comments: true
categories: [LaTeX, CLSI, How To]
---
This guide explains how to install a CLSI server using passenger standalone server running Debian Squeeze.
The steps can easely be adapted to any linux installation.

## Install LaTeX
First, you will have to install LaTeX.  Include all the extra packages so your users will be
able to compile almost everything.

{% codeblock lang:console %}
aptitude install texlive
aptitude install texlive-extra
aptitude install texlive-latex-extra
{% endcodeblock %}

## Install ruby
Install ruby.  In this case, I installed ```ruby 1.8```.  Make sure to install ```rails version
1.1.0```, because the CLSI server will not run with a newer version of it.  Also, install
```rspec``` and ```rspec-rails``` since they are a requirement for the CLSI.

{% codeblock lang:console %}
apt-get install build-essential ruby rdoc ruby1.8-dev libopenssl-ruby rubygems1.8
gem install fastthread
gem install rails --version 1.1.0
gem instal rake
apt-get install sqlite3
apt-get install libsqlite3-ruby
gem install sqlite3
gem install sqlite3-ruby
gem install rspec
gem install rspec-rails
{% endcodeblock %}

### Config
Add to your ```.bashrc``` ruby's path.

{% codeblock lang:bash %}
export PATH=$PATH"/var/lib/gems/1.8/bin"
{% endcodeblock %}

## Install the CLSI
Now, download the CLSI server from its GitHub repository.

{% codeblock lang:console %}
wget https://github.com/scribtex/clsi/zipball/master
{% endcodeblock %}

Unzip it to the install folder (e.g., ```/var/apps/clsi```)

## Configure the CLSI
From the install folder of the app (e.g., ```/var/apps/clsi```), create the
config files using the examples provided

{% codeblock lang:console %}
cp config/config.yml.local_example config/config.yml
cp config/database.yml.example config/database.yml
{% endcodeblock %}

You might need to change the installation directory for the latex binaries,
use ```which latex``` to find out where they are installed.

Update the host with the host address you will use for passenger.

## Create your first user
First create the database and then lunch the CLSI console

{% codeblock lang:console %}
rake db:migrate
script/console
{% endcodeblock %}

Once you are in the console, create the user new user and save it.

{% codeblock lang:ruby %}
>> User.create!(:name => "Username", :email => "email")
>> u = User.find_by_id(id)
>> u.save!
{% endcodeblock %}


## Install passenger standalone
First, install passenger dependencies that are not usually shipped with a
standard system.

{% codeblock lang:console %}
apt-get install libcurl4-openssl-dev libssl-dev zlib1g-dev 
{% endcodeblock %}

Then, install passenger standalone.  This will compile a version of nginx that 
passenger will use to run the CLSI

{% codeblock lang:console %}
gem install passenger
passenger start
{% endcodeblock %}

**Note:** Passenger is also avaiable as a plugin for Nginx or Apache.  I had less
trouble running passenger standalone.

## Instaling passenger initscript
Since we want to be able to start passenger without much trouble, let's install
an ```init.d``` script to handle passenger.

{% codeblock lang:console %}
cd /etc/init.d
wget https://github.com/railsware/passenger-initscript/raw/master/passenger
chmod +x passenger
/etc/init.d/passenger setup
cp /etc/passenger/example.yml.disabled /etc/passenger.d/clsi.yml
{% endcodeblock %}

Remember to edit the config based on your needs.  This init script can handle different
instances of passenger using ```rvm```, but this functionality is not covered in this 
guide.

### Start passenger
To start passenger, run

{% codeblock lang:console %}
/etc/init.d/passenger start
{% endcodeblock %}

### Start passenger at startup
If you want to start passenger at start-up, use

{% codeblock lang:console %}
update-rc.d passenger defaults
{% endcodeblock %}

## Final thoughts
You should now have a running CLSI installed on your server.  You will have to setup
a redirect to the app using your webserver or run the CLSI directly on port 80 to allow
direct access.