# dotfiles
This repository helps me in quickly setting up my Arch Linux installation to personal defaults. It is designed to work with the GNU stow (symbolic link manager). Refer to <https://alexpearce.me/2016/02/managing-dotfiles-with-stow/> for more information.

One directory of particular interest is the `scripts` directory.

## scripts
__archstrap__ scripts are used for installation from a live media.

__restow__ script offers a `dialog` instance for quickly stowing all directories that are in the root of the repository.

__superuser_setup__ and __setup__ helps with post-installation tasks (both utilize a `dialog` choice menu).

__superuser_setup__ offers (among other things) `install_packages` function that automatically installs all packages that are listed in the `./scripts/bin/static/arch_packages`.
