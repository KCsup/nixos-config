{ playbackSlippi, pkgs ? import <nixpkgs> {} }:
let

  netplay-desktop = pkgs.makeDesktopItem {
    name = "Slippi Online";
    exec = "slippi-netplay";
    comment = "Play Melee Online!";
    desktopName = "Slippi-Netplay";
    genericName = "Wii/GameCube Emulator";
    categories = [ "Game" "Emulator" ];
    startupNotify = false;
  };

  playback-desktop = pkgs.makeDesktopItem {
    name = "Slippi Playback";
    exec = "slippi-playback";
    comment = "Watch Your Slippi Replays";
    desktopName = "Slippi-Playback";
    genericName = "Wii/GameCube Emulator";
    categories = [ "Game" "Emulator" ];
    startupNotify = false;
  };

in
pkgs.stdenv.mkDerivation rec {
  pname = "slippi-ishiiruka";
  version = "3.4.0";
  name = "${pname}-${version}-${if playbackSlippi then "playback" else "netplay"}";
  src = pkgs.fetchFromGitHub {
    owner = "project-slippi";
    repo = "Ishiiruka";
    rev = "v${version}";
    hash = "sha256-qYPrAPAPOoCqfidLsT+ycQd2dXtsjo1PRt4TznVZf6U=";
    fetchSubmodules = true;
  };

  cargoRoot = "Externals/SlippiRustExtensions";

  cargoDeps = pkgs.rustPlatform.importCargoLock {
    lockFile = "${src}/${cargoRoot}/Cargo.lock";

    outputHashes = {
      "cpal-0.15.2" = "sha256-4C7YWUx6SZnZy6pwy0CCL3yPgaMflN1atN3cUNMbcmU=";
    };
  };


  outputs = [ "out" ];
  makeFlags = [ "VERSION=us" "-s" "VERBOSE=1" ];
  hardeningDisable = [ "format" ];

  cmakeFlags = [
    "-DLINUX_LOCAL_DEV=true"
    "-DGTK3_GLIBCONFIG_INCLUDE_DIR=${pkgs.glib.out}/lib/glib-2.0/include"
    "-DENABLE_LTO=True"
    "-DCMAKE_SKIP_BUILD_RPATH=ON"
  ] ++ pkgs.lib.optional (playbackSlippi) "-DIS_PLAYBACK=true";

  postBuild = 
    # with pkgs.lib;
    # optionalString playbackSlippi ''
    #   rm -rf ../Data/Sys/GameSettings
    #   cp -r "${slippi-desktop}/app/dolphin-dev/overwrite/Sys/GameSettings" ../Data/Sys
    # '' + 
    ''
      cp -r -n ../Data/Sys/ Binaries/
      cp -r Binaries/ $out
      mkdir -p $out/lib
      cp $build/build/source/build/Source/Core/DolphinWX/libslippi_rust_extensions.so $out/lib
      mkdir -p $out/bin
    '';

  installPhase =
    if playbackSlippi then ''
      wrapProgram "$out/dolphin-emu" \
        --set "GDK_BACKEND" "x11" \
        --prefix GIO_EXTRA_MODULES : "${pkgs.glib-networking}/lib/gio/modules" \
        --prefix LD_LIBRARY_PATH : "${pkgs.vulkan-loader}/lib" \
        --prefix PATH : "${pkgs.xdg-utils}/bin"
      ln -s $out/dolphin-emu $out/bin/slippi-playback
    ''
    #   ln -s ${playback-desktop}/share/applications $out/share
    # '' 
    else ''
      wrapProgram "$out/dolphin-emu" \
        --set "GDK_BACKEND" "x11" \
        --prefix GIO_EXTRA_MODULES : "${pkgs.glib-networking}/lib/gio/modules" \
        --prefix LD_LIBRARY_PATH : "${pkgs.vulkan-loader}/lib" \
        --prefix PATH : "${pkgs.xdg-utils}/bin"
      ln -s $out/dolphin-emu $out/bin/slippi-netplay

      mkdir -p $out/share/applications
      ln -s ${netplay-desktop}/share/applications $out/share/applications
    '';

  nativeBuildInputs = [
    pkgs.pkg-config
    pkgs.cmake
    pkgs.wrapGAppsHook
    pkgs.rustc
    pkgs.cargo
    pkgs.rustPlatform.cargoSetupHook
  ];

  buildInputs = [
    pkgs.vulkan-loader
    pkgs.makeWrapper
    pkgs.mesa.drivers
    pkgs.mesa
    pkgs.pkg-config
    pkgs.bluez
    pkgs.ffmpeg
    pkgs.libao
    pkgs.libGLU
    pkgs.glib
    pkgs.glib-networking
    pkgs.gettext
    pkgs.xorg.libpthreadstubs
    pkgs.xorg.libXrandr
    pkgs.xorg.libXext
    pkgs.xorg.libX11
    pkgs.xorg.libSM
    pkgs.readline
    pkgs.openal
    pkgs.libevdev
    pkgs.xorg.libXdmcp
    pkgs.portaudio
    pkgs.libusb1
    pkgs.libpulseaudio
    pkgs.udev
    pkgs.gnumake
    pkgs.wxGTK32
    pkgs.gtk2
    pkgs.gtk3
    pkgs.gdk-pixbuf
    pkgs.soundtouch
    pkgs.miniupnpc
    pkgs.mbedtls_2
    pkgs.curl
    pkgs.lzo
    pkgs.sfml
    pkgs.enet
    pkgs.xdg-utils
    pkgs.hidapi
    pkgs.webkitgtk
    pkgs.alsa-lib
  ];
}
