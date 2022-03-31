{ stdenv, fetchurl, lib }:

stdenv.mkDerivation rec {
  pname = "joomla";
  version = "4.1.2";

  src = fetchurl {
    url = "https://downloads.joomla.org/cms/joomla${lib.versions.major version}/${builtins.replaceStrings [ "." ] [ "-" ] version}/Joomla_${builtins.replaceStrings [ "." ] [ "-" ] version}-Stable-Full_Package.tar.gz";
    sha256 = "106nj4brip531viv9v802zpqka4cz2zfpnmajbm48iz1180mzlgf";
  };

  sourceRoot = ".";

  installPhase = ''
    cp -r $src $out 
  '';
}

