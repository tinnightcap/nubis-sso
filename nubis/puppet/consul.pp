# Enable consul-template, base doesn't enable it yet
class { 'consul_template':
    service_enable => true,
    service_ensure => 'stopped',
    version        => '0.16.0',
    user           => 'root',
    group          => 'root',
}

# Drop our template
file { "${consul_template::config_dir}/top.shtml.ctmpl":
  ensure  => file,
  owner   => root,
  group   => root,
  mode    => '0644',
  source  => 'puppet:///nubis/files/html/top.shtml.ctmpl',
  require => [
    Class['consul_template'],
  ],
}

# Configure our watch
consul_template::watch { 'top.html':
    source        => "${consul_template::config_dir}/top.html.ctmpl",
    destination   => '/var/www/html/top.html',
    command       => 'true',
    require       => [
      File["${consul_template::config_dir}/top.shtml.ctmpl"],
    ]
}
