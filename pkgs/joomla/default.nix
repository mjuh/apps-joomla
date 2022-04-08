{ stdenv, fetchurl, lib }:

stdenv.mkDerivation rec {
  pname = "joomla";
  version = "4.1.2";

  src = fetchurl {
    url = "https://downloads.joomla.org/cms/joomla${lib.versions.major version}/${builtins.replaceStrings [ "." ] [ "-" ] version}/Joomla_${builtins.replaceStrings [ "." ] [ "-" ] version}-Stable-Full_Package.tar.gz";
    sha256 = "sha256-cGTs/vHo/3v8uslZvugQFyb8zuVHJkq3VfhV+17BybI=s";
  };

  sourceRoot = ".";


  unpackPhase = " ";
  installPhase = ''
    cp -r $src $out
  '';
}

