{

  inputs = {
    devenv.url = "github:cachix/devenv";
    devenv.inputs.nixpkgs.follows = "nixpkgs";
  };

  nixConfig = {
    extra-substituters = "https://devenv.cachix.org";
    extra-trusted-public-keys = "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw=";
  };

  outputs =
    { nixpkgs, flake-parts, ... }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [ inputs.devenv.flakeModule ];

      systems = nixpkgs.lib.systems.flakeExposed;

      perSystem =
        { pkgs, ... }:
        {
          devenv.shells.default =
            let
              R = pkgs.rWrapper.override {
                packages = builtins.attrValues { inherit (pkgs.rPackages) formatR shiny ggplot2; };
              };
            in
            {
              packages = builtins.attrValues {
                inherit (pkgs) bashInteractive;
                # inherit rstudio;
              };
              languages.r = {
                enable = true;
                package = R;
              };
            };
        };
    };
}
