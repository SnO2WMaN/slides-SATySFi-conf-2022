final: prev: {
  satyxinPackages =
    prev.satyxinPackages
    // {
      pseudo-fonts-jetbrains-mono = final.callPackage (import ./packages/pseudo-fonts-jetbrains-mono) {};
    };
}
