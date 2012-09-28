# = Definition: apache::sys::modpackage
#
# Description of apache::sys::modpackage
#
# == Parameters:
#
# $param::   description of parameter. default value if any.
#
# == Actions:
#
# Describe what this class does. What gets configured and how.
#
# == Requires:
#
# Requirements. This could be packages that should be made available.
#
# == Sample Usage:
#
# == Todo:
#
# TODO: Update documentation
#
define apache::sys::modpackage (
  $package,
  $ensure        = 'installed',
  $provider      = undef,
  $package_alias = "apache_mod_${name}"
) {

  if $package != undef {
    package {$package:
      ensure   => $ensure,
      alias    => $package_alias,
      provider => $provider,
      require  => Package['apache'],
      notify   => Service['apache'],
    }

  }
  else {
    notify {"No package to install provided for ${name}":}
  }

}

