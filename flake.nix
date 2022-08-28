{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    satysfi-upstream.url = "github:SnO2WMaN/SATySFi/sno2wman/nix-flake";
    satysfi-formatter-upstream.url = "github:SnO2WMaN/satysfi-formatter/nix-integrate";
    satysfi-language-server-upstream.url = "github:SnO2WMaN/satysfi-language-server/nix-integrate";

    satyxin.url = "github:SnO2WMaN/satyxin";
    satysfi-sno2wman.url = "github:SnO2WMaN/satysfi-sno2wman";

    # dev
    devshell.url = "github:numtide/devshell";
    flake-utils.url = "github:numtide/flake-utils";
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
  };
  outputs = {
    self,
    nixpkgs,
    flake-utils,
    ...
  } @ inputs:
    flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = import nixpkgs {
          inherit system;
          overlays = with inputs; [
            devshell.overlay
            satyxin.overlays.default
            satysfi-language-server-upstream.overlays.default
            satysfi-formatter-upstream.overlays.default
            satysfi-sno2wman.overlays.default
            (import ./nix/satyxin/overlay.nix)
            (final: prev: {
              satysfi = satysfi-upstream.packages.${system}.satysfi;
            })
          ];
        };
      in rec {
        packages = {
          satysfi-dist = pkgs.satyxin.buildSatysfiDist {
            packages = with pkgs.satyxinPackages; [
              class-slydifi
              easytable
              figbox
              pseudo-fonts-jetbrains-mono
              psuedo-fonts-noto-sans
              psuedo-fonts-noto-sans-cjk-jp
              sno2wman
            ];
          };
          main = pkgs.satyxin.buildDocument {
            satysfiDist = self.packages.${system}.satysfi-dist;
            name = "main";
            src = ./src;
            entrypoint = "main.saty";
          };
        };
        defaultPackage = self.packages."${system}".main;

        devShell = pkgs.devshell.mkShell {
          packages = with pkgs; [
            alejandra
            dprint
            satysfi
            satysfi-formatter-write-each
            satysfi-language-server
            treefmt
          ];
          commands = [
            {
              package = "treefmt";
              category = "formatter";
            }
          ];
        };
      }
    );
}
