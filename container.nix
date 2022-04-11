{ nixpkgs, system }:

with import nixpkgs { inherit system; };
let
  joomla = callPackage ./pkgs/joomla { };
  joomla-russian = callPackage ./pkgs/joomla-russian { };

  entrypoint = (stdenv.mkDerivation rec {
    name = "joomla-install";
    builder = writeScript "builder.sh" (
      ''
        source $stdenv/setup
        mkdir -p $out/bin

        cat > $out/bin/${name}.sh <<'EOF'
        #!${bash}/bin/bash
        set -ex
        export PATH=${gnutar}/bin:${coreutils}/bin:${gzip}/bin:${mariadb.client}/bin:${gnused}/bin:${gettext}/bin:${openssl}/bin:${unzip}/bin
      
        export TABLE_PREFIX=$(cat /dev/urandom | tr -dc "a-zA-Z0-9"| head --bytes=4)
        export ADMIN_PASSWORD_HASH=$(echo $ADMIN_PASSWORD | openssl passwd -5 -stdin)
        export INSTALL_DATETIME=$(date +"%Y-%m-%d %H:%M:%S")
        export JOOMLA_SECRET=$(cat /dev/urandom | tr -dc "a-zA-Z0-9" | head --bytes=16)

        echo "Extract installer archive."
        tar -xf ${joomla}

        echo "Prepare SQL dumps for import"
        sed -i "s@#_@$TABLE_PREFIX@g" installation/sql/mysql/base.sql installation/sql/mysql/extensions.sql installation/sql/mysql/supports.sql

        echo "Import prepared SQL dumps"
        mysql -h$DB_HOST -u$DB_USER -p$DB_PASSWORD $DB_NAME < installation/sql/mysql/base.sql
        mysql -h$DB_HOST -u$DB_USER -p$DB_PASSWORD $DB_NAME < installation/sql/mysql/extensions.sql
        mysql -h$DB_HOST -u$DB_USER -p$DB_PASSWORD $DB_NAME < installation/sql/mysql/supports.sql

        echo "Create user"
        envsubst '$TABLE_PREFIX $ADMIN_USERNAME $ADMIN_EMAIL $ADMIN_PASSWORD_HASH $INSTALL_DATETIME $INSTALL_DATETIME' \
         < ${./sql/user_create.sql} | mysql -h$DB_HOST -u$DB_USER -p$DB_PASSWORD $DB_NAME

        echo "Install config"
        envsubst '$DOCUMENT_ROOT $APP_TITLE $DB_HOST $DB_USER $DB_PASSWORD $DB_NAME $TABLE_PREFIX $ADMIN_EMAIL $JOOMLA_SECRET' \
          < ${./configs/configuration.php} > configuration.php

        mv htaccess.txt .htaccess
        mv robots.txt.dist robots.txt

        rm web.config.txt
        rm -rf installation

        echo "Install russian translation"
        unzip ${joomla-russian}
        mv pkg_ru-RU.xml administrator/manifests/packages/

        echo "Import russian ext sql"
        envsubst '$TABLE_PREFIX' < ${./sql/russian_ext_reg.sql} | mysql -h$DB_HOST -u$DB_USER -p$DB_PASSWORD $DB_NAME

        EOF

        chmod 555 $out/bin/${name}.sh
      ''
    );
  });

in
pkgs.dockerTools.buildLayeredImage rec {
  name = "docker-registry.intr/apps/joomla";

  contents = [ bashInteractive coreutils gnutar unzip gzip entrypoint mariadb.client ];
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
