# = Definition: apache::vhost::mod::rewrite
#
# Setup mod_rewrite in a vhost
#
# == Parameters:
#
# $vhost::        The name of the vhost to work on. This should be
#                 identical to the apache::vhost{NAME:} you have setup.
#
# $rewrite_cond:: The rewrite condition
#
# $rewrite_rule:: The rewrite rule
#
define apache::vhost::mod::rewrite (
  $ensure        = 'present',
  $vhost,
  $ip            = undef,
  $port          = undef,
  $rewrite_cond,
  $rewrite_rule,
  $automated     = false,
) {

  $definition = template('apache/vhost/mod/rewrite.erb')

  apache::vhost::modfile {$title:
    ensure   => $ensure,
    vhost    => $vhost,
    ip       => $ip,
    port     => $port,
    content  => $definition,
    nodepend => $automated,
  }

}
