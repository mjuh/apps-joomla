{ stdenv, fetchurl, lib }:

stdenv.mkDerivation rec {
  pname = "joomla-russian";
  version = "4.1.1";

  src = fetchurl {
    url = "https://downloads.joomla.org/language-packs/translations-joomla${lib.versions.major version}/downloads/joomla${lib.versions.major version}-russian/${builtins.replaceStrings [ "." ] [ "-" ] version}-1/ru-ru_joomla_lang_full_${builtins.replaceStrings [ "." ] [ "-" ] version}v1-zip?format=zip";
    sha256 = "sha256-Ohq3+VlZKVvyd7KW3OfYFh6/qCDMD61cSWb92eJf4CM=";
  };

  sourceRoot = ".";
  unpackPhase = " ";
  installPhase = ''
    cp -r $src $out
  '';
}


