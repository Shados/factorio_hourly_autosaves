let
  nur-pin = let
    rev = "b824ad0cbc68e2eb1e25031fc7b29af19a59cc1b";
    sha256 = "179dw1lciq4ihlxgz1d5b3b41hzz9vldya2m3ampv9wc1a3aqai9";
  in builtins.fetchTarball {
    url = "https://github.com/nix-community/NUR/archive/${rev}.tar.gz";
    inherit sha256;
  };
  nur-no-packages = import nur-pin { };
  pkgs = import <nixpkgs> {
    overlays = with nur-no-packages.repos.shados.overlays; [
      lua-overrides
      lua-packages
    ];
  };
  lp = pkgs.luajitPackages;
  localMoonscript = lp.moonscript.overrideAttrs (oldAttrs: {
    src = pkgs.fetchFromGitHub {
      owner = "Shados"; repo = "moonscript";
      rev = "596f6fb498f120ba1ba79ea43f95d73870b43a77";
      sha256 = "05kpl9l1311lgjrfghnqnh6m3zkwp09gww056bf30fbvhlfc8iyw";
    };
  });
in

pkgs.mkShell {
  nativeBuildInputs = with pkgs; [
    gnumake zip
    jq
    inotifyTools
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
