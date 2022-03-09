{ stdenv, fetchurl, lib }:

stdenv.mkDerivation rec {
  pname = "joomla";
  version = "4.1.0";

  src = fetchurl {
    url = "https://downloads.joomla.org/cms/joomla${lib.versions.major version}/${builtins.replaceStrings [ "." ] [ "-" ] version}/Joomla_${builtins.replaceStrings [ "." ] [ "-" ] version}-Stable-Full_Package.tar.gz";
    sha256 = "sha256-N2ocPZm9xVpXr0i8iJjtD6/evSZFaRbkCfKRSjwtr0E=";
  };

  sourceRoot = ".";

  installPhase = ''
    cp -r $src $out 
  '';
}

