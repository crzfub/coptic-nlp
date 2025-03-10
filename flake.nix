{
  inputs.mach-nix.url = "github:DavHau/mach-nix";

  outputs = { self, nixpkgs, mach-nix }: {
    devShells.default = mach-nix.lib.mkPython {
      python = "3.9";
      requirements = builtins.readFile ./requirements.txt;
    };
  };
}

