class apache_httpd::params {

  case $::operatingsystem {
    'RedHat','CentOS','Scientific': {
      if $::operatingsystemrelease >= 7 {
        $httpd_version = '2.4'
      } else {
        $httpd_version = '2.2'
      }
    }
  }

}

