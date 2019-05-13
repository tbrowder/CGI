unit module CGI::HttpVars;


our %vars is export = %(
    CONTEXT_DOCUMENT_ROOT => '/home/web-server-common/cgi-bin-cmn/',
    CONTEXT_PREFIX        => '/cgi-bin-cmn/',
    DOCUMENT_ROOT         => '/home/web-server/niceville.pm.org/public',
    GATEWAY_INTERFACE     => 'CGI/1.1',
    HTTP_CONNECTION       => 'close',
    HTTP_HOST             => 'niceville.pm.org',
    LD_LIBRARY_PATH       => '/usr/local/apache2/lib',
    PATH                  => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
    PWD                   => '/home/web-server-common/cgi-bin-cmn',
    QUERY_STRING          => '',
    REMOTE_ADDR           => '68.1.63.241',
    REMOTE_PORT           => '58826',
    REQUEST_METHOD        => 'GET',
    REQUEST_SCHEME        => 'http',
    REQUEST_URI           => '/cgi-bin-cmn/show-env.cgi',
    SCRIPT_FILENAME       => '/home/web-server-common/cgi-bin-cmn/show-env.cgi',
    SCRIPT_NAME           => '/cgi-bin-cmn/show-env.cgi',
    SERVER_ADDR           => '142.54.186.2',
    SERVER_ADMIN          => '[no address given]',
    SERVER_NAME           => 'niceville.pm.org',
    SERVER_PORT           => '80',
    SERVER_PROTOCOL       => 'HTTP/1.1',
    SERVER_SIGNATURE      => '',
    SERVER_SOFTWARE       => 'Apache/2.4.38 (Unix) OpenSSL/1.1.0j',
);

