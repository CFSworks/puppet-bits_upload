define bits_upload (
    $site_name,
    $path = '',

    $ensure = 'enabled',

    $bits_session_directory        = undef,
    $bits_maximum_upload_size      = undef,
    $bits_session_timeout          = undef,
    $bits_server_notification_type = undef,
    $bits_server_notification_url  = undef,
    $bits_host_id                  = undef,
    $bits_host_id_fallback_timeout = undef,
    $bits_allow_overwrites         = undef,
    $bits_cleanup_use_default      = undef,
    $bits_cleanup_count            = undef,
    $bits_cleanup_units            = undef,
    $bits_number_of_sessions_limit = undef,
    $bits_session_limit_enable     = undef,
) {
    validate_re($ensure, '^(enabled|disabled)$')

    Bits_upload::Property {
        site_name  => $site_name,
        path       => $path,
    }

    bits_upload::property { "${title}_BITSUploadEnabled":
        property   => 'BITSUploadEnabled',
        value      => $ensure ? {
            enabled  => '$true',
            disabled => '$false',
        },
    }
    
    if($ensure == 'enabled') {
        if($bits_session_directory != undef) {
            bits_upload::property { "${title}_BITSSessionDirectory":
                property  => 'BITSSessionDirectory',
                value     => "\"$bits_session_directory\"",

                require   => Bits_upload::Property["${title}_BITSUploadEnabled"],
            }
        }

        if($bits_maximum_upload_size != undef) {
            if ! is_integer($bits_maximum_upload_size) {
                validate_re($bits_maximum_upload_size, '\d+')
            }

            bits_upload::property { "${title}_BITSMaximumUploadSize":
                property  => 'BITSMaximumUploadSize',
                value     => $bits_maximum_upload_size,

                require   => Bits_upload::Property["${title}_BITSUploadEnabled"],
            }
        }

        if($bits_session_timeout != undef) {
            if ! is_integer($bits_session_timeout) {
                validate_re($bits_session_timeout, '\d+')
            }

            bits_upload::property { "${title}_BITSSessionTimeout":
                property  => 'BITSSessionTimeout',
                value     => $bits_session_timeout,

                require   => Bits_upload::Property["${title}_BITSUploadEnabled"],
            }
        }

        if($bits_server_notification_type != undef) {
            validate_re($bits_server_notification_type, '^(none|url|file)$')

            bits_upload::property { "${title}_BITSServerNotificationType":
                property  => 'BITSServerNotificationType',
                value     => $bits_server_notification_type ? {
                    none => 0,
                    url  => 1,
                    file => 2,
                },

                require   => Bits_upload::Property["${title}_BITSUploadEnabled"],
            }
        }

        if($bits_server_notification_url != undef) {
            bits_upload::property { "${title}_BITSServerNotificationURL":
                property  => 'BITSServerNotificationURL',
                value     => "\"$bits_server_notification_url\"",

                require   => Bits_upload::Property["${title}_BITSUploadEnabled"],
            }
        }

        if($bits_host_id != undef) {
            bits_upload::property { "${title}_BITSHostId":
                property  => 'BITSHostId',
                value     => "\"$bits_host_id\"",

                require   => Bits_upload::Property["${title}_BITSUploadEnabled"],
            }
        }

        if($bits_host_id_fallback_timeout != undef) {
            if ! is_integer($bits_host_id_fallback_timeout) {
                validate_re($bits_host_id_fallback_timeout, '\d+')
            }

            bits_upload::property { "${title}_BITSHostIdFallbackTimeout":
                property  => 'BITSHostIdFallbackTimeout',
                value     => $bits_host_id_fallback_timeout,

                require   => Bits_upload::Property["${title}_BITSUploadEnabled"],
            }
        }

        if($bits_allow_overwrites != undef) {
            bits_upload::property { "${title}_BITSAllowOverwrites":
                property  => 'BITSAllowOverwrites',
                value     => $bits_allow_overwrites ? {
                    true  => '$true',
                    false => '$false',
                },

                require   => Bits_upload::Property["${title}_BITSUploadEnabled"],
            }
        }

        if($bits_cleanup_use_default != undef) {
            bits_upload::property { "${title}_BITSCleanupUseDefault":
                property  => 'BITSCleanupUseDefault',
                value     => $bits_cleanup_use_default ? {
                    true  => '$true',
                    false => '$false',
                },

                require   => Bits_upload::Property["${title}_BITSUploadEnabled"],
            }
        }

        if($bits_cleanup_count != undef) {
            if ! is_integer($bits_cleanup_count) {
                validate_re($bits_cleanup_count, '\d+')
            }

            bits_upload::property { "${title}_BITSCleanupCount":
                property  => 'BITSCleanupCount',
                value     => $bits_cleanup_count,

                require   => Bits_upload::Property["${title}_BITSUploadEnabled"],
            }
        }

        if($bits_cleanup_units != undef) {
            validate_re($bits_cleanup_units, '^(minutes|hours|days)$')

            bits_upload::property { "${title}_BITSCleanupUnits":
                property  => 'BITSCleanupUnits',
                value     => $bits_cleanup_units ? {
                    minutes => 0,
                    hours   => 1,
                    days    => 2,
                },

                require   => Bits_upload::Property["${title}_BITSUploadEnabled"],
            }
        }

        if($bits_number_of_sessions_limit != undef) {
            if ! is_integer($bits_number_of_sessions_limit) {
                validate_re($bits_number_of_sessions_limit, '\d+')
            }

            bits_upload::property { "${title}_BITSNumberOfSessionsLimit":
                property  => 'BITSNumberOfSessionsLimit',
                value     => $bits_number_of_sessions_limit,

                require   => Bits_upload::Property["${title}_BITSUploadEnabled"],
            }
        }

        if($bits_session_limit_enable != undef) {
            bits_upload::property { "${title}_BITSSessionLimitEnable":
                property  => 'BITSSessionLimitEnable',
                value     => $bits_session_limit_enable ? {
                    true  => '$true',
                    false => '$false',
                },

                require   => Bits_upload::Property["${title}_BITSUploadEnabled"],
            }
        }
    }
}
