{ nixpkgs, joomla_version, system }:

with import nixpkgs { inherit system; };
let
  joomla = callPackage ./pkgs/joomla { inherit joomla_version; };

  entrypoint = (stdenv.mkDerivation rec {
    name = "joomla-install";
    builder = writeScript "builder.sh" (''
      source $stdenv/setup
      mkdir -p $out/bin

      cat > $out/bin/${name}.sh <<'EOF'
      #!${bash}/bin/bash
      set -ex
      export PATH=${gnutar}/bin:${coreutils}/bin:${gzip}/bin:${mariadb.client}/bin:${gnused}/bin:${envsubst}/bin:${openssl}/bin
      
      export MYSQL_PWD=$DB_PASSWORD
      export TABLE_PREFIX=$(echo $ADMIN_PASSWORD | sha256sum | head --bytes=3 )
      export ADMIN_PASSWORD_HASH=$(echo $ADMIN_PASSWORD | openssl passwd -5 -stdin)
      export INSTALL_DATETIME=$(date +"%Y-%m-%d %H:%M:%S")

      echo "Extract installer archive."
      tar -xf ${joomla}

      echo "Prepare SQL dumps for import"
      sed -i "s@#_@$TABLE_PREFIX@g" installation/sql/mysql/base.sql installation/sql/mysql/extensions.sql installation/sql/mysql/supports.sql

      echo "Import prepared SQL dumps"
      mysql -h$DB_HOST -u$DB_USER -p$DB_PASSWORD $DB_NAME < installation/sql/mysql/base.sql
      mysql -h$DB_HOST -u$DB_USER -p$DB_PASSWORD $DB_NAME < installation/sql/mysql/extensions.sql
      mysql -h$DB_HOST -u$DB_USER -p$DB_PASSWORD $DB_NAME < installation/sql/mysql/supports.sql

      echo "Create user"
      envsubst -i ${./sql/USER_CREATE.sql} | mysql -h$DB_HOST -u$DB_USER -p$DB_PASSWORD $DB_NAME

      echo "Install config"
      envsubst -i ${./configs/configuration.php} > configuration.php

      mv htaccess.txt .htaccess
      rm -rf installation
      EOF

      chmod 555 $out/bin/${name}.sh
    '');
  });

in pkgs.dockerTools.buildLayeredImage rec {
  name = "docker-registry.intr/apps/joomla";
  tag = "${joomla_version}_latest";

  contents = [ bashInteractive coreutils gnutar gzip entrypoint mariadb.client ];
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
