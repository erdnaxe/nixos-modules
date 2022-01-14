with import <nixpkgs> { };

let
  libs = [
    alsa-lib
    atk
    cairo
    ffmpeg
    fontconfig
    freetype
    gdk-pixbuf
    glib
    gtk2
    libglvnd
    libxml2
    libxslt
    ncurses5
    pango
    xorg.libX11
    xorg.libXext
    xorg.libXi
    xorg.libXrender
    xorg.libXtst
    xorg.libXxf86vm
    zlib
  ];
in
stdenv.mkDerivation rec {
  pname = "vivado";
  version = "2020.1";

  src = requireFile rec {
    name = "Xilinx_Unified_2020.1_0602_1208.tar.gz";
    message = ''
      This nix expression requires that ${name} is already part of the store.
      Login to Xilinx, download from
      https://www.xilinx.com/support/download.html,
      rename the file to ${name}, and add it to the nix store with
      "nix-prefetch-url file:///path/to/${name}".
      You might want to use at least Nix 2.4, else you will need 36GiB+ of
      memory during the prefetch.
    '';
    sha256 = "1sz34wklz2ywfkyxbl2lvmb1khza2y6kmf9s8p2618pcc4dgiq59";
  };
  sourceRoot = "Xilinx_Unified_2020.1_0602_1208";

  nativeBuildInputs = [ makeWrapper ];

  desktopItems = [
    (makeDesktopItem {
      name = "vivado";
      desktopName = "Vivado ${version}";
      genericName = "HDL Editor";
      comment = "Synthesis and analysis of hardware description language (HDL) designs";
      icon = "vivado";
      exec = "vivado";
      categories = "Development";
    })
  ];

  # Installer requires the use of FHS environment as it uses unpatched scripts
  # to check if installation succeeded
  installEnv = buildFHSUserEnv {
    name = "${pname}-${version}-installEnv";
    targetPkgs = pkgs: libs;
    runScript = "./xsetup --agree 3rdPartyEULA,WebTalkTerms,XilinxEULA --batch Install --config install_config.txt";
  };
  installPhase = ''
    # Can be generated using `./xsetup -b ConfigGen`
    cat <<EOF > install_config.txt
    Edition=Vivado HL WebPACK
    Product=Vivado
    Destination=$out/opt
    Modules=Virtex UltraScale+ HBM:0,Zynq UltraScale+ MPSoC:0,DocNav:1,Kintex UltraScale:0,Zynq-7000:1,Spartan-7:0,System Generator for DSP:0,Artix-7:0,Virtex UltraScale+:0,Kintex-7:0,Kintex UltraScale+:0,Model Composer:0
    InstallOptions=
    CreateProgramGroupShortcuts=0
    ProgramGroupFolder=Xilinx Design Tools
    CreateShortcutsForAllUsers=0
    CreateDesktopShortcuts=0
    CreateFileAssociation=0
    EOF
    mkdir -p $out/opt
    ${installEnv}/bin/${installEnv.name}

    # Launcher icon
    install -Dm644 $out/opt/Vivado/${version}/doc/images/vivado_logo.png $out/share/pixmaps/vivado.png
  '';

  # Some ELFs target embedded boards
  dontPatchELF = true;
  # Some pre-built files contain /build/
  noAuditTmpdir = true;
  preFixup = ''
    mkdir $out/bin
    for d in $(find $out -name unwrapped -type d); do
        # Patch ELFs in unwrapped directories and wrap them
        for f in $(find $d -type f -exec patchelf {} \; -print); do
            patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" $f || true
            wrapProgram $f --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath libs}"
        done

        # Link wrapped entry points
        for f in $(find $d/../.. -maxdepth 1 -type f | xargs realpath); do
            ln -s $f $out/bin/
        done
    done

    # Fix some hardcoded paths
    for f in $(find $out -name "ISEWrap.sh" -o -name "ISEWrapReports.sh" -o -name "paUtil.tcl"); do
      substituteInPlace $f --replace '/bin/touch' '${coreutils}/bin/touch'
    done
  '';

  meta = with lib; {
    homepage = "https://www.xilinx.com/products/design-tools/vivado.html";
    description = "Synthesis and analysis of hardware description language (HDL) designs";
    platforms = platforms.linux;
    license = licenses.unfree;
    maintainers = with maintainers; [ erdnaxe ];
  };
}

