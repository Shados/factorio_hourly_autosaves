let
  # NUR setup
  nur-pin = let
    rev = "b824ad0cbc68e2eb1e25031fc7b29af19a59cc1b";
    sha256 = "179dw1lciq4ihlxgz1d5b3b41hzz9vldya2m3ampv9wc1a3aqai9";
  in builtins.fetchTarball {
    url = "https://github.com/nix-community/NUR/archive/${rev}.tar.gz";
    inherit sha256;
  };
  nur-no-packages = import nur-pin { };

  # Add in Lua package overrides
  pkgs = import <nixpkgs> {
    overlays = with nur-no-packages.repos.shados.overlays; [
      lua-overrides
      lua-packages
    ];
  };
  lp = pkgs.luajitPackages;

  # Use my moonscript PR w/ inotify-based watcher
  localMoonscript = lp.moonscript.overrideAttrs (oldAttrs: {
    src = pkgs.fetchFromGitHub {
      owner = "Shados"; repo = "moonscript";
      rev = "596f6fb498f120ba1ba79ea43f95d73870b43a77";
      sha256 = "05kpl9l1311lgjrfghnqnh6m3zkwp09gww056bf30fbvhlfc8iyw";
    };
  });

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
  ] ++ (with lp; [
    localMoonscript
    inotify
    lua moonpick
    luarepl moor

    busted
  ]);
  shellHook = ''
    export LUA_PATH="${toString ./.}/lua/?.lua;''${LUA_PATH}"
  '';
}
