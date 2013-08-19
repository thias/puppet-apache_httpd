# Class: apache_httpd::install
#
class apache_httpd::install {
  package { 'httpd': ensure => installed }
}
