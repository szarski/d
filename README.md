## D (Developer Helper)

Simple script for defining cusom commands per repository.

## Usage

Add a config file `d.toml` in your repository. For instance:

```
[commands]
console="docker compose -f .devcontainer/docker-compose.yml exec -it my_app bash"
pss="docker compose -f .devcontainer/docker-compose.yml ps --format 'table {{.Service}}\t{{.Status}}'"

[default]
command="docker compose -f .devcontainer/docker-compose.yml"
```

will define commands like:

`d` prints help:
```
Usage:
  d <command> [args...]
For default command if defined:
  d [args...]

Available commands:
  console         -> docker compose -f .devcontainer/docker-compose.yml exec -it my_app bash
  pss             -> docker compose -f .devcontainer/docker-compose.yml ps --format 'table {{.Service}}\t{{.Status}}'
  (default)       -> docker compose -f .devcontainer/docker-compose.yml
```

Defined commands:
`d console` becomes:
```
docker compose -f .devcontainer/docker-compose.yml exec -it my_app bash
```

`d pss` becomes:
```
docker compose -f .devcontainer/docker-compose.yml ps --format 'table {{.Service}}\t{{.Status}}'
```

Any other command gets a prefix, so for instance `d up -d application` becomes:
```
docker compose -f .devcontainer/docker-compose.yml up -d application
```

You can either commit `d.toml` files to the repositories, or set a global ignore if you don't want to share them:
```
echo "d.toml" >> ~/.gitignore-global
git config --global core.excludesFile '~/.gitignore-global'
```

## Installation

1. Copy `source.sh` to `~/.local/bin/d`

2. To your `.bashrc` or `.zshrc` or `.profile` add:
```
export PATH="$PATH:/Users/jacek.szarski/.local/bin"
```

### Other

See [license](LICENSE.md).
