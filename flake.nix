{
  description = "Docker container with Joomla installer";
  inputs = {
    nixpkgs-unstable.url = "nixpkgs/nixpkgs-unstable";
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, ... } @ inputs: 
  let
    system = "x86_64-linux";
  in {
    devShell.${system} = with nixpkgs-unstable.legacyPackages.${system}; mkShell {
      buildInputs = [
        nixUnstable
        nixos-rebuild
      ];
      shellHook = ''
        # Fix ssh completion
        # bash: warning: setlocale: LC_CTYPE: cannot change locale (en_US.UTF-8)
        export LANG=C

        . ${nixUnstable}/share/bash-completion/completions/nix
      '';
    };

    packages.${system} = {
      joomla-3-9 = import ./container.nix {
        inherit nixpkgs system;
        joomla_version = "3.9.26";
      };

      joomla-4-0 = import ./container.nix {
        inherit nixpkgs system;
        joomla_version = "4.0.3";
      };
    };

    defaultPackage.${system} = self.packages.${system}.joomla-4-0;
  };
}

