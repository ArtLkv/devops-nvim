# NeoVim configuration for DevOps

!!! MY ENGLISH BAD, IF YOU FOUND THE WORST OR UNCORRENT WORD, PARAGRAPH AND ETC. PLEASE, LET ME KNOW !!!

## Pre-requirements

* Install dependencies
```sh
sudo apt update
sudo install fzf ripgrep ninja-build unzip
sudo apt install build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev curl libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev
```

* Create folder for all installed tools
```sh
mkdir ~/devops
```

* Install Iosevka Nerd Font(or another Nerd Font)
```sh
curl -LO "https://github.com/ryanoasis/nerd-fonts/releases/download/v2.3.3/IosevkaTerm.zip" # Change version
mkdir ~/devops/IosevkaTerm
unzip IosevkaTerm.zip -d ~/devops/IosevkaTerm
sudo mkdir /usr/share/fonts/IosevkaNF
sudo mv ~/devops/IosevkaTerm/*.tt* /usr/share/fonts/IosevkaNF/
sudo chmod 644 /usr/share/fonts/IosevkaNF/*
fc-cache --force
rm -rf ~/devops/IosevkaTerm
```

* Install fish
```sh
sudo apt install fish
sudo vim /etc/passwd # And change /bin/bash to /bin/fish, when you found /home/$USER
curl https://raw.githubusercontent.com/oh-my-fish/oh-my-fish/master/bin/install | fish
omf update
omf install lambda
```

* Install NeoVim
```sh
curl -LO "https://github.com/neovim/neovim/releases/download/v0.9.0/nvim-linux64.tar.gz" # Change version
tar xzvf nvim-linux64.tar.gz -C ~/devops/nvim
nvim ~/.config/fish/config.fish # And add to $PATH this var `$HOME/devops/nvim/bin`
```

* Python language and python LSP
```sh
# Install PyEnv
git clone https://github.com/pyenv/pyenv.git ~/devops/pyenv
cd ~/devops/pyenv && src/configure && make -C src
set -Ux PYENV_ROOT $HOME/.pyenv
fish_add_path $PYENV_ROOT/bin
nvim ~/.config/fish/config.fish # And add this `pyenv init - | source`

# Install python
pyenv install -l # And choose version
pyenv install 3.10.4 # Change version
pyenv global 3.10.4
python -m pip install python-lsp-server
```

* Golang language
```sh
curl -LO "https://go.dev/dl/go1.20.3.linux-amd64.tar.gz" # Change version
sudo tar -C ~/devops -xvf go1.20.3.linua-amd64.tar.gz
nvim ~/.config/fish/config.fish # Create GOROOT and GOPATH, add to $PATH this vars `$HOME/devops/go/bin`($GOROOT) and `$HOME/go/bin`($GOPATH)
```

* (Optional) Lua LSP
```sh
cd ~/devops
git clone https://github.com/LuaLS/lua-language-server
cd lua-language-server
./make.sh
nvim ~/.config/fish/config.fish # And add to $PATH this var `$HOME/devops/lua-language-server/bin`
```

## Install NeoVim config
```sh
git clone https://github.com/ArtLkv/devops-nvim.git ~/.config/nvim
```

## Install Golang tools
1. Open NeoVim
2. Run command `:GoInstallDeps`

# Roadmap(1.0.0)
I make the first release, when I complete the mailstone tasks.

## Mailstone
- [x] API system
- [x] Different settings for different programming languages
- [ ] Golang tools support
    - [x] gopls
    - [x] gomodifytags
    - [x] gotests
    - [x] iferr
    - [x] impl
    - [ ] govulncheck
- [ ] Bash support
- [ ] Git support
    - [ ] Fugitive
    - [ ] GitSigns
- [ ] Docker support
- [ ] Terraform support
- [ ] Ansible support
- [ ] Yaml support
- [ ] Protobuf support
- [x] Language Server Protocols support
    - [x] Python
    - [x] Golang
    - [x] Lua
## Optional
- [ ] Add documentation about this configuration
- [ ] Debugger support
- [ ] Web support(html, css, js, ts)
- [x] Comment system
- [x] Terminal support
- [ ] Notification system
    - [x] Modify default neovim notification system
    - [ ] Add title for notify messages
- [ ] Change mappings to more comfortable keybindings
- [ ] Buffer with list of all mappings

# Documentation

* If you want read about this configuration. Read [this](./docs/help.md), please.
* If you want to add the yourself custom command. Read [this](./docs/custom_commands.md), please.
* If you want read about structure of this configuration. Read [this](./docs/structure.md), please.
