define bits_upload::property (
    $site_name,
    $path,

    $property,
    $value,
) {
    $script_common = "Import-Module WebAdministration;
    \$siteId = (Get-ItemProperty \"IIS:\\Sites\\${site_name}\" -Name id).Value;
    \$siteObj = New-Object System.DirectoryServices.DirectoryEntry(\"IIS://${::hostname}/W3SVC/\$siteId/root$path\");
    \$siteObj.RefreshCache()
    "

    if($property == "BITSUploadEnabled") {
        # This has to be special-cased, since the property is read-only.
        $script = "${script_common}
        if($value) {
            \$siteObj.EnableBitsUploads()
        } else {
            \$siteObj.DisableBitsUploads()
        }
        \$siteObj.CommitChanges()
        "
    } else {
        $script = "${script_common}
        \$siteObj.${property} = ${value}
        \$siteObj.CommitChanges()
        "
    }

    $condition = "${script_common}
    if(\$siteObj.${property}[0] -ne ${value}) { exit 0 } else { exit 1 }
    "

    exec { "Set-${title}":
        command  => $script,
        onlyif   => $condition,
        provider => powershell,
    }
}

