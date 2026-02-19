#!/bin/bash
# export-current.sh - 現環境のデータを収集するスクリプト
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "$0")/.." && pwd)"
EXPORT_DIR="${DOTFILES_DIR}/exports"

mkdir -p "${EXPORT_DIR}"

echo "=== Brewfile エクスポート ==="
if command -v brew &>/dev/null; then
  brew bundle dump --file="${DOTFILES_DIR}/Brewfile" --force
  echo "Brewfile を ${DOTFILES_DIR}/Brewfile に生成しました"
else
  echo "SKIP: Homebrew が見つかりません"
fi

echo ""
echo "=== ghq リストエクスポート ==="
if command -v ghq &>/dev/null; then
  ghq list > "${EXPORT_DIR}/ghq-list.txt"
  echo "$(wc -l < "${EXPORT_DIR}/ghq-list.txt" | tr -d ' ') リポジトリを記録しました"
else
  echo "SKIP: ghq が見つかりません"
fi

echo ""
echo "=== mise ツール一覧エクスポート ==="
if command -v mise &>/dev/null; then
  mise list > "${EXPORT_DIR}/mise-list.txt"
  echo "mise ツール一覧を記録しました"
else
  echo "SKIP: mise が見つかりません"
fi

echo ""
echo "=== npm グローバルパッケージエクスポート ==="
if command -v npm &>/dev/null; then
  npm list -g --depth=0 2>/dev/null > "${EXPORT_DIR}/npm-global.txt" || true
  echo "npm グローバルパッケージを記録しました"
else
  echo "SKIP: npm が見つかりません"
fi

echo ""
echo "=== エクスポート完了 ==="
echo "出力先: ${EXPORT_DIR}/"
ls -la "${EXPORT_DIR}/"
