# Class: apache_httpd::service
#
# Apache httpd web server service class.
#
class apache_httpd::service (
  $service_restart        = $::apache_httpd::params::service_restart,
) {

  include '::apache_httpd::install'

  # Main service
  service { 'httpd':
    ensure    => running,
    enable    => true,
    restart   => $service_restart,
    hasstatus => true,
    require   => Package['httpd'],
  }
}
