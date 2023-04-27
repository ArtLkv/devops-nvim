# NeoVim configuration for DevOps

## Pre-requirements

* Lua LTS
```sh
sudo apt install ninja-build
mkdir devops
cd devops
git clone https://github.com/LuaLS/lua-language-server
cd lua-language-server
./make.sh
echo 'export PATH="$PATH:/home/$USER/devops/lua-language-server/bin"' > ~/.profile

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
* Install Golang tools
1. Open NeoVim
2. Run command `:GoInstallDeps`

