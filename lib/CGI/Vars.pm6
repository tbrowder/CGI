unit module CGI::Vars;

# the MUST request meta-vars from RFC 3875
our %req-meta-vars is export = set <
GATEWAY_INTERFACE
REMOTE_ADDR
REQUEST_METHOD
SCRIPT_NAME
SERVER_NAME
SERVER_PORT
SERVER_PROTOCOL
SERVER_SOFTWARE
>;

# MUST vars IIF there is a body
our %req-body-meta-vars is export = set <
CONTENT_LENGTH
CONTENT_TYPE
>;

# ALL BELOW MUST BE TAKEN CARE OF FOR TOTAL HANDLING
our %req-meta-vars-should is export = set <
PATH_INFO
QUERY_STRING
PATH_TRANSLATED
REMOTE_HOST
REMOTE_USER
>;


our %other-meta-vars is export = set <
REMOTE_IDENT
AUTH_TYPE
>;

# SHOULD VARS
our %protocol-specific-meta-vars is export = set <
HTTP_ACCEPT
HTTP_ACCEPT_ENCODING
HTTP_ACCEPT_LANGUAGE
HTTP_CONNECTION
HTTP_COOKIE
HTTP_FORWARDED
HTTP_HOST
HTTP_PROXY_CONNECTION
HTTP_REFERER
HTTP_UPGRADE_INSECURE_REQUESTS
HTTP_USER_AGENT
>;

our %other-vars is export = set <
API_VERSION
CONTEXT_DOCUMENT_ROOT
CONTEXT_PREFIX
DATE_GMT
DATE_LOCAL
DOCUMENT_NAME
DOCUMENT_ROOT
DOCUMENT_URI
GET
INCLUDED
IS_SUBREQ
LAST_MODIFIED
REMOTE_PORT
REQUEST_FILENAME
REQUEST_SCHEME
REQUEST_URI
SCRIPT_FILENAME
SERVER_ADDR
SERVER_ADMIN
SERVER_SIGNATURE
THE_REQUEST
TIME
TIME_DAY
TIME_HOUR
TIME_MIN
TIME_MON
TIME_SEC
TIME_WDAY
TIME_YEAR
USER_NAME
>;

our %tls-server-vars is export = set <
HTTPS
SSL_CIPHER
SSL_CIPHER_ALGKEYSIZE
SSL_CIPHER_EXPORT
SSL_CIPHER_USEKEYSIZE
SSL_COMPRESS_METHOD
SSL_PROTOCOL
SSL_SECURE_RENEG
SSL_SERVER_A_KEY
SSL_SERVER_A_SIG
SSL_SERVER_I_DN
SSL_SERVER_M_SERIAL
SSL_SERVER_M_VERSION
SSL_SERVER_S_DN
SSL_SERVER_V_END
SSL_SERVER_V_START
SSL_SESSION_ID
SSL_SESSION_RESUMED
SSL_TLS_SNI
SSL_VERSION_INTERFACE
SSL_VERSION_LIBRARY
>;
