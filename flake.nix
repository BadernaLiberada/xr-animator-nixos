{
  description = "XR Animator";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs, ... }:
  let
    system = "x86_64-linux";
    pkgs = import nixpkgs { inherit system; };

    xraLibs = with pkgs; [
      glib
      nss
      nspr
      dbus
      atk
      cups
      gtk3
      pango
      cairo
      libX11
      libXcomposite
      libXdamage
      libXext
      libXfixes
      libXrandr
      libgbm
      expat
      libxcb
      libxkbcommon
      alsa-lib
      libGL
    ];
  in {
    packages.${system}.default = pkgs.stdenv.mkDerivation {
      pname = "xr-animator";
      version = "0.34.2";

      src = pkgs.fetchurl {
        url = "https://github.com/ButzYung/SystemAnimatorOnline/releases/download/XR-Animator_v0.34.2/XR-Animator_v0.34.2_linux-x64.zip";
        hash = "sha256-WqO/xyTL/s8WqCi8zVKVpx5DPMqB7psw5CvyP0IUWkc=";
      };

      nativeBuildInputs = with pkgs; [
        unzip
        autoPatchelfHook
        makeWrapper
      ];

      buildInputs = xraLibs;

      unpackPhase = ''
        unzip "$src"
        cd XR-Animator_v0.34.2_linux-x64
      '';

      installPhase = ''
        mkdir -p $out/opt/xr-animator $out/bin
        cp -r . $out/opt/xr-animator

        makeWrapper $out/opt/xr-animator/electron $out/bin/xr-animator \
          --chdir $out/opt/xr-animator \
          --prefix LD_LIBRARY_PATH : ${pkgs.lib.makeLibraryPath xraLibs}
      '';

      meta.mainProgram = "xr-animator";
    };
  };
}
