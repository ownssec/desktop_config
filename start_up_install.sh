#!/usr/bin/env bash
set -e

# -------------------------------
# GitHub credentials (editable)
# -------------------------------
GITHUB_USER=""
GITHUB_PASS=""
GITHUB_OWNER="ownssec"

# -------------------------------
# Detect distribution
# -------------------------------
DISTRO=$(lsb_release -is 2>/dev/null || echo "Unknown")
RELEASE=$(lsb_release -rs 2>/dev/null || echo "0")

echo "[*] Detected distro: $DISTRO $RELEASE"

# -------------------------------
# Install core dependencies
# -------------------------------
echo "[*] Updating system and installing core dependencies..."
sudo apt update
sudo apt install -y \
  git make build-essential curl wget unzip cmake ninja-build gettext \
  python3 python3-pip python3-packaging \
  npm nodejs cargo \
  autoconf automake inkscape libgdk-pixbuf2.0-dev libglib2.0-dev \
  libxml2-dev pkg-config sassc parallel libsass-dev \
  meson cmake cmake-extras libxcb1-dev libxcb-keysyms1-dev libpango1.0-dev \
  libxcb-util0-dev xcb libxcb-icccm4-dev libyajl-dev libev-dev \
  libxcb-xkb-dev libxcb-cursor-dev libxkbcommon-dev libxkbcommon-x11-dev \
  libstartup-notification0-dev libxcb-randr0-dev libxcb-xinerama0-dev \
  libxcb-shape0-dev libxcb-xrm-dev libxcb-xrm0 \
  xclip i3lock feh picom jq dex xss-lock \
  polybar rofi flameshot \
  network-manager network-manager-gnome \
  shellcheck luarocks ripgrep \
  fonts-font-awesome mesa-utils vulkan-tools

# Wilder.nvim dependency
sudo luarocks install jsregexp || true

# -------------------------------
# Install i3-gaps
# -------------------------------
echo "[*] Installing i3-gaps..."
if ! command -v i3 &>/dev/null; then
  sudo apt install -y i3
fi

if [[ ! -d ~/i3-gaps ]]; then
  cd ~
  git clone https://github.com/Airblader/i3 i3-gaps
  cd i3-gaps
  mkdir -p build && cd build
  meson ..
  ninja
  sudo ninja install
  echo "✅ i3-gaps installed."
else
  echo "[*] i3-gaps already exists in ~/i3-gaps (skip build)."
fi

# -------------------------------
# Install WezTerm
# -------------------------------
echo "[*] Installing WezTerm..."
ARCH=$(dpkg --print-architecture)
WEZTERM_DEB_URL=$(curl -s https://api.github.com/repos/wez/wezterm/releases/latest \
  | grep "browser_download_url" \
  | grep "Ubuntu22.04.${ARCH}.deb" \
  | cut -d '"' -f 4)

if [ -n "$WEZTERM_DEB_URL" ]; then
  wget -O /tmp/wezterm.deb "$WEZTERM_DEB_URL"
  sudo apt install -y /tmp/wezterm.deb
  echo "✅ WezTerm installed successfully."
else
  echo "⚠️ Could not fetch WezTerm release. Please install manually:"
  echo "   https://wezfurlong.org/wezterm/"
fi

# -------------------------------
# NVM + Node.js
# -------------------------------
if [ ! -d "$HOME/.nvm" ]; then
  curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
fi

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

nvm install 20
nvm alias default 20
nvm use default

npm install -g typescript-language-server eslint_d neovim tree-sitter-cli prettier

# -------------------------------
# Rust setup
# -------------------------------
if ! command -v rustup &> /dev/null; then
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
fi
source "$HOME/.cargo/env"
rustup update stable
cargo install stylua || true

# -------------------------------
# Python setup
# -------------------------------
PIP_VERSION=$(pip3 --version | awk '{print $2}')
if python3 -c "import sys; from packaging import version; sys.exit(0 if version.parse('$PIP_VERSION') >= version.parse('23.0') else 1)"; then
  pip3 install --break-system-packages pynvim pylint neovim-remote
else
  pip3 install --user pynvim pylint neovim-remote
fi

