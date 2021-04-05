{ stdenv, fetchurl, joomla_version }:

let
  versionHashMap = {
    "3.9.26" = "15qcpd4al4xjmbadd86f01d3n6qm4ra1vsay7pyjzzjwch8ixb4b";
  };
  version = joomla_version;

in stdenv.mkDerivation rec {
  pname = "joomla";
  inherit version;

  src = fetchurl {
    url = "https://downloads.joomla.org/cms/joomla3/${builtins.replaceStrings [ "." ] [ "-" ] version}/Joomla_${builtins.replaceStrings [ "." ] [ "-" ] version}-Stable-Full_Package.tar.gz";
    sha256 = versionHashMap."${version}";
  };

  sourceRoot = ".";

  installPhase = ''
    cp -r $src $out 
  '';
}

