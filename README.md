## D (Developer Helper)

Simple script for defining cusom commands per repository.
Do you work on multiple repositories, each with a slightly different docker configuration?
Simplify your work by having one pattern for invoking typical actions:
```
my_app % d
Usage:
  d <command> [args...]
For default command if defined:
  d [args...]

Available commands:
  console         -> docker compose -f .devcontainer/docker-compose.yml exec -it my_app bash
  build           -> docker build --secret id=hex_auth_token,src=/Users/jacek/.secrets/hex_key.txt --secret id=node_auth_token,env=GITHUB_TOKEN -t test-image .
  pss             -> docker compose -f .devcontainer/docker-compose.yml ps --format 'table {{.Service}}\t{{.Status}}'
  test            -> mix test
  (default)       -> docker compose -f .devcontainer/docker-compose.yml

my_app % d up -d
[+] Running 1/1
 ✔ Container devcontainer-my_app-1  Started  0.2s

my_app % d pss
SERVICE   STATUS
my_app    Up 11 seconds
```

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
