# == Class confd::install
#
class confd::install {
  include confd

  $binary_src = "puppet:///modules/${confd::sitemodule}/confd-${confd::version}"

  file { "${confd::installdir}/confd":
    ensure => present,
    links  => follow,
    owner  => 'root',
    mode   => '0750',
    source => $binary_src
  }

  if $confd::init_style {

    case $confd::init_style {
      'upstart' : {
        file { '/etc/init/confd.conf':
          mode    => '0444',
          owner   => 'root',
          group   => 'root',
          content => template('confd/confd.upstart.erb'),
        }
        file { '/etc/init.d/confd':
          ensure => link,
          target => '/lib/init/upstart-job',
          owner  => root,
          group  => root,
          mode   => '0755',
        }
      }
      'systemd' : {
        file { '/lib/systemd/system/confd.service':
          mode    => '0644',
          owner   => 'root',
          group   => 'root',
          content => template('confd/confd.systemd.erb'),
        }
      }
      'sysv' : {
        file { '/etc/init.d/confd':
          mode    => '0555',
          owner   => 'root',
          group   => 'root',
          content => template('confd/confd.sysv.erb')
        }
      }
      'debian' : {
        file { '/etc/init.d/confd':
          mode    => '0555',
          owner   => 'root',
          group   => 'root',
          content => template('confd/confd.debian.erb')
        }
      }
      'sles' : {
        file { '/etc/init.d/confd':
          mode    => '0555',
          owner   => 'root',
          group   => 'root',
          content => template('confd/confd.sles.erb')
        }
      }
      default : {
        fail("I don't know how to create an init script for style ${confd::init_style}")
      }
    }
  }
}
