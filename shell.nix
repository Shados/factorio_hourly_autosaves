let
  pins = import ./nix/sources.nix;
  nur-no-packages = import pins.nur { };

  # Add in Lua package overrides
  pkgs = import <nixpkgs> {
    overlays = with nur-no-packages.repos.shados.overlays; [
      lua-overrides
      lua-packages
    ];
  };
  lp = pkgs.luajitPackages;

  factorio-changelog-creator = poetryBuilder {
    python = pkgs.python37;
    src = pkgs.fetchFromGitHub {
      owner = "Roang-zero1"; repo = "factorio-changelog-creator";
      rev = "48adaccfc52b051a3ca35d75a248141651f02f86";
      sha256 = "1ykcqmpyibb698pp8kfasid70dmzrab56gzzf5hvmfvsxy2brv6p";
    };
  };

  # Convenience builder for poetry-based python projects
  poetryBuilder = pkgs.lib.flip pkgs.callPackage
    { inherit (pkgs.poetry2nix) mkPoetryApplication; }
    ( { lib, mkPoetryApplication }:
      { python, src, doCheck ? true }:
      with lib;
      let
        metadata = (builtins.fromTOML (builtins.readFile "${src}/pyproject.toml")).tool.poetry;
      in
      mkPoetryApplication rec {
        inherit src python doCheck;
        pyproject = "${src}/pyproject.toml";
        poetrylock = "${src}/poetry.lock";

        meta = {
          maintainers = metadata.maintainers or metadata.authors;
          description = metadata.description;
        } // optionalAttrs (metadata ? repository) { downloadPage = metadata.repository; };
      }
    );
in
pkgs.mkShell {
  nativeBuildInputs = with pkgs; [
    gnumake zip
    jq
    inotifyTools
    factorio-changelog-creator
    niv
  ] ++ (with lp; [
    moonscript
    inotify
    lua moonpick
    luarepl moor

    busted
  ]);
  shellHook = ''
    export LUA_PATH="${toString ./.}/lua/?.lua;''${LUA_PATH}"
  '';
}
