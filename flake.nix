{
  outputs = inputs: {
    flakeModule = ./flake-module.nix;

    templates =
      let
        tmplPath = path: builtins.path { inherit path; filter = path: _: baseNameOf path != "test.sh"; };
      in
      rec {
        default = both;
        both = {
          description = "nixos-flake template for both Linux and macOS in same flake";
          path = tmplPath ./examples/both;
        };
        linux = {
          description = "nixos-flake template for NixOS configuration.nix";
          path = tmplPath ./examples/linux;
        };
        macos = {
          description = "nixos-flake template for nix-darwin configuration";
          path = tmplPath ./examples/macos;
        };
        home = {
          description = "nixos-flake template for home-manager configuration";
          path = tmplPath ./examples/home;
        };
      };

    nixci.default = let overrideInputs = { nixos-flake = ./.; }; in {
      macos = {
        inherit overrideInputs;
        dir = "examples/macos";
        systems = [ "x86_64-darwin" "aarch64-darwin" ];
      };
      home = {
        inherit overrideInputs;
        dir = "examples/home";
      };
      linux = {
        inherit overrideInputs;
        dir = "examples/linux";
        systems = [ "x86_64-linux" "aarch64-linux" ];
      };
      both = {
        inherit overrideInputs;
        dir = "examples/both";
      };
    };
  };
}
