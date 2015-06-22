{ stdenv
, xlibs
, mesa_glu
, fetchurl
, overrideCC
, unzip
, gcc49
}:

let gcc49stdenv = overrideCC stdenv gcc49;
in gcc49stdenv.mkDerivation rec {
  version = "1.3";
  name = "voxgen-${version}";

  src = fetchurl {
    name = "voxgen-1.3.zip";
    url = "https://www.dropbox.com/s/qsp3gt4ile3w7xp/voxgen.v1.3.zip?dl=1";
    sha256 = "0ii1i1p2f7l7v1gk0k07ps5cfw5p9w25z2bdz4vvxps0qgr5civf";
  };

  libPath = stdenv.lib.makeLibraryPath [
    xlibs.libX11
    mesa_glu
    gcc49stdenv.cc.cc
  ];

  buildInputs = [ unzip ];
  dontStrip = true;

  installPhase = ''
    mkdir -p $out/bin
    cp voxgen $out/bin
    echo $libPath

    patchelf --set-interpreter $(cat $NIX_CC/nix-support/dynamic-linker) \
             --set-rpath $libPath $out/bin/voxgen

    mkdir -p $out/share
    cp -r tga_example readme.txt example.vox $out/share
  '';

  meta = with stdenv.lib; {
    description = "Generates voxels from image files";
    longDescription = ''
      VoxGen is a tool created by Voxelanut devs to easily
      construct voxel blocks from image files
    '';
    homepage = http://voxelnauts.com/;
    license = licenses.unfree;
    maintainers = with maintainers; [ jb55 ];
  };
}
