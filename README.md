# puppet-apache_httpd

## Overview

Install the Apache HTTP daemon and manage its main configuration as well as
additional configuration snippets.

The module is very Red Hat Enterprise Linux focused, as the defaults try to
change everything in ways which are typical for RHEL.

* `apache_httpd` : Main definition for the server and its main configuration.
* `apache_httpd::file` : Definition to manage additional configuration files.

The main `apache_httpd` isn't a class in order to be able to set global
defaults for its parameters, which is only possible with definitions. The
`$name` can be either `prefork` or `worker`.

This module disables TRACE and TRACK methods by default, which is best practice
(using rewrite rules, so only when it is enabled).

The `apache::service::` prefixed classes aren't meant to be used standalone,
and are included as needed by the main class.

## Examples

Sripped down instance running as the git user for the cgit cgi :

    apache_httpd { 'worker':
        modules   => [ 'mime', 'setenvif', 'alias', 'proxy', 'cgi' ],
        keepalive => 'On',
        user      => 'git',
        group     => 'git',
    }

Complete instance with https, a typical module list ready for php and the
original Red Hat welcome page disabled :

    apache_httpd { 'prefork':
        ssl     => true,
        modules => [
            'auth_basic',
            'authn_file',
            'authz_host',
            'authz_user',
            'mime',
            'negotiation',
            'dir',
            'alias',
            'rewrite',
            'proxy',
        ],
        welcome => false,
    }

Example entry for `site.pp` to change some of the defaults globally :

    Apache_httpd {
        extendedstatus  => 'On',
        serveradmin     => 'root@example.com',
        serversignature => 'Off',
    }

Configuration snippets can be added from anywhere in your manifest, based on
files or templates, and will automatically reload httpd when changed :

    apache_httpd::file { 'www.example.com.conf':
        source => 'puppet:///modules/mymodule/httpd.d/www.example.com.conf',
    }
    apache_httpd::file { 'global-alias.conf':
        content => 'Alias /whatever /var/www/whatever',
    }
    apache_httpd::file { 'myvhosts.conf':
        content => template('mymodule/httpd.d/myvhosts.conf.erb'),
    }

Note that when adding or removing modules, a reload might not be sufficient,
in which case you will have to perform a full restart by other means.

