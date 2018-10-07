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
These are the supported configuration in teracy-dev-core: `variables`, `vagrant`, `default`, `node`.
You can see the details about the default configuration in the `config.yaml` file.


### Examples

This section gives you some examples about the supported configuration in teracy-dev-core, so you should know how
to override the default configuration.

You should add your new configuration into the `workspace/teracy-dev-entry/config_override.yaml`.

*vagrant*

Please see an example at `workspace/teracy-dev-essential/blob/develop/config.yaml`.

*default*

This `default` configuration is set for all nodes to use. It consits of 4 configuration: `vm`, `providers`, `provisioners`,
and `plugins`.
 
- `providers`: see more at https://www.vagrantup.com/docs/providers/.
- `provisioners`: by default, we have 2 provisions : `host`, and `guest`. You can see more at https://www.vagrantup.com/docs/provisioning/.
- `plugins`: see more at https://www.vagrantup.com/docs/plugins/.


*node*

```yaml
	nodes:
	  - _id: "0" # This node is defined by default.
	    vm:
	      networks:
	        - _id: "0"
	          type: public_network
	   - _id: "1"
	    name: "%{node_name_prefix}-02"
	    vm:
	      hostname: "%{node_hostname_prefix}-02.%{node_domain_affix}"
	      networks:
	        - _id: "0"
	          type: public_network
	          ip: 192.168.1.111
	   - _id: "2"
	    name: "%{node_name_prefix}-03"
	    vm:
	      hostname: "%{node_hostname_prefix}-03.%{node_domain_affix}"
	      networks:
	        - _id: "0"
	          type: private_network
```


