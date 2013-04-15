# We need the package and service for the file definition to work
import 'init.pp'
apache_httpd::file { 'foo.conf':
    source => "puppet:///modules/${module_name}/welcome.conf",
}
apache_httpd::file { 'foo-ssl.conf':
    content => template('apache_httpd/conf.d/ssl.conf'),
}

