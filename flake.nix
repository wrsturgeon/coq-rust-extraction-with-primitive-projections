{
  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };
  outputs =
    {
      flake-utils,
      nixpkgs,
      self,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config.allowBroken = true;
        };
        coq-pkgs = pkgs.coqPackages_8_20;
        inherit (coq-pkgs) coq;
        ml-pkgs = coq.ocamlPackages;

        pname = "coq-rust-extraction";
        src = ./.;
        inherit (coq) version;
      in
      {
        packages.default = coq-pkgs.mkCoqDerivation {
          inherit pname src version;
          propagatedBuildInputs =
            (with coq-pkgs; [
              equations
              metacoq
              stdlib
            ])
            ++ (with ml-pkgs; [
              findlib
              ocaml
            ]);
        };
      }
    );
}
