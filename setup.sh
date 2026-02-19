#!/bin/bash
# setup.sh - dotfiles セットアップスクリプト
# 使い方: ./setup.sh          (全セットアップ実行)
#         ./setup.sh 関数名   (個別実行: e.g. ./setup.sh setup_symlinks_zsh)
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

# --- ヘルパー関数 ---

info() { printf "\033[1;34m[INFO]\033[0m %s\n" "$1"; }
success() { printf "\033[1;32m[OK]\033[0m %s\n" "$1"; }
warn() { printf "\033[1;33m[WARN]\033[0m %s\n" "$1"; }

make_symlink() {
  local src="$1" dest="$2"
  if [[ -L "$dest" ]]; then
    rm "$dest"
  elif [[ -e "$dest" ]]; then
    warn "${dest} が既存ファイルです。バックアップを作成します"
    mv "$dest" "${dest}.bak"
  fi
  ln -sf "$src" "$dest"
  success "リンク作成: $dest -> $src"
}

make_symlink_dir() {
  local src="$1" dest="$2"
  if [[ -L "$dest" ]]; then
    rm "$dest"
  elif [[ -d "$dest" ]]; then
    warn "${dest} が既存ディレクトリです。バックアップを作成します"
    mv "$dest" "${dest}.bak"
  fi
  ln -snf "$src" "$dest"
  success "リンク作成: $dest -> $src"
}

# --- Codespace 対応 ---

setup_codespace() {
  info "Codespace 環境をセットアップ中..."
  sudo apt-get update && sudo apt-get install -y locales-all tig bc fzf
  curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
  chmod u+x nvim.appimage
  ./nvim.appimage --appimage-extract
  sudo mv squashfs-root / && sudo ln -sf /squashfs-root/AppRun /usr/bin/nvim
  sudo chsh "$(id -un)" --shell "/usr/bin/zsh"
  success "Codespace セットアップ完了"
}

# --- Step 1: Homebrew ---

