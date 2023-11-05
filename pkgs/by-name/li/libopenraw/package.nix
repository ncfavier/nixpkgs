{ lib, stdenv, fetchurl, boost, libjpeg, pkg-config, libxml2, rustPackages, gdk-pixbuf }:

stdenv.mkDerivation rec {
  pname = "libopenraw";
  version = "0.3.7";

  src = fetchurl {
    url = "https://libopenraw.freedesktop.org/download/${pname}-${version}.tar.bz2";
    sha256 = "sha256-VRWyYQNh7zRYC2uXZjURn23ttPCnnVRmL6X+YYakXtU=";
  };

  # configureFlags = [
  #   "--with-boost=${boost.dev}"
  # ] ++ lib.optionals (!doCheck) [
  #   "--enable-unittest=no"
  # ];
  #
  buildInputs = [ boost libjpeg libxml2
    # gdk-pixbuf
  ];
  # checkInputs = [ libxml2 ];
  nativeBuildInputs = [ pkg-config rustPackages.rustc rustPackages.cargo ];
  # buildInputs = [ expat zlib boost ]
  #   ++ lib.optionals stdenv.isDarwin [ libiconv darwin.apple_sdk.frameworks.CoreServices ];
  #
  # doCheck = stdenv.isLinux && stdenv.is64bit;
  # dontDisableStatic = doCheck;
  doCheck = true;

  enableParallelBuilding = true;

  meta = with lib; {
    description = "A library for decoding RAW files";
    homepage = "https://libopenraw.freedesktop.org/";
    platforms = platforms.linux ++ platforms.darwin;
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ ncfavier ];
  };
}
