{composerEnv, fetchurl, fetchgit ? null, fetchhg ? null, fetchsvn ? null, noDev ? false}:

let
  packages = {
    "psr/container" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "psr-container-b7ce3b176482dbbc1245ebf52b181af44c2cf55f";
        src = fetchurl {
          url = "https://api.github.com/repos/php-fig/container/zipball/b7ce3b176482dbbc1245ebf52b181af44c2cf55f";
          sha256 = "0rkz64vgwb0gfi09klvgay4qnw993l1dc03vyip7d7m2zxi6cy4j";
        };
      };
    };
    "symfony/console" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-console-47c02526c532fb381374dab26df05e7313978976";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/console/zipball/47c02526c532fb381374dab26df05e7313978976";
          sha256 = "13539ny0v4s69dqxql01za5lb86dswxml5iv0kz1bqy05cpma6qj";
        };
      };
    };
    "symfony/polyfill-ctype" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-polyfill-ctype-c6c942b1ac76c82448322025e084cadc56048b4e";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/polyfill-ctype/zipball/c6c942b1ac76c82448322025e084cadc56048b4e";
          sha256 = "0jpk859wx74vm03q5s9z25f4ak2138p2x5q3b587wvy8rq2m4pbd";
        };
      };
    };
    "symfony/polyfill-intl-grapheme" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-polyfill-intl-grapheme-267a9adeb8ecb8071040a740930e077cdfb987af";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/polyfill-intl-grapheme/zipball/267a9adeb8ecb8071040a740930e077cdfb987af";
          sha256 = "094nqq6ly9b4rw8dpz7y0knr0dppcbf7w470iqqz9rgkr84gp9r0";
        };
      };
    };
    "symfony/polyfill-intl-normalizer" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-polyfill-intl-normalizer-6e971c891537eb617a00bb07a43d182a6915faba";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/polyfill-intl-normalizer/zipball/6e971c891537eb617a00bb07a43d182a6915faba";
          sha256 = "05bjbrbl98ap8qrmn22za8303yrpqvnmnk0cr8c4v0jh4kdvck5g";
        };
      };
    };
    "symfony/polyfill-mbstring" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-polyfill-mbstring-f377a3dd1fde44d37b9831d68dc8dea3ffd28e13";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/polyfill-mbstring/zipball/f377a3dd1fde44d37b9831d68dc8dea3ffd28e13";
          sha256 = "0l2adplbn6fw2dj3nm1s2274q25njii18fzvid5lry4bykqxv34k";
        };
      };
    };
    "symfony/polyfill-php73" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-polyfill-php73-a678b42e92f86eca04b7fa4c0f6f19d097fb69e2";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/polyfill-php73/zipball/a678b42e92f86eca04b7fa4c0f6f19d097fb69e2";
          sha256 = "10rq2x2q9hsdzskrz0aml5qcji27ypxam324044fi24nl60fyzg0";
        };
      };
    };
    "symfony/polyfill-php80" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-polyfill-php80-dc3063ba22c2a1fd2f45ed856374d79114998f91";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/polyfill-php80/zipball/dc3063ba22c2a1fd2f45ed856374d79114998f91";
          sha256 = "1mhfjibk7mqyzlqpz6jjpxpd93fnfw0nik140x3mq1d2blg5cbvd";
        };
      };
    };
    "symfony/service-contracts" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-service-contracts-d15da7ba4957ffb8f1747218be9e1a121fd298a1";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/service-contracts/zipball/d15da7ba4957ffb8f1747218be9e1a121fd298a1";
          sha256 = "168iq1lp2r5qb5h8j0s17da09iaj2h5hrrdc9rw2p73hq8rvm1w2";
        };
      };
    };
    "symfony/string" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-string-5bd67751d2e3f7d6f770c9154b8fbcb2aa05f7ed";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/string/zipball/5bd67751d2e3f7d6f770c9154b8fbcb2aa05f7ed";
          sha256 = "1ny6bi2sflsdr68fjr2jww3nph0znji6b9pypib426gjv0rf282h";
        };
      };
    };
    "symfony/yaml" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-yaml-bbce94f14d73732340740366fcbe63363663a403";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/yaml/zipball/bbce94f14d73732340740366fcbe63363663a403";
          sha256 = "0lllvf73g1z8ph8ccc2biaqk5v6vaw4f6cmcmpna6rdf0axzy4gd";
        };
      };
    };
  };
  devPackages = {};
in
composerEnv.buildPackage rec {
  inherit packages devPackages noDev;
  name = "joomlatools-console";

  src = fetchurl {
    url = "https://github.com/joomlatools/${name}/archive/refs/tags/v1.6.0.tar.gz";
    sha256 = "0rk20892hjq4pskdcwmh8pmpjj1v36aijbhgkisbd7jfvaj6r6c7";
  };

  executable = false;
  symlinkDependencies = false;
  meta = {
    homepage = "https://github.com/joomlatools/joomlatools-console";
    license = "MPL-2.0";
  };
}
