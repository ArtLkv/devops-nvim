# NeoVim configuration for DevOps

## Pre-requirements

* (Optional) Lua LTS
```sh
sudo apt install ninja-build
mkdir devops
cd devops
git clone https://github.com/LuaLS/lua-language-server
cd lua-language-server
./make.sh
echo 'export PATH="$PATH:/home/$USER/devops/lua-language-server/bin"' > ~/.profile

```

* Python language
```sh
# Install PyEnv
git clone https://github.com/pyenv/pyenv.git ~/.pyenv
cd ~/.pyenv && src/configure && make -C src
set -Ux PYENV_ROOT $HOME/.pyenv
fish_add_path $PYENV_ROOT/bin
nvim ~/.config/fish/config.fish # And add this `pyenv init - | source`

# Install dependencies
sudo apt update; sudo apt install build-essential libssl-dev zlib1g-dev \
libbz2-dev libreadline-dev libsqlite3-dev curl \
libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev

pacman -S --needed base-devel openssl zlib xz tk

dnf install make gcc patch zlib-devel bzip2 bzip2-devel readline-devel sqlite sqlite-devel openssl-devel tk-devel libffi-devel xz-devel libuuid-devel gdbm-devel libnsl2-devel

# Install python
pyenv install -l # And choose version
pyenv install 3.10.4 # Change version
pyenv global 3.10.4
python -m pip install pyright
```

* Golang language
```sh
curl -LO "https://go.dev/dl/go1.20.3.linux-amd64.tar.gz" # Change version
sudo tar -C /usr/local -xvf go1.20.3.linua-amd64.tar.gz
echo 'export PATH="$PATH:/usr/local/go/bin"' > ~/.profile
```

## Install NeoVim config
```sh
git clone https://github.com/ArtLkv/devops-nvim.git ~/.config/nvim
```

## Install Golang tools
1. Open NeoVim
2. Run command `:GoInstallDeps`

