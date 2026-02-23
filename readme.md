-- install this first

--install vim plug from the github

-- nerd font for icons_enabled
https://www.nerdfonts.com/font-downloads

-- ............................--
-- Prerequisites
Make sure you have installed the latest version of Neovim v0.9.0++.
Have git, make, pip, python, npm, node and cargo installed on your system.

#!/bin/bash

# Node tools

npm install -g \
 typescript-language-server \
 eslint_d \
 neovim \
 tree-sitter-cli \
 prettier

# Rust tools

cargo install stylua

# Python tools

pip install pynvim pylint

# Apt packages

sudo apt update
sudo apt install -y shellcheck luarocks ripgrep

# LuaRocks

sudo luarocks install jsregexp

--neovim install--

-- kulala.nvim language support
npm install -g @mistweaverco/kulala-ls

Make sure all necessary dependencies are installed:
git clone https://github.com/neovim/neovim.git
cd neovim
git checkout v0.10.0
make CMAKE_BUILD_TYPE=Release
sudo make install

-- for tmux
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
git clone https://github.com/tmux-plugins/tmux-resurrect ~/.tmux/plugins/tmux-resurrect

-- kulala
npm install -g @mistweaverco/kulala-fmt

-- wilder
https://github.com/mhinz/neovim-remote/blob/master/INSTALLATION.md
sudo apt install fd-find ripgrep
pip3 install neovim-remote
pipx ensurepath
pipx install pynvim
sudo apt install python3-pynvim
