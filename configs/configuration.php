<?php
class JConfig
{
	/* Site Settings */
	public $offline = false;
	public $offline_message = 'This site is down for maintenance.<br> Please check back again soon.';
	public $display_offline_message = 1;
	public $offline_image = '';
	public $sitename = '${APP_TITLE}';
	public $editor = 'tinymce';
	public $captcha = 0;
	public $list_limit = 20;
	public $access = 1;
	public $frontediting = 1;

	/* Database Settings */
	public $dbtype = 'mysqli';
	public $host = '${DB_HOST}';
	public $user = '${DB_USER}';
	public $password = '${DB_PASSWORD}';
	public $db = '${DB_NAME}';
	public $dbprefix = '${TABLE_PREFIX}_';
	public $dbencryption = 0;
	public $dbsslverifyservercert = false;
	public $dbsslkey = '';
	public $dbsslcert = '';
	public $dbsslca = '';
	public $dbsslcipher = '';

	/* Server Settings */
	public $secret = '${JOOMLA_SECRET}';
	public $gzip = true;
	public $error_reporting = 'default';
	public $helpurl = 'https://help.joomla.org/proxy?keyref=Help{major}{minor}:{keyref}&lang={langcode}';
	public $log_path = '${DOCUMENT_ROOT}/administrator/logs';
	public $tmp_path = '${DOCUMENT_ROOT}/tmp';
	public $live_site = '';
	public $force_ssl = 0;

	/* Locale Settings */
	public $offset = 'UTC';

	/* Session settings */
	public $lifetime = 15;
	public $session_handler = 'database';
	public $shared_session = false;
	public $session_memcached_server_host = 'localhost';
	public $session_memcached_server_port = 11211;
	public $session_redis_server_host = 'localhost';
	public $session_redis_server_port = 6379;
	public $session_redis_server_db = 0;


	/* Mail Settings */
	public $mailonline = true;
	public $mailer      = 'mail';
	public $mailfrom = '${ADMIN_EMAIL}';
	public $fromname = '${APP_TITLE}';
	public $massmailoff = false;
	public $replyto     = '';
	public $replytoname = '';
	public $sendmail    = '/usr/sbin/sendmail';
	public $smtpauth    = false;
	public $smtpuser    = '';
	public $smtppass    = '';
	public $smtphost    = 'localhost';
	public $smtpsecure = 'none';
	public $smtpport = 25;

	/* Cache Settings */
	public $caching = 0;
	public $cachetime = 15;
	public $cache_handler = 'file';
	public $cache_platformprefix = false;
	public $memcached_persist = true;
	public $memcached_compress = false;
	public $memcached_server_host = 'localhost';
	public $memcached_server_port = 11211;
	public $redis_persist = true;
	public $redis_server_host = 'localhost';
	public $redis_server_port = 6379;
	public $redis_server_auth = '';
	public $redis_server_db = 0;

	/* Proxy Settings */
	public $proxy_enable = false;
	public $proxy_host = '';
	public $proxy_port = '';
	public $proxy_user = '';
	public $proxy_pass = '';

	/* Debug Settings */
	public $debug = false;
	public $debug_lang = false;
	public $debug_lang_const = false;

	/* Meta Settings */
	public $MetaDesc = 'Joomla! - the dynamic portal engine and content management system';
	public $MetaAuthor = true;
	public $MetaVersion = false;
	public $MetaRights = '';
	public $robots = '';
	public $sitename_pagetitles = 0;

	/* SEO Settings */
	public $sef = true;
	public $sef_rewrite = false;
	public $sef_suffix = false;
	public $unicodeslugs = false;

	/* Feed Settings */
	public $feed_limit = 10;
	public $feed_email = 'none';

	/* Cookie Settings */
	public $cookie_domain = '';
	public $cookie_path = '';

	/* Miscellaneous Settings */
	public $asset_id = 1;
}
