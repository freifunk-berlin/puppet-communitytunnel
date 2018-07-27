class communitytunnel(
  $address,
  $interface
) {

  $install_dir = '/opt/tunneldigger'

  class {'tunneldigger':
    install_dir         => $install_dir,
    virtualenv          => "${install_dir}/env",
    revision            => 'f68b7af4b3874601818c7e677e21461278df13f5',
    address             => $address,
    port                => '8942',
    interface           => $interface,
    max_tunnels         => '4091',
    bridge_address      => '172.31.224.1/20',
    templates_dir       => 'communitytunnel',
    session_up          => 'setup_interface.sh',
    session_mtu_changed => 'mtu_changed.sh',
    upstart             => '1',
  }
}
