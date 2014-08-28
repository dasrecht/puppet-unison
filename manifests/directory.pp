define unison::directory (
    $user = undef,
) {
    file { "unison_${title}":
        ensure  => directory,
        path    => $title,
        mode    => '0750',
        owner   => $user,
        group   => 'root',
    }
}
