{ nixpkgs, joomla_version, system }:

with import nixpkgs { inherit system; };
let
  joomla = callPackage ./pkgs/joomla { inherit joomla_version; };
  joomla_lang = callPackage ./pkgs/joomla-lang-pack { inherit joomla_version; };
  joomla_console = callPackage ./pkgs/joomla-console { };

  installCommand = builtins.concatStringsSep " " [
    "${joomla_console}/bin/joomla site:install"
    "--mysql-login=$DB_USER"
    "--mysql-host=$DB_HOST"
    "--mysql-database=$DB_NAME"
    "--www=/"
    "--sample-data=default"
    "--skip-create-statement"
    "--options=/tmp/configuration.yaml"
    "workdir"
  ];

  entrypoint = (stdenv.mkDerivation rec {
    name = "joomla-install";
    builder = writeScript "builder.sh" (''
      source $stdenv/setup
      mkdir -p $out/bin

      cat > $out/bin/${name}.sh <<'EOF'
      #!${bash}/bin/bash
      set -ex
      export PATH=${gnutar}/bin:${coreutils}/bin:${gzip}/bin:${mariadb.client}/bin
      export MYSQL_PWD=$DB_PASSWORD

      echo "Extract installer archive."
      tar -xf ${joomla}

      echo "Prepare configuration"
      echo "debug: 0" >> /tmp/configuration.yaml
      echo "password: $DB_PASSWORD" >> /tmp/configuration.yaml
      echo "sitename: $APP_TITLE" >> /tmp/configuration.yaml
      echo "tmp_path: $DOCUMENT_ROOT/tmp" >> /tmp/configuration.yaml
      echo "log_path: $DOCUMENT_ROOT/logs" >> /tmp/configuration.yaml

      echo "Install."
      ${installCommand}

      echo "Modify users cause stupid joomla console can't do it"
      mysql -h$DB_HOST -u$DB_USER -p$DB_PASSWORD $DB_NAME -e "DELETE FROM j_users WHERE username != \"admin\";" 
      mysql -h$DB_HOST -u$DB_USER -p$DB_PASSWORD $DB_NAME -e "UPDATE j_users SET username = \"$ADMIN_USERNAME\", password = MD5(\"$ADMIN_PASSWORD\"), email = \"$ADMIN_EMAIL\" WHERE username = \"admin\";" 

      ${joomla_console}/bin/joomla --www=/ site:list
      ${joomla_console}/bin/joomla --www=/ extension:installfile workdir ${joomla_lang}

      mv htaccess.txt .htaccess
      EOF

      chmod 555 $out/bin/${name}.sh
    '');
  });

in pkgs.dockerTools.buildLayeredImage rec {
  name = "docker-registry.intr/apps/joomla";
  tag = "${joomla_version}_latest";

  contents = [ bashInteractive coreutils gnutar gzip entrypoint mariadb.client unzip ];
  config = {
    Entrypoint = "${entrypoint}/bin/joomla-install.sh";
    Env = [
      "TZ=Europe/Moscow"
      "TZDIR=${tzdata}/share/zoneinfo"
      "LOCALE_ARCHIVE_2_27=${glibcLocales}/lib/locale/locale-archive"
      "LOCALE_ARCHIVE=${glibcLocales}/lib/locale/locale-archive"
      "LC_ALL=en_US.UTF-8"
      "SSL_CERT_FILE=/etc/ssl/certs/ca-bundle.crt"
    ];
    WorkingDir = "/workdir";
  };
  extraCommands = ''
    mkdir -p usr/bin etc tmp
    chmod 777 tmp
    ln -s ${coreutils}/bin/ln usr/bin/env

    cat > etc/passwd << 'EOF'
    root:!:0:0:System administrator:/root:/bin/sh
    alice:!:1000:997:Alice:/home/alice:/bin/sh
    EOF

    cat > etc/group << 'EOF'
    root:!:0:
    users:!:997:
    EOF

    cat > etc/nsswitch.conf << 'EOF'
    hosts: files dns
    EOF
  '';

}
