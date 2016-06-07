
class confd::service (

) {

  service { 'confd':
    ensure  => 'running',
  }
}