To include GIT configuration for all repositories in folder (signing commits, work email, etc.) use GIT conditional include feature.

Note: This is Windows specific.

## Steps

Open user config file: _C:\Users\USERNAME\.gitconfig_

Create config to include only in specific paths, for example: _C:/path_parent_folder/.gitconfig_include_

Include this config only in specific paths:
```
[includeIf "gitdir:C:/path_parent_folder/**"]
    path = C:/path_parent_folder/.gitconfig_include
```

Note: Path is case sensitive, including upper case for disk letter (_C:/_).

Test it with `git config -l` that should include new configuration in specified path and all nested paths.