# -------------------------------
# Build Adapta GTK Theme
# -------------------------------
if [ ! -d "$HOME/adapta-gtk-theme" ]; then
  cd ~
  git clone https://github.com/adapta-project/adapta-gtk-theme
  cd adapta-gtk-theme
  ./autogen.sh
  make -j"$(nproc)"
  sudo make install
fi

# -------------------------------
# Build and install libluv properly
# -------------------------------
if ! pkg-config --exists luv; then
  echo "[*] Building and installing libluv from source..."
  cd ~
  rm -rf luv
  git clone --recurse-submodules https://github.com/luvit/luv.git
  cd luv
  git submodule update --init --recursive

  mkdir -p build && cd build
  cmake .. -DBUILD_SHARED_LIBS=ON -DBUILD_STATIC_LIBS=ON -DCMAKE_BUILD_TYPE=Release
  make -j"$(nproc)"
  sudo make install
  echo "✅ libluv installed successfully."
else
  echo "[*] libluv already installed, skipping build."
fi

# -------------------------------
# Build Neovim v0.11.0
# -------------------------------
echo "[*] Building Neovim v0.11.0..."
if [ ! -d "$HOME/neovim" ]; then
  cd ~
  git clone https://github.com/neovim/neovim
fi

cd ~/neovim
git fetch --tags
git checkout v0.11.0
make distclean || true
make CMAKE_BUILD_TYPE=Release
sudo make install
echo "✅ Neovim v0.11.0 built and installed successfully."

# -------------------------------
# Config clones
# -------------------------------
clone_or_update () {
  local repo=$1
  local target=$2
  local url="https://${GITHUB_USER}:${GITHUB_PASS}@github.com/${GITHUB_OWNER}/${repo}.git"

  if [ -d "$target/.git" ]; then
    echo "[*] Updating $repo..."
    git -C "$target" pull || (rm -rf "$target" && git clone "$url" "$target")
  else
    echo "[*] Cloning $repo..."
    rm -rf "$target"
    git clone "$url" "$target"
  fi
}

clone_or_update "polybar" "$HOME/.config/polybar"
clone_or_update "editor_vim_config" "$HOME/.config/nvim"
clone_or_update "wezterm" "$HOME/.config/wezterm"
clone_or_update "linux_rofi" "$HOME/.config/rofi"
clone_or_update "i3wm_config" "$HOME/.config/i3"

# -------------------------------
# AMD RX 6600 GPU drivers
# -------------------------------
echo "[*] Installing AMD RX 6600 GPU drivers..."
if [[ "$DISTRO" =~ (Debian) ]]; then
  echo "[*] Enabling non-free-firmware..."
  echo "deb http://deb.debian.org/debian bookworm main contrib non-free non-free-firmware" | sudo tee /etc/apt/sources.list.d/nonfree.list
  sudo apt update
  sudo apt install -y firmware-linux firmware-amd-graphics libdrm-amdgpu1 \
    xserver-xorg-video-amdgpu mesa-vulkan-drivers mesa-vulkan-drivers:i386
elif [[ "$DISTRO" =~ (Ubuntu|LinuxMint|Zorin|Pop) ]]; then
  sudo apt install -y linux-firmware libdrm-amdgpu1 xserver-xorg-video-amdgpu \
    mesa-vulkan-drivers mesa-vulkan-drivers:i386
else
  echo "⚠️ Unsupported distro ($DISTRO). Install RX 6600 driver manually."
fi

# -------------------------------
# Remove boot splash + dunst
# -------------------------------
sudo sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT="quiet splash"/GRUB_CMDLINE_LINUX_DEFAULT="text"/' /etc/default/grub || true
sudo update-grub || true
sudo apt remove --purge -y plymouth-theme-ubuntu-text plymouth-theme-ubuntu-logo dunst || true
sudo apt autoremove -y

# -------------------------------
# Final summary
# -------------------------------
echo ""
echo "✅ Setup complete!"
echo " - Neovim v0.11.0 installed"
echo " - Node.js, npm, Rust, Python ready"
echo " - Wilder.nvim + jsregexp ready"
echo " - i3-gaps, Polybar, Rofi, WezTerm configured"
echo " - libluv built correctly with libuv"
echo " - AMD RX 6600 GPU driver installed"
echo " - Boot splash removed"

