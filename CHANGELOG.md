#### 2015-04-28 - 1.0.0
* Fix OS version check for Puppet 4.
* Replace Modulefile with metadata.json.

#### 2014-11-11 - 0.5.0
* Change apache_httpd from a definition to a class, it was about time.
* Create params class for setting defaults, overridable with hiera.
* Make the service_restart command configurable (reload by default).
* Simplify the service by merging back the classes into the main class.
* Fix OS version comparison for CentOS 7.

#### 2013-10-01 - 0.4.2
* Add global servername parameter.

#### 2013-04-19 - 0.4.1
* Use @varname syntax in templates to silence puppet 3.2 warnings.

#### 2013-03-08 - 0.4.0
* Split module out to its own repo.
* Update README and switch to markdown.
* Cosmetic cleanups.

#### 2012-04-26 - 0.3.2
* Fix logrotate file, the PID path was wrong for most systems (thomasvs).
* Make sure the default logrotate file is identical to the original RHEL6 one.

#### 2012-04-20 - 0.3.1
* Support multiple listens and setting namevirtualhosts (Jared Curtis).

#### 2012-03-07 - 0.3.0
* Rename from apache-httpd to apache_httpd to conform with puppetlabs docs.
* Update tests to cover more cases.
* Include LICENSE since the module will be distributed individually.
* Update included documentation details.

