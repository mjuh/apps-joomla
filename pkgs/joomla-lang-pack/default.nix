{ stdenv, fetchurl, joomla_version, lib }:

let
  versionHashMap = {
    "4.0.3" = "sha256-mE1nmjH4GGGulLgD89lQnatVd+gG0m/TQ3cZDCWidZE=";
  };
  version = joomla_version;

in stdenv.mkDerivation rec {
  pname = "joomla";
  inherit version;

  src = fetchurl {
    url = "https://downloads.joomla.org/language-packs/translations-joomla${lib.versions.major version}/downloads/joomla${lib.versions.major version}-russian/${builtins.replaceStrings [ "." ] [ "-" ] version}-1/ru-ru_joomla_lang_full_${builtins.replaceStrings [ "." ] [ "-" ] version}v1-zip?format=zip";
    sha256 = versionHashMap."${version}";
  };

  dontUnpack = true;
  sourceRoot = ".";

  installPhase = ''
    cp -r $src $out
  '';
}
