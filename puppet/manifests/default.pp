Exec { path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/" ] }


class system-update {

    exec { 'apt-get update':
        command => 'apt-get -y update',
    }

    exec { 'apt-get upgrade':
        command => 'apt-get -y upgrade',
        require => Exec['apt-get update']
    }

    exec { 'apt-get autoremove':
        command => 'apt-get -y autoremove',
        require => Exec['apt-get upgrade']
    }
}

class dev-packages {

    include gcc
    include wget

    $devPackages = [ "vim", "curl", "git", "ruby-compass", "openjdk-8-jre", "ruby-augeas" ]
    package { $devPackages:
        ensure => "installed",
        require => Exec['apt-get update'],
    }
}

class nginx-setup {

    include nginx

    package { "python-software-properties":
        ensure => present,
    }

    file { '/etc/nginx/sites-available/default':
        owner  => root,
        group  => root,
        ensure => file,
        mode   => 644,
        source => '/vagrant/files/nginx/default',
        require => Package["nginx"],
    }

    file { "/etc/nginx/sites-enabled/default":
        notify => Service["nginx"],
        ensure => link,
        target => "/etc/nginx/sites-available/default",
        require => Package["nginx"]
    }

    exec { 'restart nginx':
        command     => '/usr/sbin/service nginx restart',
        refreshonly => false,
        require     => Service['nginx'];
    }
}

class { "mysql":
    root_password => '1234',
}

mysql::grant { 'symfony':
    mysql_privileges => 'ALL',
    mysql_password => 'symfony-vagrant',
    mysql_db => 'symfony',
    mysql_user => 'symfony',
    mysql_host => 'localhost',
}

class php-setup {

    $php = ["php-fpm", "php-cli", "php-dev", "php-curl", "php-apcu", "php-mysql", "php-memcache", "php-intl", "php-xdebug"]

    package { $php:
        notify => Service['php7.0-fpm'],
        ensure => latest,
    }

    package { "apache2.2-bin":
        notify => Service['nginx'],
        ensure => purged,
        require => Package[$php],
    }

    file { '/etc/php/7.0/cli/php.ini':
        owner  => root,
        group  => root,
        ensure => file,
        mode   => 644,
        source => '/vagrant/files/php/cli/php.ini',
        require => Package[$php],
    }
/*
    file { '/etc/php/7.0/fpm/php.ini':
        notify => Service["php7.0-fpm"],
        owner  => root,
        group  => root,
        ensure => file,
        mode   => 644,
        source => '/vagrant/files/php/fpm/php.ini',
        require => Package[$php],
    }
*/
    service { "php7.0-fpm":
        ensure => running,
        require => Package["php-fpm"],
    }
}

class composer {
    exec { 'install composer php dependency management':
        command => 'curl -s http://getcomposer.org/installer | php -- --install-dir=/usr/bin && mv /usr/bin/composer.phar /usr/bin/composer',
        environment => ["COMPOSER_HOME=/home/vagrant/.composer"],
        creates => '/usr/bin/composer',
        require => [Package['php-cli'], Package['curl']],
    }

    exec { 'composer self update':
        command => 'composer self-update',
        environment => ["COMPOSER_HOME=/home/vagrant/.composer"],
        require => [Package['php-cli'], Package['curl'], Exec['install composer php dependency management']],
    }

    file { "/home/vagrant/.composer" :
        ensure => directory,
        group => "vagrant",
        owner => "vagrant",
        recurse => true,
    }
}

class swap {

    exec { "create swap file":
      command => "/bin/dd if=/dev/zero of=/var/swap.1 bs=1M count=1024",
      creates => "/var/swap.1",
    }

    exec { "attach swap file":
      command => "/sbin/mkswap /var/swap.1 && /sbin/swapon /var/swap.1",
      require => Exec["create swap file"],
      unless => "/sbin/swapon -s | grep /var/swap.1",
    }
}

class phpunit {
    exec { 'install phpunit':
        command => 'wget https://phar.phpunit.de/phpunit.phar && chmod +x phpunit.phar && mv phpunit.phar /usr/bin/phpunit',
        creates => '/usr/bin/phpunit',
        require => [Package['php-cli'], Package['wget']],
    }
}

class memcached {
    package { "memcached":
        ensure => present,
    }
}

class { 'apt':
    update => {
        frequency => 'daily',
    },
}

class mc {
    exec { 'install MidnightCommander':
        command => 'apt-get install mc --assume-yes',
    }
}

Exec["apt-get update"] -> Package <| |>

include system-update
include dev-packages
include nginx-setup
include php-setup
include composer
include swap
include phpunit
include memcached
include mc