install_homebrew() {
  if command -v brew &>/dev/null; then
    success "Homebrew は既にインストール済みです"
    return
  fi
  info "Homebrew をインストール中..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  # Apple Silicon 用の PATH 設定
  if [[ -f /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  fi
  success "Homebrew インストール完了"
}

# --- Step 2: Brewfile ---

install_brewfile() {
  if ! command -v brew &>/dev/null; then
    warn "Homebrew が見つかりません。先に install_homebrew を実行してください"
    return 1
  fi
  info "Brewfile からパッケージをインストール中..."
  if ! brew bundle install --file="${DOTFILES_DIR}/Brewfile"; then
    warn "一部パッケージのインストールに失敗しました。後で brew bundle install を再実行してください"
  fi
  success "Brewfile インストール完了"
}

# --- Step 3: zsh シンボリックリンク ---

setup_symlinks_zsh() {
  info "zsh シンボリックリンクを作成中..."
  mkdir -p "${HOME}/.zsh"
  make_symlink "${DOTFILES_DIR}/.zshenv" "${HOME}/.zshenv"
  make_symlink "${DOTFILES_DIR}/.zsh/.zshrc" "${HOME}/.zsh/.zshrc"
  make_symlink "${DOTFILES_DIR}/.zsh/.zshenv" "${HOME}/.zsh/.zshenv"
  make_symlink "${DOTFILES_DIR}/.zsh/.zprofile" "${HOME}/.zsh/.zprofile"
  make_symlink_dir "${DOTFILES_DIR}/.zsh/rc" "${HOME}/.zsh/rc"
  success "zsh シンボリックリンク完了"
}

# --- Step 4: vim シンボリックリンク ---

setup_symlinks_vim() {
  info "vim シンボリックリンクを作成中..."
  make_symlink "${DOTFILES_DIR}/.vimrc" "${HOME}/.vimrc"
  make_symlink_dir "${DOTFILES_DIR}/.vim" "${HOME}/.vim"
  success "vim シンボリックリンク完了"
}

# --- Step 4b: その他ホームディレクトリの設定ファイル ---

setup_symlinks_home() {
  info "ホームディレクトリの設定ファイルをリンク中..."
  make_symlink "${DOTFILES_DIR}/.tmux.conf" "${HOME}/.tmux.conf"
  make_symlink "${DOTFILES_DIR}/.tool-versions" "${HOME}/.tool-versions"
  make_symlink "${DOTFILES_DIR}/.npmrc" "${HOME}/.npmrc"
  success "ホームディレクトリ設定リンク完了"
}

# --- Step 5: ~/.config 配下のシンボリックリンク ---

setup_symlinks_config() {
  info "~/.config シンボリックリンクを作成中..."
  local config_dir="${HOME}/.config"

  # alacritty
  mkdir -p "${config_dir}/alacritty/bin"
  make_symlink "${DOTFILES_DIR}/config/alacritty/alacritty.toml" "${config_dir}/alacritty/alacritty.toml"
  make_symlink "${DOTFILES_DIR}/config/alacritty/bin/toggle_opacity" "${config_dir}/alacritty/bin/toggle_opacity"

  # sheldon
  mkdir -p "${config_dir}/sheldon"
  make_symlink "${DOTFILES_DIR}/config/sheldon/plugins.toml" "${config_dir}/sheldon/plugins.toml"

  # karabiner (シンボリックリンク非対応のためコピー)
  mkdir -p "${config_dir}/karabiner"
  cp "${DOTFILES_DIR}/config/karabiner/karabiner.json" "${config_dir}/karabiner/karabiner.json"
  success "コピー: ${config_dir}/karabiner/karabiner.json"

  # mise
  mkdir -p "${config_dir}/mise"
  make_symlink "${DOTFILES_DIR}/config/mise/config.toml" "${config_dir}/mise/config.toml"

  # zellij
  mkdir -p "${config_dir}/zellij"
  make_symlink "${DOTFILES_DIR}/config/zellij/config.kdl" "${config_dir}/zellij/config.kdl"

  # gitui
  mkdir -p "${config_dir}/gitui"
  make_symlink "${DOTFILES_DIR}/config/gitui/key_bindings.ron" "${config_dir}/gitui/key_bindings.ron"

  # hammerspoon (~/.hammerspoon/ を使用)
  mkdir -p "${HOME}/.hammerspoon"
  make_symlink "${DOTFILES_DIR}/config/hammerspoon/init.lua" "${HOME}/.hammerspoon/init.lua"
  make_symlink "${DOTFILES_DIR}/config/hammerspoon/alacritty.lua" "${HOME}/.hammerspoon/alacritty.lua"
  make_symlink "${DOTFILES_DIR}/config/hammerspoon/window.lua" "${HOME}/.hammerspoon/window.lua"
  # hs.spaces はHammerspoon 0.9.93以降ビルトイン。
  # 動作しない場合のみ https://github.com/asmagill/hs._asm.spaces を手動インストール

  success "~/.config + Hammerspoon シンボリックリンク完了"
}

# --- Step 6: gitconfig ---

setup_gitconfig() {
  info "gitconfig をセットアップ中..."
  make_symlink "${DOTFILES_DIR}/git/.gitconfig.base" "${HOME}/.gitconfig"
  if [[ ! -f "${HOME}/.gitconfig.local" ]]; then
    warn "~/.gitconfig.local が存在しません。OAuthトークン等を手動で設定してください"
    cat <<'TEMPLATE'
--- ~/.gitconfig.local のテンプレート ---
[url "https://<TOKEN>:x-oauth-basic@github.com/"]
  insteadOf = https://github.com/
[pr-release]
  token = <TOKEN>
TEMPLATE
  fi
  success "gitconfig セットアップ完了"
}

# --- Step 7: Claude Code 設定 ---

setup_claude() {
  info "Claude Code 設定をセットアップ中..."
  mkdir -p "${HOME}/.claude"
  make_symlink "${DOTFILES_DIR}/claude/CLAUDE.md" "${HOME}/.claude/CLAUDE.md"
  make_symlink "${DOTFILES_DIR}/claude/terraform-rules.md" "${HOME}/.claude/terraform-rules.md"
  make_symlink "${DOTFILES_DIR}/claude/settings.json" "${HOME}/.claude/settings.json"
  success "Claude Code セットアップ完了"
}

# --- Step 8: mise ツール ---

install_mise_tools() {
  if ! command -v mise &>/dev/null; then
    warn "mise が見つかりません。Homebrew でインストール後に再実行してください"
    return 1
  fi
  info "mise ツールをインストール中..."
  mise install
  success "mise ツールインストール完了"
}

# --- Step 9: Rust ---

install_rust() {
  if command -v rustup &>/dev/null; then
    success "Rust (rustup) は既にインストール済みです"
  else
    info "rustup をインストール中..."
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    source "${HOME}/.cargo/env"
    success "Rust インストール完了"
  fi

  info "cargo パッケージをインストール中..."
  local cargo_packages=(cargo-update fd-find zellij)
  for pkg in "${cargo_packages[@]}"; do
    if cargo install --list | grep -q "^${pkg} "; then
      success "${pkg} は既にインストール済みです"
    else
      cargo install "${pkg}"
      success "${pkg} インストール完了"
    fi
  done
}

# --- Step 10: Alacritty (Homebrew deprecated のため GitHub Releases から) ---

install_alacritty() {
  if [[ -d "/Applications/Alacritty.app" ]]; then
    success "Alacritty は既にインストール済みです"
    return
  fi
  info "Alacritty を GitHub Releases からインストール中..."
  local tmp_dir
  tmp_dir="$(mktemp -d)"
  local latest_url
  latest_url="$(curl -s https://api.github.com/repos/alacritty/alacritty/releases/latest \
    | grep "browser_download_url.*Alacritty-.*\.dmg" \
    | head -1 \
    | cut -d '"' -f 4)"
  if [[ -z "$latest_url" ]]; then
    warn "Alacritty リリースURLの取得に失敗しました。手動でインストールしてください"
    warn "https://github.com/alacritty/alacritty/releases"
    rm -rf "$tmp_dir"
    return 1
  fi
  curl -L -o "${tmp_dir}/Alacritty.dmg" "$latest_url"
  hdiutil attach "${tmp_dir}/Alacritty.dmg" -nobrowse -quiet
  cp -R "/Volumes/Alacritty/Alacritty.app" /Applications/
  hdiutil detach "/Volumes/Alacritty" -quiet
  rm -rf "$tmp_dir"
  success "Alacritty インストール完了"
}

# --- Step 11: フォント ---

install_fonts() {
  info "HackGen35 Console NF フォントをインストール中..."
  local font_dir="${HOME}/Library/Fonts"
  if ls "${font_dir}"/HackGen35ConsoleNF-*.ttf &>/dev/null 2>&1; then
    success "HackGen35 Console NF は既にインストール済みです"
    return
  fi
  local tmp_dir
  tmp_dir="$(mktemp -d)"
  local latest_url
  latest_url="$(curl -s https://api.github.com/repos/yuru7/HackGen/releases/latest \
    | grep "browser_download_url.*HackGen_NF.*zip" \
    | head -1 \
    | cut -d '"' -f 4)"
  if [[ -z "$latest_url" ]]; then
    warn "HackGen リリースURLの取得に失敗しました。手動でインストールしてください"
    return 1
  fi
  curl -L -o "${tmp_dir}/hackgen.zip" "$latest_url"
  unzip -o "${tmp_dir}/hackgen.zip" -d "${tmp_dir}/hackgen"
  mkdir -p "$font_dir"
  find "${tmp_dir}/hackgen" -name "HackGen35ConsoleNF-*.ttf" -exec cp {} "$font_dir/" \;
  rm -rf "$tmp_dir"
  success "HackGen35 Console NF インストール完了"
}

# --- Step 11: Google Cloud SDK ---

install_google_cloud_sdk() {
  if [[ -d "${HOME}/google-cloud-sdk" ]]; then
    success "Google Cloud SDK は既にインストール済みです"
    return
  fi
  echo ""
  read -rp "Google Cloud SDK をインストールしますか？ (y/N): " answer
  if [[ "$answer" != "y" && "$answer" != "Y" ]]; then
    info "Google Cloud SDK のインストールをスキップしました"
    return
  fi
  info "Google Cloud SDK をインストール中..."
  curl -O https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-cli-darwin-arm.tar.gz
  tar -xf google-cloud-cli-darwin-arm.tar.gz -C "${HOME}/"
  "${HOME}/google-cloud-sdk/install.sh" --quiet
  rm -f google-cloud-cli-darwin-arm.tar.gz
  success "Google Cloud SDK インストール完了"
}

# --- Step 12: ghq ---

setup_ghq() {
  local ghq_list="${DOTFILES_DIR}/exports/ghq-list.txt"
  if [[ ! -f "$ghq_list" ]]; then
    warn "exports/ghq-list.txt が見つかりません"
    return
  fi
  info "ghq リポジトリ一覧 ($(wc -l < "$ghq_list" | tr -d ' ') repos):"
  echo "  必要なリポジトリを個別にクローンしてください:"
  echo "    ghq get <repo>"
  echo ""
  echo "  一括クローン (時間がかかります):"
  echo "    cat ${ghq_list} | xargs -I {} ghq get {}"
  echo ""
}

# --- Step 13: 手動作業一覧 ---

print_manual_steps() {
  echo ""
  echo "=========================================="
  echo "  手動で行う必要がある作業"
  echo "=========================================="
  echo ""
  echo "1. SSH鍵のコピー:"
  echo "   - ~/.ssh/ (config + 各種キーディレクトリ)"
  echo ""
  echo "2. AWS設定のコピー:"
  echo "   - ~/.aws/ (config, credentials, sso/)"
  echo ""
  echo "3. シークレットファイルの作成:"
  echo "   - ~/.zsh/.zsh_secret (APIトークン等)"
  echo ""
  echo "4. gitconfig ローカル設定:"
  echo "   - ~/.gitconfig.local の作成 (OAuthトークン、pr-releaseトークン)"
  echo ""
  echo "5. Neovim設定:"
  echo "   - ghq get taktalf/dotfiles"
  echo "   - ln -snf \$(ghq root)/github.com/taktalf/dotfiles/nvim ~/.config/nvim"
  echo ""
  echo "6. アプリケーション:"
  echo "   - Kiro CLI"
  echo ""
  echo "7. Karabiner-Elements:"
  echo "   - Quit, Restart → Restart で設定を再読み込み"
  echo ""
  echo "8. macOS設定:"
  echo "   - キーボード設定 (リピート速度等)"
  echo "   - Dock設定"
  echo "   - Finder設定"
  echo ""
  echo "=========================================="
}

# --- メイン実行 ---

main() {
  echo ""
  echo "=========================================="
  echo "  dotfiles セットアップ"
  echo "=========================================="
  echo ""

  # Codespace 判定
  if [[ "${CODESPACES:-}" == "true" ]]; then
    setup_symlinks_zsh
    setup_symlinks_vim
    setup_codespace
    exit 0
  fi

  install_homebrew
  install_brewfile
  setup_symlinks_zsh
  setup_symlinks_vim
  setup_symlinks_home
  setup_symlinks_config
  setup_gitconfig
  setup_claude
  install_mise_tools
  install_rust
  install_alacritty
  install_fonts
  install_google_cloud_sdk
  setup_ghq
  print_manual_steps

  echo ""
  success "セットアップ完了!"
}

# 個別関数実行 or 全体実行
if [[ $# -gt 0 ]]; then
  # 関数名が指定された場合、その関数のみ実行
  func_name="$1"
  shift
  if declare -f "$func_name" > /dev/null; then
    "$func_name" "$@"
  else
    echo "エラー: 関数 '${func_name}' が見つかりません"
    echo ""
    echo "利用可能な関数:"
    echo "  install_homebrew, install_brewfile,"
    echo "  setup_symlinks_zsh, setup_symlinks_vim, setup_symlinks_home,"
    echo "  setup_symlinks_config,"
    echo "  setup_gitconfig, setup_claude,"
    echo "  install_mise_tools, install_rust, install_alacritty, install_fonts,"
    echo "  install_google_cloud_sdk, setup_ghq, print_manual_steps"
    exit 1
  fi
else
  main
fi
