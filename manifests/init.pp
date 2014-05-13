# Class: apache_httpd
#
# Apache httpd web server main class.
#
# Note that by default a minimal set of modules is enabled in order to have
# the original testing page work, but passing an array of module names as the
# 'modules' parameter resets them to only the 'log' module.
#
# Parameters:
#  Too many to list here. See the module's init.pp file.
#
# Sample Usage :
#  class { 'apache_httpd':
#    modules => [ 'mime' ],
#  }
#
class apache_httpd (
  $worker                 = false,
  $ssl                    = false,
  # Options for the sysconfig file
  $options                = false,
  $httpd_lang             = false,
  $pidfile                = false,
  # Options for httpd.conf
  # These are not critical modules, but they are needed for welcome.conf
  $modules                = [
    'authz_host',
    'include',
    'mime',
    'negotiation',
    'alias',
  ],
  # The original default is 'OS', but 'Prod' makes more sense to hide version
  $servertokens           = 'Prod',
  # timeout is a reserved puppet variable
  $timeout_seconds        = '60',
  $keepalive              = 'Off',
  $maxkeepaliverequests   = '100',
  $keepalivetimeout       = '15',
  $startservers           = '4',
  $minspareservers        = '2',
  $maxspareservers        = '8',
  $serverlimit            = '256',
  $maxclients             = '256',
  $maxrequestsperchild    = '4000',
  $minsparethreads        = '25',
  $maxsparethreads        = '75',
  $threadsperchild        = '32',
  $listen                 = [ '80' ],
  $namevirtualhost        = [],
  $extendedstatus         = 'Off',
  $user                   = 'apache',
  $group                  = 'apache',
  $serveradmin            = 'root@localhost',
  $servername             = undef,
  $usecanonicalname       = 'Off',
  $documentroot           = '/var/www/html',
  $serversignature        = 'On',
  # Other
  $welcome                = true,
  $logrotate_files        = '/var/log/httpd/*log',
  $logrotate_freq         = false,
  $logrotate_opts         = [
    'missingok',
    'notifempty',
    'sharedscripts',
    'delaycompress',
  ],
) inherits '::apache_httpd::params' {

  include '::apache_httpd::install'

    # Our own pre-configured file (disable nearly everything)
    file { '/etc/httpd/conf/httpd.conf':
        require => Package['httpd'],
        content => template('apache_httpd/conf/httpd.conf.erb'),
        notify  => Service['httpd'],
    }

    # On RHEL5, this gets in the way... it should be configured from elsewhere
    if $::operatingsystem == 'RedHat' and $::operatingsystemrelease < 6 {
        # We can't 'ensure => absent' or it would reappear with updates
        apache_httpd::file { 'proxy_ajp.conf':
            source => "puppet:///modules/${module_name}/proxy_ajp.conf",
        }
    } else {
        # Just in case we have updated from RHEL5
        apache_httpd::file { 'proxy_ajp.conf':
            ensure  => absent,
        }
    }

    # Install extra file to disable TRACE and TRACK methods
    apache_httpd::file { 'trace.inc':
        source => "puppet:///modules/${module_name}/trace.inc",
    }

    # Change the original welcome condition, since our default has the index
    # return 404 instead of 403.
    if $welcome {
        apache_httpd::file { 'welcome.conf':
            source => "puppet:///modules/${module_name}/welcome.conf",
        }
    } else {
        apache_httpd::file { 'welcome.conf':
            # Don't "absent" since the file comes back when httpd is updated
            content => "# Default welcome page disabled\n",
        }
    }

    # Tweak the sysconfig file
    file { '/etc/sysconfig/httpd':
        require => Package['httpd'],
        content => template('apache_httpd/etc/sysconfig.erb'),
        notify  => Service['httpd'],
    }

    # Install the custom logrotate file
    file { '/etc/logrotate.d/httpd':
        require => Package['httpd'],
        content => template('apache_httpd/etc/logrotate.erb'),
    }

    # We use classes with inheritence in order to perform service overrides
    if $ssl {
        include apache_httpd::service::ssl
    } else {
        include apache_httpd::service::base
    }

}

