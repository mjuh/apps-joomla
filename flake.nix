{
  description = "Docker container with Joomla installer";
  inputs = {
    nixpkgs-unstable.url = "nixpkgs/nixpkgs-unstable";
    majordomo.url = "git+https://gitlab.intr/_ci/nixpkgs?ref=deploy_postfix";
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, majordomo, ... } @ inputs: 
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
        joomla_version = "3.9.28";
      };

      joomla-3-10 = import ./container.nix {
        inherit nixpkgs system;
        joomla_version = "3.10.1";
      };

      joomla-4-0 = import ./container.nix {
        inherit nixpkgs system;
        joomla_version = "4.0.3";
      };

      deploy-3-9 = majordomo.outputs.deploy {
        tag = "apps/joomla";
        pkg_name = "joomla-3-9";
        postfix = "_3_9";
      };

      deploy-3-10 = majordomo.outputs.deploy {
        tag = "apps/joomla";
        pkg_name = "joomla-3-10";
        postfix = "_3_10";
      };

      deploy-4-0 = majordomo.outputs.deploy {
        tag = "apps/joomla";
        pkg_name = "joomla-4-0";
        postfix = "_4_0";
      };
    };

    defaultPackage.${system} = self.packages.${system}.joomla-4-0;
  };
}

