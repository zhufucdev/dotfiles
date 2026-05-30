{
  writeShellApplication,
  pkgs,
  lib,
  wrapPkg ? null,
  ...
}:
let
  not-yet-lockfile = if pkgs.stdenv.isLinux then "/run/not-yet/not-yet.lock" else "/tmp/not-yet.pid";
  exec = if wrapPkg == null then "$@" else "${lib.getExe wrapPkg} $@";
in
writeShellApplication {
  name = "gamemode";

  runtimeInputs = lib.optional (wrapPkg != null) [ wrapPkg ];

  text = ''
    set -euo pipefail
    echo -n "$$" > ${not-yet-lockfile}
    exec "${exec}"
  '';
}
