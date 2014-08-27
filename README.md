### Example Usage
    unison::instance { 'thing':
        user        => 'apache',
        root1       => '/var/www/thing',
        root2       => 'ssh://192.168.0.//var/www/thing',
        home_dir    => '/var/www',
        sshargs     => '-p2022',
        pub_key     => '*** ssh pub key ***',
        cron        => true,
        cron_minute => '0',
        ignore      => [
            'Name local_config',
        ]
    }

