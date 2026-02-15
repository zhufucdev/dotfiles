{
  lib,
  pkgs,
  fetchFromGitHub,
  rustPlatform,
  cudaPackages,
  features ? [ ],
  ...
}:
let
  useCuda = lib.elem "cuda" features;
in
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
  nativeBuildInputs = lib.optionals useCuda [
    cudaPackages.cuda_nvcc
  ];
  CUDA_PATH = if useCuda then "${cudaPackages.cudatoolkit}" else null;
}
