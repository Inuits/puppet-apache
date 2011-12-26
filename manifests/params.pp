# === Class: apache::params
#
# Configure various apache settings and initialize distro specific settings.
#
# === Parameters:
#   $apache:
#     Configure the apache package name. Defaults do distro specific.
#
#   $apache_dev:
#     Package(s) to install when $devel = true. Defaults to distro specific.
#
#   $apache_ssl:
#
# === Sample Usage:
#
# === Todo:
# * Finish documentation.
class apache::params(
  $apache         = undef,
  $apache_dev     = undef,
  $apache_ssl     = undef,
  $service        = undef,
  $configroot     = undef,
  $vhostroot      = undef,
  $logroot        = undef,
  $user           = undef,
  $group          = undef,
  $devel          = false,
  $ssl            = true,
  $keepalive      = true,
) {

  ####################################
  ####         Package(s)         ####
  ####################################
  $package = $apache ? {
    undef   => $::operatingsystem ? {
      /Debian|Ubuntu/ => 'apache2',
      /CentOS|RedHat/ => 'httpd',
      default         => 'httpd',
    },
    default => $apache,
  }
  $package_devel = $apache_dev ? {
    undef   => $::operatingsystem ? {
      /Debian|Ubuntu/ => 'apache2-threaded-dev',
      /CentOS|RedHat/ => 'httpd-devel',
      /Archlinux/     => [],
      default         => [],
    },
    default => $apache_dev,
  }
  $package_ssl = $apache_ssl ? {
    undef   => $::operatingsystem ? {
      /Debian|Ubuntu/ => [],
      /CentOS|RedHat/ => 'mod_ssl',
      default         => [],
    },
    default => $apache_ssl,
  }


  ####################################
  ####      Apache Service        ####
  ####################################
  $service_name = $service ? {
    undef   => $::operatingsystem ? {
      /Debian|Ubuntu/ => 'apache2',
      /CentOS|RedHat/ => 'httpd',
      /Archlinux/     => 'httpd',
      default         => 'httpd',
    },
    default => $service,
  }
  $service_path = $::operatingsystem ? {
    /Archlinux/     => '/etc/rc.d/',
    default         => '/etc/init.d/',
  }

  $service_hasrestart = $::operatingsystem ? {
    default         => true,
  }

  $service_hasstatus = $::operatingsystem ? {
    default         => true,
  }


  ####################################
  #### Apache Configuration Files ####
  ####################################
  ## Configuration directories. Based on defined $configroot ##
  $config_dir = $configroot ? {
    undef   => $::operatingsystem ? {
      /Debian|Ubuntu/ => '/etc/apache2',
      /CentOS|RedHat/ => '/etc/httpd',
      default         => '/etc/httpd',
    },
    default => $configroot,
  }

  ## Template to use.
  $config_template = $::operatingsystem ? {
    /Archlinux/     => 'apache/config/archlinux-apache.conf.erb',
    /CentOS|RedHat/ => $::operatingsystemrelease ? {
      /^6/    => 'apache/config/centos6-apache.conf.erb',
      /^5/    => 'apache/config/centos-apache.conf.erb',
      default => 'apache/config/centos-apache.conf.erb',
    },
    /Debian|Ubuntu/ => 'apache/config/debian-apache.conf.erb',
    default         => 'apache/config/debian-apache.conf.erb',
  }

  ## Location of the (main) configuration file.
  $config_file = $::operatingsystem ? {
    /Debian|Ubuntu/ => "${config_dir}/apache2.conf",
    /CentOS|RedHat/ => "${config_dir}/conf/httpd.conf",
    default         => "${config_dir}/conf/httpd.conf",
  }

  ## conf.d folder.
  $confd        = "${config_dir}/conf.d/"

  $log_dir = $logroot ? {
    undef   => $::operatingsystem ? {
      /Debian|Ubuntu/ => '/var/log/apache2',
      /CentOS|RedHat/ => '/var/log/httpd',
      /Archlinux/     => '/var/log/httpd',
      default         => '/var/log/httpd',
    },
    default => $logroot,
  }

  ####################################
  ####    Apache Daemon Config    ####
  ####################################
  $daemon_user = $user ? {
    undef   => $::operatingsystem ? {
      /Debian|Ubuntu/ => 'www-data',
      /CentOS|RedHat/ => 'apache',
      /Archlinux/     => 'http',
      default         => 'apache',
    },
    default => $user,
  }
  $daemon_group = $group ? {
    undef   => $::operatingsystem ? {
      /Debian|Ubuntu/ => 'www-data',
      /CentOS|RedHat/ => 'apache',
      /Archlinux/     => 'http',
      default         => 'apache',
    },
    default => $group,
  }

  ####################################
  ####     Vhost root folder      ####
  ####################################
  $vhost_root = $vhostroot ? {
    undef   => '/var/vhosts/',
    default => $vhostroot,
  }
  $vhost_log_dir = "${log_dir}/vhosts/"

}
