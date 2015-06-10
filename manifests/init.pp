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
class minissl(
  $system = true,
  $system_pki_dir = undef,
) {

  validate_bool($system)

  if $system_pki_dir {
    validate_absolute_path($system_pki_dir)
    $system_pki_dir_rel = $system_pki_dir
  }
  else {
    if $::osfamily == 'RedHat' {
      $system_pki_dir_rel = '/etc/pki/tls'
    }
    elsif $::osfamily == 'Debian' {
      $system_pki_dir_rel = '/etc/ssl'
    }
    else {
      fail("Please supply \$system_pki_dir - not autodetected for osfamily '${::osfamily}'!")
    }
  }

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

  if $system {
    file { "${system_pki_dir_rel}/certs/${::fqdn}_chain.crt":
      source => "puppet:///modules/minissl/ssl/certs/${::fqdn}.pem",
    }

    file { "${system_pki_dir_rel}/certs/${::fqdn}.crt":
      source => "puppet:///modules/minissl/ssl/certs/${::fqdn}.pem",
    }

    file { "${system_pki_dir_rel}/private/${::fqdn}.key":
      source => "puppet:///modules/minissl/ssl/private_keys/${::fqdn}.pem",
      mode   => '0640',
    }
  }
}
