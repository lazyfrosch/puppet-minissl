# == Class: minissl
#
# Setup limit SSL certs into a Vagrant box.
#
# These certs are VERY INSECURE, because they are available online!
#
# Only use this in Vagrant boxes, where they are hidden.
#
# === Author
#
# Markus Frosch <markus@lazyfrosch.de>
#
class minissl {

  File {
    ensure => file,
    owner  => 'puppet',
    group  => 'puppet',
    mode   => '0644',
  }

  # setup ssl on the client
  file { "${settings::vardir}/ssl/certs/ca.pem":
    source => 'puppet:///modules/minissl/ssl/certs/ca.pem',
  }

  file { "${settings::vardir}/ssl/certs/${::fqdn}.pem":
    source => "puppet:///modules/minissl/ssl/certs/${::fqdn}.pem",
  }

  file { "${settings::vardir}/ssl/public_keys/${::fqdn}.pem":
    source => "puppet:///modules/minissl/ssl/public_keys/${::fqdn}.pem",
  }

  file { "${settings::vardir}/ssl/private_keys/${::fqdn}.pem":
    source => "puppet:///modules/minissl/ssl/private_keys/${::fqdn}.pem",
    mode   => '0640',
  }

  file { "${settings::vardir}/ssl/crl.pem":
    source => 'puppet:///modules/minissl/ssl/ca/ca_crl.pem',
    mode   => '0644',
  }

}
