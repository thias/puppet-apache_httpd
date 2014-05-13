# Class: apache_httpd::install
#
class apache_httpd::install (
  $ensure = 'installed',
) {

  package { 'httpd': ensure => $ensure }

}

