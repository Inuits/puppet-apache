class apache::mod::php {

  $pkg_name =  $::operatingsystem ? {
    /Debian|Ubuntu/ => 'libapache2-mod-php',
    /CentOS|RedHat/ => '',
    default         => [],
  }


  package { $pkg_name:
    ensure  => installed,
    alias   => 'apache_mod_php',
    require => Package['apache'],
    notify  => Service['apache'],
  }
}
