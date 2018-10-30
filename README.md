# teracy-dev-core

The core extension for teracy-dev which support all options from https://www.vagrantup.com/docs/
for teracy-dev yaml config format.


## How to use

By default, teracy-dev already configures to use this extension, however, you can override the
config with your own, for example, to use a different version or a forked repo.

To override the built-in config, create `workspace/teracy-dev-entry/config_default.yaml` with the
following similar content:


- Use specific version:

```yaml
teracy-dev:
  extensions:
    - _id: "0"
      location:
        git: https://github.com/teracyhq-incubator/teracy-dev-core.git
        branch: v0.3.0
      require_version: ">= 0.3.0"
```

- Use latest stable version (auto update):

```yaml
teracy-dev:
  extensions:
    - _id: "0"
      location:
        git: https://github.com/teracyhq-incubator/teracy-dev-core.git
        branch: master
      require_version: ">= 0.3.0"
```

- Use latest develop version (auto update):

```yaml
teracy-dev:
  extensions:
    - _id: "0"
      location:
        git: https://github.com/teracyhq-incubator/teracy-dev-core.git
        branch: develop
      require_version: ">= 0.4.0-SNAPSHOT"
```


## How to develop

You should configure the forked git repo into the `workspace` directory by adding the following
similar content into `workspace/teracy-dev-entry/config_override.yaml`:


```yaml
teracy-dev:
  extensions:
    - _id: "0"
      path:
        lookup: workspace
      location:
        git: git@github.com:hoatle/teracy-dev-core.git # your forked repo
        branch: develop
      require_version: ">= 0.4.0-SNAPSHOT"
```

## Supported configuration
These are the supported configuration in teracy-dev-core: `variables`, `default`, `node`.


### variables
`variables` is used to define dynamic configuration values. You can define variable keys with environment variables.

 The following is the  default configuration:

```yaml
# vars must be defined to be used
# format:
# key: ${ENV_VAR}
# key: ${ENV_VAR-:default}
# key: value
# and "%{key}" can be used for settings values if available
variables:
  node_name_prefix: ${NODE_NAME_PREFIX:-node}
  node_hostname_prefix: ${NODE_HOSTNAME_PREFIX:-node}
  node_domain_affix: ${NODE_DOMAIN_AFFIX:-local}
  # some_value: ${MY_VAR:-value}-affix
```
In which:

- `node_name_prefix` param: its value will be the value of the env var `NODE_NAME_PREFIX` which is defined, otherwise, the value should be the default `node`.
- `node_hostname_prefix` param: its value is `NODE_HOSTNAME_PREFIX`. If `NODE_HOSTNAME_PREFIX` is not defined, the value should be the default `node`.
- `node_domain_affix` param: its value is `NODE_DOMAIN_AFFIX`. If `NODE_DOMAIN_AFFIX` is not defined, the value should be the default `local`.


### default

The `default` settings which will be overridden by each nodes, so any config which is shared among nodes, we should use `default`. It consits of 4 configuration: `vm`, `providers`, `provisioners`, and `plugins`.

- `vm`: Virtual machine setting 
- `providers`: see more at https://www.vagrantup.com/docs/providers/.
- `provisioners`: see more at
https://www.vagrantup.com/docs/provisioning/.
- `plugins`: see more at https://www.vagrantup.com/docs/plugins/.

The following is the default configuration of teracy-dev-core:

```yaml
# default settings for all nodes
default:
  vm:
    box: bento/ubuntu-16.04
    box_version:
    box_url:
    synced_folders: []

  providers:
    - _id: "0"
      enabled: true
      type: virtualbox
      require_version: ">= 5.2"
      gui: false
      memory: 1024
      description: "%{node_name_prefix} #{Time.now.getutc.to_i}"

  provisioners: []

  # default node config level
  plugins: []
```

### nodes
The `node` configure which is used to define the configuration for each VMs and should be defined in the `nodes` block.
In this block, you can create as many nodes as you want and configure them.

By defaut, we create 1 node as the `master` node:

```yaml
# specific nodes, each node will override the default
nodes:
  - _id: "0"
    name: "%{node_name_prefix}-01"
    primary: true
    vm:
      hostname: "%{node_hostname_prefix}-01.%{node_domain_affix}"
```

### Examples

This section gives you some examples about the supported configuration in teracy-dev-core, so you should know how
to override the default configuration.

Please see an example at `examples/config_example.yaml`.

