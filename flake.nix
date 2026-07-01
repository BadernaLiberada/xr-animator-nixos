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

      src = pkgs.fetchzip {
        url = "https://github.com/ButzYung/SystemAnimatorOnline/releases/download/XR-Animator_v0.34.2/XR-Animator_v0.34.2_linux-x64.zip";
        hash = "sha256-WqO/xyTL/s8WqCi8zVKVpx5DPMqB7psw5CvyP0IUWkc=";
        stripRoot = false;
      };

      nativeBuildInputs = with pkgs; [
        autoPatchelfHook
        makeWrapper
      ];

      buildInputs = xraLibs;

      installPhase = ''
      runHook preInstall

      mkdir -p "$out/bin"
      cp "$src/XR-Animator_v0.34.2_linux-x64" "$out/bin/xranimator"
      move "$out/bin/xranimator/XR Animator - electron-v35.1.2-linux-x64_SA/" "$out/bin/xranimator/XR_Animator_-_electron-v35.1.2-linux-x64_SA/"
      chmod +x "$out/bin/xranimator/XR_Animator_-_electron-v35.1.2-linux-x64_SA/electron"

      wrapProgram "$out/bin/xranimator/XR_Animator_-_electron-v35.1.2-linux-x64_SA/electron"

      runHook postInstall

      '';

      meta.mainProgram = "xr-animator";
    };
  };
}
