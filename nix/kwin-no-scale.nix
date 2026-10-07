{
  writeShellScriptBin,
  kdePackages,
}:

writeShellScriptBin "kwin_no_scale" ''
  if [ -n "''${HOME:-}" ] && [ -f /etc/xdg/kglobalshortcutsrc ] && [ ! -e "$HOME/.config/kglobalshortcutsrc" ]; then
    mkdir -p "$HOME/.config"
    cp -n /etc/xdg/kglobalshortcutsrc "$HOME/.config/kglobalshortcutsrc" || true
  fi

  if command -v deepin-kwin_x11 >/dev/null 2>&1; then
    self_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
    exec deepin-kwin_x11 ":appFilePath=$self_dir/kwin_no_scale" "$@"
  fi

  exec ${kdePackages.kwin-x11}/bin/kwin_x11 "$@"
''
