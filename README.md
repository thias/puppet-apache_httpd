# puppet apache_httpd

## Overview

Install the Apache HTTP daemon and manage its main configuration as well as
additional configuration snippets.

The module is very Red Hat Enterprise Linux focused, as the defaults try to
change everything in ways which are typical for RHEL.

* `apache_httpd` : Main class for the server and its main configuration.
* `apache_httpd::file` : Definition to manage additional configuration files.

This module disables TRACE and TRACK methods by default, which is best practice
(using rewrite rules, so only when it is enabled).

## Examples

Sripped down instance running as the git user for the cgit cgi :

```puppet
class { 'apache_httpd':
  mpm       => 'worker',
  modules   => [ 'mime', 'setenvif', 'alias', 'proxy', 'cgi' ],
  keepalive => 'On',
  user      => 'git',
  group     => 'git',
}
```

Complete instance with https, a typical module list ready for php and the
original Red Hat welcome page disabled :

```puppet
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
```

Example entry for hiera to change some of the defaults globally :

```yaml
---
apache_httpd::extendedstatus: 'On'
apache_httpd::serveradmin: 'root@example.com'
apache_httpd::serversignature: 'Off'
```

Configuration snippets can be added from anywhere in your manifest, based on
files or templates, and will automatically reload httpd when changed :

```puppet
apache_httpd::file { 'www.example.com.conf':
  source => 'puppet:///modules/mymodule/httpd.d/www.example.com.conf',
}
apache_httpd::file { 'global-alias.conf':
  content => 'Alias /whatever /var/www/whatever',
}
apache_httpd::file { 'myvhosts.conf':
  content => template('mymodule/httpd.d/myvhosts.conf.erb'),
}
```

Note that when adding or removing modules, a reload might not be sufficient,
in which case you will have to perform a full restart by other means.

## Updating

Before version 0.5 of the module, `apache_httpd` was a definition for
historical reasons : It wasn't possible to pass parameters to classes when
the module was initially written. Starting with 0.5.0, `apache_httpd` is now
a class, making the module more flexible with Hiera or an ENC.
Migrating to using the class is trivial :

```puppet
apache_httpd { 'prefork':
  # Parameters here...
}
```

Becomes (since `'prefork'` was the default) :

```puppet
class { '::apache_httpd':
  # Same parameters here...
}
```

And the `'worker'` title becomes the `mpm => 'worker'` parameter.

