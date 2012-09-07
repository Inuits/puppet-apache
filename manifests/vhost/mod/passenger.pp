# = Definition: apache::vhost::mod::passenger
#
# Enable a passenger configuration in this vhost.
#
# == Required Parameters:
#
# Your definition should always take the following parameters. When
# using the mods parameter from vhost, these get set automaticly.
#
# $ensure::     Disable or enable this mod. This will/should remove the config
#               file. Required for apache::vhost::modfile.
#
# $vhost::      Defined what vhost this module is for.
#               Required for apache::vhost::modfile
#
# $ip::         Required for apache::vhost::modfile.
#
# $port::       Required for apache::vhost::modfile.
#
# $docroot::    Document root.
#               Is automaticly filled in if pushed through apache::vhost.
#
# == Optional Parameters:
#
#
# == Actions:
#
# Creates a apache::vhost::modfile for the vhost that has been selected.
#
# == Sample Usage:
#
# == Todo:
#
#  * Implement remaining parameters
#
define apache::vhost::mod::passenger (
  $vhost,
  $ensure               = 'present',
  $ip                   = undef,
  $port                 = '80',
  $docroot              = undef,
  $order                = undef,
  $_automated           = false,
  $_header              = false,

  $content              = undef,

  $app_root             = undef,
  $spawn_method         = undef,
  $global_queue         = undef,
  $passenger_enabled    = undef,
  $upload_buffer_dir    = undef,
  $restart_dir          = undef,
  $friendly_error_pages = undef,
  $buffer_response      = undef,
  $user                 = undef,
  $group                = undef,
  $min_instances        = undef,
  $max_requests         = undef,
  $stat_throttle_rate   = undef,
  $pre_start            = undef,
  $high_performance     = undef,
  $rails_autodetect     = undef,
  $rack_autodetect      = undef
) {

  require apache::mod::passenger

  ## Generate the content for your module file:
  $definition = template('apache/vhost/mod/passenger.erb')

  apache::vhost::modfile {$title:
    ensure   => $ensure,
    vhost    => $vhost,
    ip       => $ip,
    port     => $port,
    nodepend => $_automated,
    content  => $definition,
    order    => $order,
  }
}

