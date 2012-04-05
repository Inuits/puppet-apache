# == Class: apache::vhost::ssl
#
# Description of apache::vhost::ssl
#
# === Parameters:
#
# Most parameters are inherited from apache::vhost and will not be
# documented here.
#
# $ssl_cert::
#
# $ssl_key::
#
# $ssl_ciphersuite::
#
# $ssl_chain::
#
# $ssl_ca_path::
#
# $ssl_ca_file::
#
# $ssl_ca_crl_path::
#
# $ssl_ca_crl_file::
#
# $ssl_requestlog::   Logs non-error ssl requests to this file.
#                     This log includes the ssl protocol and cipher used.
#                     Filename is relative to the log_dir (apache::vhost).
#                     Defaults to '' (empty) which is disabled.
#
# $ssl_options::
#
# $ssl_verify_client::
#
# $ssl_verify_depth::
#
# === Actions:
#
# === Requires:
#
# === Sample Usage:
#
define apache::vhost::ssl (
  $ssl_cert,
  $ssl_key,
  $ssl_protocol      = 'all -SSLv2',
  $ssl_ciphersuite   = 'ALL:!ADH:!EXPORT:!SSLv2:RC4+RSA:+HIGH:+MEDIUM:+LOW',
  $ssl_chain         = undef,
  $ssl_ca_path       = undef,
  $ssl_ca_file       = undef,
  $ssl_ca_crl_path   = undef,
  $ssl_ca_crl_file   = undef,
  $ssl_requestlog    = undef,
  $ssl_options       = undef,
  $ssl_verify_client = undef,
  $ssl_verify_depth  = undef,
  $servername        = undef,
  $serveraliases     = '',
  $ensure            = 'present',
  $ip                = undef,
  $port              = '443',
  $admin             = undef,
  $vhostroot         = undef,
  $logdir            = undef,
  $accesslog         = 'access.log',
  $errorlog          = 'error.log',
  $errorlevel        = 'warn',
  $docroot           = undef,
  $docroot_purge     = false,
  $dirroot           = undef,
  $order             = '10',
  $vhost_config      = '',
  $mods              = undef,
  $owner             = undef,
  $group             = undef
) {

  ## Same logic as apache::vhost but we redo this since we need $server
  $server = $servername ? {
    undef   => $name,
    default => $servername,
  }

  $chainfile = $ssl_chain ? {
    undef   => '',
    default => $ssl_chain,
  }
  $ca_path = $ssl_ca_path ? {
    undef   => '',
    default => $ssl_ca_path,
  }
  $ca_file = $ssl_ca_file ? {
    undef   => '',
    default => $ssl_ca_file,
  }
  $ca_crl_path = $ssl_ca_crl_path ? {
    undef   => '',
    default => $ssl_ca_crl_path,
  }
  $ca_crl_file = $ssl_ca_crl_file ? {
    undef   => '',
    default => $ssl_ca_crl_file,
  }
  $requestlog = $ssl_requestlog ? {
    undef   => '',
    default => $ssl_requestlog,
  }
  $options = $ssl_options ? {
    undef   => '',
    default => $ssl_options,
  }
  $verify_client = $ssl_verify_client ? {
    undef   => '',
    default => $ssl_verify_client,
  }
  $verify_depth = $ssl_verify_depth ? {
    undef   => '',
    default => $ssl_verify_depth
  }

  $log_dir = $logdir ? {
    undef   => "${apache::params::vhost_log_dir}/${server}",
    default => $logdir,
  }

  $ssl_content = template('apache/vhost/virtualhost_ssl.erb')

  apache::vhost{$title:
    ensure        => $ensure,
    name          => $name,
    servername    => $servername,
    serveraliases => $serveraliases,
    docroot       => $docroot,
    vhostroot     => $vhostroot,
    ip            => $ip,
    port          => $port,
    admin         => $admin,
    logdir        => $logdir,
    accesslog     => $accesslog,
    errorlog      => $errorlog,
    errorlevel    => $errorlevel,
    docroot_purge => $docroot_purge,
    dirroot       => $dirroot,
    order         => $order,
    mods          => $mods,
    owner         => $owner,
    group         => $group,
    vhost_config  => $ssl_content, # This is the only thing that is different.
  }
}

