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
    - _id: "kernel-core"
      location:
        git: https://github.com/teracyhq-incubator/teracy-dev-core.git
        branch: v0.4.0
      require_version: ">= 0.4.0"
```

- Use latest stable version (auto update):

```yaml
teracy-dev:
  extensions:
    - _id: "kernel-core"
      location:
        git: https://github.com/teracyhq-incubator/teracy-dev-core.git
        branch: master
      require_version: ">= 0.4.0"
```

- Use latest develop version (auto update):

```yaml
teracy-dev:
  extensions:
    - _id: "kernel-core"
      location:
        git: https://github.com/teracyhq-incubator/teracy-dev-core.git
        branch: develop
      require_version: ">= 0.5.0-SNAPSHOT"
```


## How to develop

You should configure the forked git repo into the `workspace` directory by adding the following
similar content into `workspace/teracy-dev-entry/config_override.yaml`:


```yaml
teracy-dev:
  extensions:
    - _id: "kernel-core"
      path:
        lookup: workspace
      location:
        git: git@github.com:hoatle/teracy-dev-core.git # your forked repo
        branch: develop
      require_version: ">= 0.5.0-SNAPSHOT"
```
