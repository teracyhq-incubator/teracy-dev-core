# teracy-dev-core

The core extension for [teracy-dev](https://github.com/teracyhq/dev/tree/develop) which supports all options from [vagrant](https://www.vagrantup.com/docs/)
for teracy-dev yaml configuration format.

## How to use

Prerequisites:

  + Follow the guide at https://github.com/teracyhq/dev/blob/develop/docs/getting_started.rst to set up `teracy-dev`.

  + Require `teracy-dev` version from https://github.com/teracyhq-incubator/teracy-dev-core/blob/develop/manifest.yaml

By default, teracy-dev is already configured to use this extension, however you can override the configuration with your own, for example, to use a different version or a forked repo.

To override the built-in version, create `workspace/teracy-dev-entry/config_default.yaml` with the
following similar content:

- Use specific version:

```yaml
teracy-dev:
  extensions:
    - _id: "kernel-core"
      path:
        extension: teracy-dev-core
      location:
        git:
          remote:
            origin: https://github.com/teracyhq-incubator/teracy-dev-core.git
          branch: v0.3.0
      require_version: ">= 0.3.0"
```

- Use the latest stable version (auto update):

```yaml
teracy-dev:
  extensions:
    - _id: "kernel-core"
      path:
        extension: teracy-dev-core
      location:
        git:
          remote:
            origin: https://github.com/teracyhq-incubator/teracy-dev-core.git
          branch: master
      require_version: ">= 0.4.0"
```

- Use the latest develop version (auto update):

```yaml
teracy-dev:
  extensions:
    - _id: "kernel-core"
      path:
        extension: teracy-dev-core
      location:
        git:
          remote:
            origin: https://github.com/teracyhq-incubator/teracy-dev-core.git
          branch: develop
      require_version: ">= 0.5.0-SNAPSHOT"
```

- Run `vagrant up` or `vagrant reload --provision` (if your vagrant machine is running) to apply your configuration.

## How to develop

You should configure the forked git repo into the `workspace` directory by adding the following similar content into `workspace/teracy-dev-entry/config_override.yaml`:


```yaml
teracy-dev:
  extensions:
    - _id: "kernel-core"
      path:
        lookup: workspace
      location:
        git:
          remote:
            origin: <fill your forked repo here>
            upstream: https://github.com/teracyhq-incubator/teracy-dev-core.git
        branch: develop
      require_version: ">= 0.5.0-SNAPSHOT"
```

- Run `vagrant up` or `vagrant reload --provision` (if your vagrant machine is running) to apply your configuration.

## Supported configurations
These are the supported configurations in teracy-dev-core, you can configure them in the `workspace/teracy-dev-entry/config_override.yaml`:

- Variables

  * `variables` are used to define dynamic configuration values for use in configuration files. After setting them, you can call them by `%{env_key}`.

  * You can define variable keys with environment variables. The following is the configuration format:

  ```yaml
    variables:
      key: ${ENV_VAR}
      key: ${ENV_VAR-:default}
      key: value
    # and "%{key}" can be used for settings values if available
  ```

  * [Example for variables](docs/examples/variables.yaml)

- Plugins

  * These are plugin configurations for configuring vagrant plugins. See more at: https://www.vagrantup.com/docs/plugins/.

  * The following is the configuration format:

  ```yaml
  vagrant:
    plugins:
      - _id: # unique plugin id
      name: # plugin name. you can see list plugin here: https://github.com/hashicorp/vagrant/wiki/Available-Vagrant-Plugins
      version: "" # default use latest version if empty
      enabled: true
      env_local: # true / false. default is false to use global plugin.
      state: "" # if not set, do nothing. Another state: installed, uninstalled
  ```

  * [Example for plugins](docs/examples/plugins.yaml)

- Nodes

  * These are configurations for each node.

  * The following is the configuration format:

  ```yaml
  nodes:
    - _id: # unique node id. All configuration of this node must have same '_id'
    name: # machine name
    vm: # box configure
    providers:
    ssh:
    provisioners:

    # another node
    - _id: # unique node id
    name: # machine name
    vm: # box configure
    providers:
    ssh:
    provisioners:
  ```

  * Examples:
    - [vm](docs/examples/vm.yaml)
    - [Providers](docs/examples/providers.yaml)
    - [ssh](docs/examples/ssh.yaml)
    - Provisioner:
      + [File provisioner](docs/examples/provisioner-example/file.yaml)
      + [Shell provisioner](docs/examples/provisioner-example/shell.yaml)
      + [Ansible provisioner](docs/examples/provisioner-example/ansible.yaml)
      + [Chef provisioner](docs/examples/provisioner-example/chef-solo.yaml)
    - [Multiple nodes](docs/examples/multi-nodes.yaml)
