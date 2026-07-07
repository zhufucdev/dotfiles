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
    for running_model in $(ollama ps | tail -n +2 | awk '{printf $1}'); do
      ollama stop "$running_model"
    done
    echo -n "$$" > ${not-yet-lockfile}
    exec "${exec}"
  '';
}
