{ writeShellApplication, pkgs, ... }:
let
  not-yet-lockfile = if pkgs.stdenv.isLinux then "/tmp/not-yet.lock" else "/tmp/not-yet.pid";
in
writeShellApplication {
  name = "gamemode";

  runtimeInputs = [ ];

  text = ''
    set -euo pipefail
    echo -n "$$" > ${not-yet-lockfile}
    exec "$@"
  '';
}
