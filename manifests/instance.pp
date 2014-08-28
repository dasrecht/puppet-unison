# Individual union instance.  One needed on each side of the replication.
# Private key stored in files/, pub key stored in config
define unison::instance (
    $user           = undef,
    $home_dir       = undef,
    $priv_key       = undef,
    $pub_key        = undef,
    $pub_type       = 'ssh-rsa',
    $root1          = undef,
    $root2          = undef,
    $sshargs        = undef,
    $ignore         = undef,
    $cron           = false,
    $cron_minute    = undef,
    $cron_hour      = undef,
    $cron_month     = undef,
    $cron_monthday  = undef,
    $cron_weekday   = undef,
) {
    # Include parent class to inherit packages
    include unison

    # Make sure we only define the directory once
    unless defined( Unison::Directory["${home_dir}/.unison"]  ) {
        unison::directory { "${home_dir}/.unison":
            user    => $user
        }
    }

    # Private ssh key (stored in files/)
    file { "unison_${title}_sshpriv":
        ensure   => file,
        path     => "${home_dir}/.unison/id_rsa_${title}",
        mode     => '0600',
        owner    => $user,
        require => File["unison_${home_dir}/.unison"],
        source   => "puppet:///modules/unison/id_rsa_${title}",
    }

    # Actual unison profile
    file { "${home_dir}/.unison/${title}.prf":
        ensure  => file,
        path    => "${home_dir}/.unison/${title}.prf",
        mode    => '0644',
        owner   => $user,
        require => File["unison_${home_dir}/.unison"],
        content => template('unison/profile.erb'),
    }

    # public key for Unison instance
    ssh_authorized_key { "unison_ssh_pub_${title}":
        ensure => present,
        user   => $user,
        name   => "${user}@unison - ${title}",
        key    => $pub_key,
        type   => $pub_type,
    }

    # Cron job if necessary
    if $cron == true {
        cron { "unison_${title}":
            ensure      => present,
            user        => $user,
            command     => "/usr/bin/unison -batch ${title}",
            minute      => $cron_minute,
            hour        => $cron_hour,
            month       => $cron_month,
            monthday    => $cron_monthday,
            weekday     => $cron_weekday,
        }
    }
}
