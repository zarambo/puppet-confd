# == Class confd::config
#
# This class is called from confd
#
class confd::config inherits confd {

  # create configuration directory structure
  file { $confd::confdir:
    ensure => directory,
    owner  => 'root',
    mode   => '0750'
  } ->
  file { "${confd::confdir}/conf.d":
    ensure => directory,
    owner  => 'root',
    mode   => '0750'
  } ->
  file { "${confd::confdir}/templates":
    ensure => directory,
    owner  => 'root',
    mode   => '0750'
  } ->
#  file { "${confd::confdir}/templates":
#    ensure  => directory,
#    owner   => 'root',
#    mode    => '0640',
#    recurse => true,
#    source  => "puppet:///modules/${confd::sitemodule}/templates"
#  } ->
#  file { "${confd::confdir}/ssl":
#    ensure  => directory,
#    owner   => 'root',
#    mode    => '0640',
#    recurse => true,
#    source  => "puppet:///modules/${confd::sitemodule}/ssl"
#  }

  # main configuration file
  file { "${confd::confdir}/confd.toml":
    ensure  => present,
    owner   => 'root',
    mode    => '0644',
    content => template('confd/confd.toml.erb'),
    notify  => Service['confd'],
  }
}
