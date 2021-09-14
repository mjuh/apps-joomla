{ stdenv, fetchurl, joomla_version, lib }:

let
  versionHashMap = {
    "3.9.26" = "15qcpd4al4xjmbadd86f01d3n6qm4ra1vsay7pyjzzjwch8ixb4b";
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

