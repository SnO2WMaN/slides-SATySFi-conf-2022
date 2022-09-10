{
  pkgs,
  stdenv,
  jetbrains-mono,
  ...
}: let
  version = "0.0.1";
  root = ./.;
  fontfile = jetbrains-mono;
in
  stdenv.mkDerivation {
    inherit version;
    pname = "satyxin-psuedo-fonts-jetbrains-mono";

    dontBuild = true;
    dontUnpack = true;

    installPhase = ''
      mkdir -p $out/fonts/jetbrains-mono
      cp -r ${fontfile}/share/fonts/truetype/* $out/fonts/jetbrains-mono
      # rm $out/fonts/jetbrains-mono/JetBrainsMono-Italic[wght].ttf
      # rm $out/fonts/jetbrains-mono/JetBrainsMono[wght].ttf
      rm $out/fonts/jetbrains-mono/JetBrainsMonoNL-*.ttf

      mkdir -p $out/hash
      cp ${"${root}/fonts.satysfi-hash"} $out/hash/fonts.satysfi-hash
    '';
  }
