{ stdenv, fetchurl, joomla_version, lib }:

let
  versionHashMap = {
    "3.9.28" = "sha256-ZXDBIk0Z1y6wx5kPDLnhJ6k7iWx8h9GIS1pHLlYZPAQ=";
    "3.10.1" = "sha256-RGdWyOsB9EIMZxdcfto8zZi/pl7qFuXDYJsgQW01CWc=";
    "4.0.3" = "sha256-/4H4URHNtasyBf98uodVpKtc7+1MS7aYj6WnnSOkI6o=";
  };
  version = joomla_version;

in stdenv.mkDerivation rec {
  pname = "joomla";
  inherit version;

  src = fetchurl {
    url = "https://downloads.joomla.org/cms/joomla${lib.versions.major version}/${builtins.replaceStrings [ "." ] [ "-" ] version}/Joomla_${builtins.replaceStrings [ "." ] [ "-" ] version}-Stable-Full_Package.tar.gz";
    sha256 = versionHashMap."${version}";
  };

  sourceRoot = ".";

  installPhase = ''
    cp -r $src $out 
  '';
}

