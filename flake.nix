{
  inputs = {
    nixpkgs.url = "nixpkgs";
    flake-utils.url = github:numtide/flake-utils;
    nur.url = github:nix-community/NUR;
  };
  outputs = { self, nixpkgs, flake-utils, nur, ... }: flake-utils.lib.eachDefaultSystem (system: let
    inherit (nixpkgs.lib) singleton;

    pkgs = import nixpkgs {
      inherit overlays system;
    };
    overlays = [
      # Setup access to the Nix User Repository
      nur.overlay
      # Pull in Lua overlays from my NUR
      nur-no-packages.repos.shados.overlays.lua-overrides
      nur-no-packages.repos.shados.overlays.lua-packages
    ];
    nur-no-packages = import nur {
      nurpkgs = nixpkgs.legacyPackages.${system};
      pkgs = null;
    };
  in {
    devShells.default = pkgs.mkShell {
      nativeBuildInputs = with pkgs; [
        gnumake zip
        jq
        inotifyTools
        niv
      ] ++ (with pkgs.lua52Packages; [
        lua luarepl

        # Used by tooling
        yuescript argparse inspect rapidjson
        luacheck

        busted
      ]);
      shellHook = ''
        export LUA_PATH="${toString ./.}/lua/?.lua;''${LUA_PATH}"
      '';
    };
  });
}
