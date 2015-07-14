#
class apache_httpd::params {

  case $::osfamily {
    'RedHat': {
      if versioncmp($::operatingsystemrelease, '7') >= 0 {
        $httpd_version = '2.4'
        $service_restart = '/bin/systemctl reload httpd.service'
      } else {
        $httpd_version = '2.2'
        $service_restart = '/sbin/service httpd reload'
      }
    }
    default: {
      $httpd_version = '2.2'
      $service_restart = '/bin/kill -HUP `cat /var/run/httpd.pid 2>/dev/null`'
    }
  }

}

