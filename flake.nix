{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs = inputs @ {
    self,
    nixpkgs,
    flake-utils,
    ...
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs {
        inherit system;
        # overlays = [
        #     (self: super: {
        #       foma = super.foma.overrideAttrs (oldAttrs: {
        #         version = "0.9.18";  
        #         src = super.fetchFromGitHub {
        #           owner = "mhulden";
        #           repo = "foma";
        #           rev = "d837943400f445d5b4059618bad0d38dc22ffe08";  
        #           sha256 = "sha256-EDa5L+hzp5IlOXAut+ar7OkFmYiiM2inlMGvFjF17Fo=";  
        #         };
        #       });
        #     })
        #    ];
        };

      envWithScript = script:
        (pkgs.buildFHSEnv {
          name = "py39";
          targetPkgs = pkgs: (with pkgs; [
            python39
            
            cmake
            ninja
            gcc
            pre-commit
            # requirement, mb pin version?
            foma
          ]);
          runScript = "${pkgs.writeShellScriptBin "runScript" (''
              set -e
              test -d .nix-venv || ${pkgs.python39.interpreter} -m venv .nix-venv
          source .nix-venv/bin/activate
          set +e
            ''
            + script)}/bin/runScript";
        })
        .env;
    in {
      devShell = envWithScript "bash";
    });
}
