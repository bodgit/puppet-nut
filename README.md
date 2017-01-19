# nut

Tested with Travis CI

[![Build Status](https://travis-ci.org/bodgit/puppet-nut.svg?branch=master)](https://travis-ci.org/bodgit/puppet-nut)
[![Coverage Status](https://coveralls.io/repos/bodgit/puppet-nut/badge.svg?branch=master&service=github)](https://coveralls.io/github/bodgit/puppet-nut?branch=master)
[![Puppet Forge](http://img.shields.io/puppetforge/v/bodgit/nut.svg)](https://forge.puppetlabs.com/bodgit/nut)
[![Dependency Status](https://gemnasium.com/bodgit/puppet-nut.svg)](https://gemnasium.com/bodgit/puppet-nut)

#### Table of Contents

1. [Description](#description)
2. [Setup - The basics of getting started with nut](#setup)
    * [What nut affects](#what-nut-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with nut](#beginning-with-nut)
3. [Usage - Configuration options and additional functionality](#usage)
4. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

## Description

This module ensures that the Network UPS Tools (NUT) are installed and
configured.

RHEL/CentOS, Ubuntu, Debian and OpenBSD are supported using Puppet 4.4.0 or
later.

## Setup

### What nut affects

This module will potentially configure your host to respond to power failures.

### Setup Requirements

On RHEL/CentOS platforms you will need to have access to the EPEL repository by
using [stahnma/epel](https://forge.puppet.com/stahnma/epel) or by other means.

### Beginning with nut

In the very simplest case, you can just include the following:

```puppet
include ::nut
```

## Usage

The above example is not terribly useful as it does not include any UPS
devices, so it should be extended to something like the following:

```puppet
include ::nut
::nut::ups { 'sua1000i':
  driver => 'usbhid-ups',
  port   => 'auto',
}
::nut::user { 'local':
  password => 'password',
  upsmon   => 'master',
}
::nut::user { 'remote':
  password => 'password',
  upsmon   => 'slave',
}
::nut::client::ups { 'sua1000i@localhost':
  user     => 'local',
  password => 'password',
}
```

If the host does not have any UPS device directly attached, but is powered by
one which is controlled by another host such as the one above, use the
following:

```puppet
include ::nut:client
::nut::client::ups { 'sua1000i@remotehost':
  user     => 'remote',
  password => 'password',
}
```

## Reference

The reference documentation is generated with
[puppet-strings](https://github.com/puppetlabs/puppet-strings) and the latest
version of the documentation is hosted at
[https://bodgit.github.io/puppet-nut/](https://bodgit.github.io/puppet-nut/).

## Limitations

This module has been built on and tested against Puppet 4.4.0 and higher.

The module has been tested on:

* RedHat Enterprise Linux 6/7
* Ubuntu 14.04/16.04
* Debian 7/8
* OpenBSD 6.0

## Development

The module has both [rspec-puppet](http://rspec-puppet.com) and
[beaker-rspec](https://github.com/puppetlabs/beaker-rspec) tests. Run them
with:

```
$ bundle exec rake test
$ PUPPET_INSTALL_TYPE=agent PUPPET_INSTALL_VERSION=x.y.z bundle exec rake beaker:<nodeset>
```

Please log issues or pull requests at
[github](https://github.com/bodgit/puppet-nut).
