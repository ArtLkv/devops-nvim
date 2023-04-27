# DevOps Neovim - Configuration structure

* `core` - folder with settings, which modify only kernel settings(as LSP, completion system, fzf finder and etc).
    * `api` - folder with settings, which modify default NeoVim API. Example: custom commands, integrated terminal scripts, and specify functions.
        * `utils` - very-very specify functions. Example: Golang file parser, script for golang tools installation and others.
    * `features` - folder with minor kernel settings. Example: terminal integration, snippets support and other don't important, but useful features.
    * `system` - folder with major kernel settings. Example: LSP, completion, file manager ant etc.
* `ui` - folder with settings, which modify only NeoVim render.
* `user` - folder with settings, which modify only NeoVim customization.(Don't modify kernel configuration) Example: Mappings, font, options.
