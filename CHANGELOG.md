# Change Log


## [v0.4.0][] (2018-11-16)

- Features:
  + @ #1 | should give direct edit rights to variables #29
  + should add support for vmware provider #15
  + should add extension path variables dynamically #35
  + should create TeracyDevCore.register_provider(type, provider) to manage provider implementations #33
  + should add "weight" for provisioners to change the orders #43
  + should add support for docker provider #16
  + should add warning about unused variable keys #51

- Improvements:
  + should set weight for variables processor to be very low (1) #36

- Bug Fixes:
  + should ignore provider setting when enabled is not true #30
  + variables processor should support boolean value #38
  + don't modify settings object, related: https://github.com/teracyhq/dev/issues/462 #45
  + should delete "name" key from provisioner settings for options #49

- Tasks:
  + should use ubuntu bento/ubuntu-18.04 instead of bento/ubuntu-16.04 #18


Details: https://github.com/teracyhq-incubator/teracy-dev-core/milestone/4?closed=1


## [v0.3.0][] (2018-10-04)

- Bug Fixes:
  + VBoxManage not found on Windows and related problems on Windows

- Tasks:
  + update manifest to target teracy-dev ">= 0.6.0-a4, < 0.7.0"


Details: https://github.com/teracyhq-incubator/teracy-dev-core/milestone/3?closed=1


## [v0.2.0][] (2018-08-28)


- Improvements:
  + use "type" instead of "mode" for networks
  + add :id for networks so that we can use that :id for updating its config later

- Bug Fixes:
  + do not delete existing key (networks and synced_folders)


Details: https://github.com/teracyhq-incubator/teracy-dev-core/milestone/2?closed=1


## [v0.1.0][] (2018-08-25)


Initial release version which supports all vagrant settings and environment variables settings


Details: https://github.com/teracyhq-incubator/teracy-dev-core/milestone/1?closed=1


[v0.1.0]: https://github.com/teracyhq-incubator/teracy-dev-core/milestone/1?closed=1
[v0.2.0]: https://github.com/teracyhq-incubator/teracy-dev-core/milestone/2?closed=1
[v0.3.0]: https://github.com/teracyhq-incubator/teracy-dev-core/milestone/3?closed=1
[v0.4.0]: https://github.com/teracyhq-incubator/teracy-dev-core/milestone/4?closed=1
