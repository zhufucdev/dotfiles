{
  lib,
  fetchFromGitHub,
  rustPlatform,
  features ? [ ],
  ...
}:
rustPlatform.buildRustPackage rec {
  pname = "ledoxide";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "zhufucdev";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-sgZyPiNstTo4RFs1P6XyTMwSIxXi4dk/rPVKYMZvQq8=";
  };

  cargoLock = {
    lockFile = "${src}/Cargo.lock";
    allowBuiltinFetchGit = true;
  };

  buildFeatures = features;
}
