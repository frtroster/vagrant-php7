#PHP 7 Vagrant Development setup


## Installation

#### Please read carefully every step! This setup is based and tested with Ubuntu 16.04 64 bit base box, with Vagrant 1.8 version

* Install Vagrant using the [installation instructions](http://docs.vagrantup.com/v2/installation/index.html)

* You need to install vbox additions so it's in sync with the virtual and local machine
    * ```vagrant plugin install vagrant-vbguest```

* Clone this repository
    * ```$ git clone https://github.com/frtroster/vagrant-php7.git```

* Install git submodules (if not using sourcetree)
    * ```$ git submodule update --init```

* You need to install vagrant DNS plugin to have domain resolve
    * ```vagrant plugin install vagrant-hostsupdater```

## Initiate your project structure

* All your symfony projects should reside in folder ```projects``` within this folder. So create projects folder and place projects git repositories there. It's ignored by git so it doesn't mess up anything.

* Configure parameters.yml by renaming parameters.yml.dist and setting the right values. **parameters.yml is ignore by git so it's for using local configuration.**

* Run vagrant (for the first time it should take up to 10-15 min)
    ```$ vagrant up```

* Web server is accessible with http://33.33.33.100 (IP address can be changed in Vagrantfile). **For accessing web used configured hostnames from parameters.yml.**

* Vagrant automatically setups database with this setup:

    * Username: symfony
    * Password: symfony-vagrant
    * Database: symfony

## Troubleshooting

* Sometime it's better to start from scratch (destroys machine so it can be created with vagrant up):
    ```vagrant destroy```
* As you're running composer under vagrant user and nginx is using www-data user you'll get write error on cache and logs folders. Run this in project folder to fix permissions:
    * ```sudo setfacl -R -m u:www-data:rwx -m u:`whoami`:rwx app/cache app/logs```
    * ```sudo setfacl -dR -m u:www-data:rwx -m u:`whoami`:rwx app/cache app/logs```

## Installed components

* [Nginx](http://nginx.org/en/) using puppet module from [example42](https://github.com/example42/puppet-nginx)
* [MySQL](http://www.mysql.com/) using puppet module from [example42](https://github.com/example42/puppet-mysql)
* [PHP-FPM](http://php-fpm.org/) (PHP 5.4)
* [GiT](http://git-scm.com/)
* [Composer](http://getcomposer.org) installed globally (use ```$ composer self-update``` to get the newest version)
* [Vim](http://www.vim.org/)
* [cURL](http://curl.haxx.se/)
* [less](http://lesscss.org/)
* [OpenJDK](http://openjdk.java.net/)
* [sass](http://sass-lang.com/)
* [Compass](http://compass-style.org/)
* [memcached](http://memcached.org/)

## Thanks to

* [irmantas](https://github.com/irmantas/symfony2-vagrant) - based on his work

## TODO
You tell me
