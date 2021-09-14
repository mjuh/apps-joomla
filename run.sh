#!/usr/bin/env bash

nix build .#joomla-4-0
docker load < result

docker run --rm --name joomla-installer \
	--env 'ADMIN_USERNAME'='u213147' \
	--env 'DB_HOST'='78.108.80.76' \
	--env 'DB_USER'='u213147_joomla' \
	--env 'DOMAIN_NAME'='joomla.mj.rezvov.ru' \
	--env 'ADMIN_EMAIL'='rezvov@majordomo.ru' \
	--env 'ADMIN_PASSWORD'='ur7VzLwLmn' \
	--env 'DB_PASSWORD'='13664376' \
	--env 'APP_TITLE'='joomla.mj.rezvov.ru' \
	--env 'DB_NAME'='b213147_joomla' \
	--env 'PROTOCOL'='http' \
	docker-registry.intr/apps/joomla:4.0.3_latest
