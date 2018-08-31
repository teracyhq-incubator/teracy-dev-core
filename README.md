# teracy-dev-core

The core extension for teracy-dev which support all options from https://www.vagrantup.com/docs/
for teracy-dev yaml config format.


## How to use

By default, teracy-dev already configures to use this extension, however, you can override the
config with your own, for example, to use a different version or a forked repo.

To override the built-in config, create `workspace/teracy-dev-entry/config_default.yaml` with the
following similar content:

- Create `workspace/teracy-dev-entry`:

```bash
$ cd ~/teracy-dev # The name of the teracy-dev you retrieve
$ mkdir -p workspace/teracy-dev-entry
$ cd workspace/teracy-dev-entry
$ touch config_default.yaml
```

Open `config_default.yaml` and start configuring

- Use specific version:

```yaml
teracy-dev:
  extensions:
    - _id: "0"
      location:
        git: https://github.com/teracyhq-incubator/teracy-dev-core.git
        branch: v0.2.0
      require_version: ">= 0.2.0"
```

- Use latest stable version (auto update):

```yaml
teracy-dev:
  extensions:
    - _id: "0"
      location:
        git: https://github.com/teracyhq-incubator/teracy-dev-core.git
        branch: master
      require_version: ">= 0.2.0"
```

- Use latest develop version (auto update):

```yaml
teracy-dev:
  extensions:
    - _id: "0"
      location:
        git: https://github.com/teracyhq-incubator/teracy-dev-core.git
        branch: develop
      require_version: ">= 0.3.0-SNAPSHOT"
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
      require_version: ">= 0.3.0-SNAPSHOT"
```


## Configuration

- All configurations for `teracy-dev` are set in `workspace/teracy-dev-entry` . You can create, or you can see the sample in https://github.com/teracyhq-incubator/teracy-dev-entry-k8s/blob/develop/config_default.yaml .

- After have `workspace/teracy-dev-entry/config_default.yaml` , You can configure `teracy-dev-core` in this file.

- There are 3 components in `config_default.yaml` you can configure:

### Variables Settings

The variables must be defined to be used `teracy-dev` . And all variables settings define in `variables` block .

```yaml
variables:
  # some_value: ${MY_VAR:-value}
```

They have format:

- key: ${ENV_VAR}
- key: ${ENV_VAR-:default var}
* and "%{key}" can be used for settings values if available

By default, `teracy-dev` already configures

```yaml
variables:
  node_name_prefix: ${NODE_NAME_PREFIX:-node}
  node_hostname_prefix: ${NODE_HOSTNAME_PREFIX:-node}
  node_domain_affix: ${NODE_DOMAIN_AFFIX:-local}
```

You can add more if you need.

### Default Settings

The default settings for all nodes to use. And all default settings define in `default` block :

```yaml
default:
  # some_setting
```

In this `default` component, we have 4 configurations:

- Virtual machine setting:

```yaml
vm:
  box: bento/ubuntu-16.04 # The name of box, default bento/ubuntu-16.04 .
  box_version: 
  box_url:
  synced_folders: []
```

- Providers ( vagrant ):

```yaml
providers:
  - _id: "0" # Unique id
    enabled: true
    type: virtualbox # we use virtualbox
    require_version: ">= 5.2" 
    gui: false
    memory: 1024
    description: "%{node_name_prefix} #{Time.now.getutc.to_i}"
```

You can see more at https://www.vagrantup.com/docs/providers/ .

- Provisioning ( vagrant ):

```yaml
provisioners: []
```

By default we have 2 provisions : `host`, and `guest` . You can see more at https://www.vagrantup.com/docs/provisioning/ .

- Plugins ( vagrant ):

Default node config level.

```yaml
plugins: []
```

You can see more at https://www.vagrantup.com/docs/plugins/ .

* All default configurations:

```yaml
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

  plugins: []
```

### Nodes Settings

The Configure to install each node. And all nodes configure define in `nodes` block :

```yaml
nodes:
  # some_nodes_configurations
```

In this block, you can create as many nodes as you want and configure them.

By default we create 1 node as master node. And it format:

```yaml
nodes:
  - _id: "0" # Unique id
    name: "%{node_name_prefix}-01" # %{node_name_prefix} is defined in `variables` block.
    primary: true # true = master node.
    vm: # The vm settings for node use
      hostname: "%{node_hostname_prefix}-01.%{node_domain_affix}"
      # some_setting_you_need
```

You can create more if you need.

For example:

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

## License

```bash
Copyright (c) Teracy, Inc. and individual contributors.
All rights reserved.

Redistribution and use in source and binary forms, with or without modification,
are permitted provided that the following conditions are met:

    1. Redistributions of source code must retain the above copyright notice,
       this list of conditions and the following disclaimer.

    2. Redistributions in binary form must reproduce the above copyright
       notice, this list of conditions and the following disclaimer in the
       documentation and/or other materials provided with the distribution.

    3. Neither the name of Teracy, Inc. nor the names of its contributors may be used
       to endorse or promote products derived from this software without
       specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
```
