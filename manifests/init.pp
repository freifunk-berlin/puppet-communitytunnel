class communitytunnel(
  $address,
  $interface
) {

  # Install Tunneldigger
  $install_dir = '/opt/tunneldigger'
  $max_tunnels = '3991'

  class {'tunneldigger':
    install_dir         => $install_dir,
    virtualenv          => "${install_dir}/env",
    revision            => 'f68b7af4b3874601818c7e677e21461278df13f5',
    address             => $address,
    port                => '8942',
    interface           => $interface,
    max_tunnels         => $max_tunnels,
    bridge_address      => '172.31.224.1/20',
    templates_dir       => 'communitytunnel',
    session_up          => 'setup_interface.sh',
    session_mtu_changed => 'mtu_changed.sh',
    systemd             => '1',
  }

  package { [
    'dnsmasq'
  ]:
    ensure => present,
  }


  # Configure and enable dnsmasq
  $dhcp_range = '172.31.224.100,172.31.239.254,255.255.240.0,1h'
  $dhcp_lease_max = $max_tunnels
  
  file { '/etc/dnsmasq.conf':
    ensure     => file,
    content    => template('communitytunnel/dnsmasq.conf.erb'),
    notify     => Service['dnsmasq'],
  }

  service { 'dnsmasq':
    ensure     => 'running',
    enable     => 'true',
  }
}
