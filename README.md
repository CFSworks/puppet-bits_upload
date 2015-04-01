# bits_upload

#### Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with bits_upload](#setup)
    * [Beginning with bits_upload](#beginning-with-bits_upload)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
6. [Limitations - OS compatibility, etc.](#limitations)
7. [Development - Guide for contributing to the module](#development)

## Overview

Manage BITS upload permissions for paths in Microsoft IIS.

## Module Description

Use this module on Windows platforms in order to configure the IIS server to
accept uploads coming from the Background Intelligent Transfer Service (BITS).

You are expected to create your IIS site and path through other means. I am
using this module alongside the [OpenTable IIS](https://forge.puppetlabs.com/opentable/iis)
Puppet module, so you'll probably have the best luck with the same.

## Setup

### Beginning with bits_upload

The very basic steps needed for a user to get the module up and running.

If your most recent release breaks compatibility or requires particular steps
for upgrading, you may wish to include an additional section here: Upgrading
(For an example, see http://forge.puppetlabs.com/puppetlabs/firewall).

## Usage

Everything is managed through `the bits_upload` defined type. You can use this
to specify the BITS upload settings for a given path on your site. As an
example:

```
bits_upload { 'foo':
    site_name => 'www.mysite.com',
    path      =>

    ensure    => enabled,
}
```

## Reference

Everything is managed through the bits_upload defined type. Most of its
parameters correspond to a setting in the IIS extension. You should review
[the MSDN documentation here](https://msdn.microsoft.com/en-us/library/aa362818(v=vs.85).aspx).

The parameters are as follows:


**site_name**: The name of your IIS site.

**path**: The relative path where BITS uploads can be submitted.

**ensure**: Either 'enabled' or 'disabled', depending on whether you want to
offer BITS uploads from this directory or not. Defaults to 'enabled' if
omitted.

**bits_session_directory**: Corresponds to Microsoft's BITSSessionDirectory
property. This controls the name of the directory used by the BITS server in
order to store in-progress upload sessions.

**bits_maximum_upload_size**: The maximum size, in bytes, that this IIS server
will accept for a single job.

**bits_session_timeout**: The number of seconds a session is maintained while
no progress is made uploading a file. If the client working on the file has not
been heard from in this many seconds, the file will be cleaned up and the
client will have to start over. If omitted, the module will leave the IIS
server to its default, which is 14 days.

**bits_server_notification_type**: Either "none", "url", or "file" - this
controls how the BITS server will notify the notification URL.

**bits_server_notification_url**: The URL to submit completed uploads to.

**bits_host_id**: This property should be set if this server is part of a
shared farm (i.e. behind some sort of load balancer) and it doesn't use shared
storage with the other servers. This is told to the client when a new transfer
begins so that the client can reconnect to the server that already has the
progress on it. Set this to the server's IP or hostname. Note that you should
not use this in SSL environments.

**bits_host_id_fallback_timeout**: The number of seconds that the client will
try to reconnect to the bits_host_id server before giving up its progress and
running back to the primary URL (which is, if you're using bits_host_id, a load
balancer).

**bits_allow_overwrites**: Either 'true' or 'false' depending on whether
clients should be allowed to overwrite already-uploaded files.

**bits_cleanup_use_default**: Use the default cleanup schedule of "run once
every 12 hours"? If this is set to 'false', it will use the custom schedule
specified by the following two parameters:

**bits_cleanup_count**: How often to check for timed-out upload sessions.

**bits_cleanup_units**: Either 'days', 'hours', 'minutes' -- the units for the
above parameter.

**bits_number_of_sessions_limit**: Limits the number of upload sessions that
can exist concurrently for a user. If the number of sessions for a user is more
than this limit, when the cleanup task runs it will delete the most recent
sessions until the number of sessions for the user is below the limit.

**bits_session_limit_enable**: Set to 'true' to enable the above limit.

## Limitations

Being a module for managing a Microsoft service, this module only supports
Microsoft Windows. This has only been tested on Windows Server 2012R2, which
has IIS 8.5.

## Development

Pull requests welcome over at GitHub. :)
