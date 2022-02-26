{ sources, stdenv, buildFHSUserEnvBubblewrap, writeShellScript, edopro-raw }:

let
  runScript = writeShellScript "edopro" ''
    set -eu

    if [[ -z "''${EDOPRO_DATADIR:-}" ]]; then
      EDOPRO_DATADIR="$HOME/.local/share/edopro"
    fi

    if [[ ! -d "$EDOPRO_DATADIR" ]]; then
      mkdir -p "$EDOPRO_DATADIR"
    fi

    # EDOPro (like a lot of applications) breaks when not running from
    # the directory it loads its files from, so we copy+overwrite the
    # full package, except the config directory if it already exists.

    find '${edopro-raw}/opt/ProjectIgnis' -maxdepth 1 ! -name config -exec cp -r {} "$EDOPRO_DATADIR" \;

    if [[ ! -d "$EDOPRO_DATADIR/config" ]]; then
      cp -r '${edopro-raw}/opt/ProjectIgnis/config' "$EDOPRO_DATADIR"
    fi

    # Fix permissions
    find "$EDOPRO_DATADIR" -type f -exec chmod u=rw {} +
    find "$EDOPRO_DATADIR" -type d -exec chmod u=rwx {} +
    chmod u=rwx "$EDOPRO_DATADIR/EDOPro"

    # Patch the download paths so EDOPro can download card art
    sed -i "s|\./|$EDOPRO_DATADIR/|g" "$EDOPRO_DATADIR/config/configs.json"

    cd "$EDOPRO_DATADIR"
    "$EDOPRO_DATADIR/EDOPro"
  '';
in buildFHSUserEnvBubblewrap {
  inherit runScript;

  name = "edopro";
  targetPkgs = pkgs:
    with pkgs; [
      alsa-lib
      libGL
      mono
      udev
      xorg.libX11
      xorg.libXcursor
      xorg.libXrandr
      xorg.libXxf86vm
    ];
}
