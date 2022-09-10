final: prev: {
  satyxinPackages =
    prev.satyxinPackages
    // {
      # override
      figbox = prev.satyxinPackages.figbox.overrideAttrs (oa: {
        version = "0.1.4-feat-include_png";
        copyfrom = let
          root = final.fetchFromGitHub {
            owner = "monaqa";
            repo = "satysfi-figbox";
            rev = "feat-include_png";
            sha256 = "sha256-BlpiMnuHAKzWTRP2a+5zD4geAgBmfMIJZfTi2nUG/Og=";
          };
        in [
          "${root}/src"
        ];
      });
      # new
      pseudo-fonts-jetbrains-mono = final.callPackage (import ./packages/pseudo-fonts-jetbrains-mono) {};
    };
}
