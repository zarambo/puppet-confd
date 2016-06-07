# == Class confd::params
#
# This class is meant to be called from confd
# It sets variables according to platform
#
class confd::params {
  $confdir    = '/etc/confd'
  $version    = 'latest'
  $user       = 'root'
  $group      = 'root'
  $sitemodule = 'confd'
  $nodes      = ['127.0.0.1:4001']

  case $::osfamily {
    'Debian': {
      $installdir   = '/usr/local/bin'
    }
    'RedHat', 'Amazon': {
      $installdir   = '/usr/bin'
    }
    default: {
      fail("${::operatingsystem} not supported")
    }
  }

  $init_style = $::operatingsystem ? {
    'Ubuntu'             => $::lsbdistrelease ? {
      '8.04'           => 'debian',
      /(10|12|14)\.04/ => 'upstart',
      default => undef
    },
    /CentOS|RedHat/      => $::operatingsystemmajrelease ? {
      /(4|5|6)/ => 'sysv',
      default   => 'systemd',
    },
    'Fedora'             => $::operatingsystemmajrelease ? {
      /(12|13|14)/ => 'sysv',
      default      => 'systemd',
    },
    'Debian' => versioncmp($::operatingsystemrelease, '8') ? {
      '-1'    => 'debian',
      default => 'systemd',
    },
    default => undef
  }
}
