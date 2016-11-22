unit class CGI-Utils-Template;

# for testing, provides %*ENV;
use CGI-Utils-TEST-ENV;

my $debug = 1;

# methods from Perl 5 CGI;

#### Method: server-name
# Return the name of the server
####
method server-name {
    state %*ENV = get-env(); # need for every method using %*ENV
    return %*ENV<SERVER_NAME> || 'localhost';
} # server-name

#### Method: http
# Return the value of an HTTP variable, or
# the list of variables if none provided
####
method http($parameter is copy) {
    state %*ENV = get-env(); # need for every method using %*ENV
    say "DEBUG1: \$parameter => '$parameter'" if $debug;
    if $parameter {
	say "  DEBUG2: \$parameter => '$parameter'" if $debug;
        $parameter .= trans( ['-', 'a'..'z'] => ['_', 'A'..'Z']);
	say "    DEBUG3: \$parameter => '$parameter'" if $debug;
        if $parameter ~~ /^ HTTP [ '_' \w+]? $/ {
	    say "      DEBUG4: \$parameter => '$parameter'" if $debug;
	    unless %*ENV{$parameter}:exists {
		return "UNKNOWN param '$parameter'";
	    }
	    return %*ENV{$parameter};
        }
	else {
	    say "    DEBUG5: \$parameter => 'HTTP_$parameter'" if $debug;
            return %*ENV{$parameter};
	}
    }

    # returning a list
    return grep { /^ HTTP / }, %*ENV.keys;
} # http

#### Method: https
# Return the value of HTTPS, or
# the value of an HTTPS variable, or
# the list of variables
####
method https(:$parameter is copy) {
    state %*ENV = get-env(); # need for every method using %*ENV
    say "DEBUG1: \$parameter => '$parameter'" if $debug;
    if $parameter {
	say "  DEBUG2: \$parameter => '$parameter'" if $debug;
        $parameter .= trans( ['-', 'a'..'z'] => ['_', 'A'..'Z']);
	say "    DEBUG3: \$parameter => '$parameter'" if $debug;
        if $parameter ~~ /^ HTTPS [_\w+]? $/ {
	    say "      DEBUG4: \$parameter => '$parameter'" if $debug;
	    unless %*ENV{$parameter}:exists {
		return "UNKNOWN param '$parameter'";
	    }
            return %*ENV{$parameter};
        }
        return %*ENV{"SSL_$parameter"};
    }

    # returning a list
    return grep { /^ HTTPS / }, %*ENV.keys;
} # https

method ssl(:$parameter is copy) {
    state %*ENV = get-env(); # need for every method using %*ENV
    say "DEBUG1: \$parameter => '$parameter'" if $debug;
    if $parameter {
	say "  DEBUG2: \$parameter => '$parameter'" if $debug;
        $parameter .= trans( ['-', 'a'..'z'] => ['_', 'A'..'Z']);
	say "    DEBUG3: \$parameter => '$parameter'" if $debug;
        if $parameter ~~ /^ SSL [_\w+]? $/ {
	    say "      DEBUG4: \$parameter => '$parameter'" if $debug;
	    unless %*ENV{$parameter}:exists {
		return "UNKNOWN param '$parameter'";
	    }
            return %*ENV{$parameter};
        }
        return %*ENV{"SSL_$parameter"};
    }

    # returning a list
    return grep { /^ SSL / }, %*ENV.keys;
} # ssl

#### Method: virtual-host
# Return the name of the virtual-host, which
# is not always the same as the server
######
method virtual-host() {
    my $vh = .http('x_forwarded_host') || .http('host') || .server-name();
    $vh ~~ s/\:\d+$//;           # get rid of port number
    return $vh;
} # virtual-host

#### Method: remote-host
# Return the name of the remote host, or its IP
# address if unavailable.  If this variable isn't
# defined, it returns "localhost" for debugging
# purposes.
####
method remote-host {
    state %*ENV = get-env(); # need for every method using %*ENV
    return %*ENV<REMOTE_HOST> || %*ENV<REMOTE_ADDR>
    || 'localhost';
} # remote-host

#### Method: remote_addr
# Return the IP addr of the remote host.
####
method remote-addr {
    state %*ENV = get-env(); # need for every method using %*ENV
    return %*ENV<REMOTE_ADDR> || '127.0.0.1';
} # remote-addr

#### Method: referer
# Return the HTTP_REFERER: useful for generating
# a GO BACK button.
####
method referer() {
    return .http('referer');
} # referer

#### Method: server-software
# Return the name of the server software
####
method server-software {
    state %*ENV = get-env(); # need for every method using %*ENV
    return %*ENV<SERVER_SOFTWARE> || 'cmdline';
} # server-software

#### Method: virtual-port
# Return the server port, taking virtual hosts into account
####
method virtual-port {
    my $vh = .http('x_forwarded_host') || .http('host');
    if $vh {
        if $vh ~~ /\: (\d+) $/ {
	    return +$0;
	}
	else {
	    return .protocol() eq 'https' ?? 443 !! 80;
	}
    }
    else {
        return .server-port();
    }
} # virtual-port

#### Method: server-port
# Return the tcp/ip port the server is running on
####
method server-port() {
    state %*ENV = get-env(); # need for every method using %*ENV
    return %*ENV<SERVER_PORT> || 80; # for debugging
} # server-port

#### Method: server-protocol
# Return the protocol (usually HTTP/1.0)
####
method server-protocol {
    state %*ENV = get-env(); # need for every method using %*ENV
    return %*ENV<SERVER_PROTOCOL> || 'HTTP/1.0'; # for debugging
} # server-protocol

#### Method: protocol
# Return the protocol (http or https currently)
####
method protocol() {
    return 'https' if uc(.https()) eq 'ON';
    return 'https' if .server-port() == 443;
    my $prot = .server-protocol();
    my ($protocol,$version) = split '/', $prot;
    $protocol .= lc;
    return $protocol;
    # return "\L{$protocol}\E"; # \L and \E ???: \L - Lowercase till \E
} # protocol

#### Method: remote-ident
# Return the identity of the remote user
# (but only if his host is running identd)
####
method remote-ident() {
    state %*ENV = get-env(); # need for every method using %*ENV
    return %*ENV<REMOTE_IDENT> ?? %*ENV<REMOTE_IDENT> !! '';
} # remote-ident

#### Method: auth-type
# Return the type of use verification/authorization in use, if any.
####
method auth-type {
    state %*ENV = get-env(); # need for every method using %*ENV
    return %*ENV<AUTH_TYPE> ?? %*ENV<AUTH_TYPE> !! '';
} # auth-type

#### Method: remote-user
# Return the authorization name used for user
# verification.
####
method remote-user {
    state %*ENV = get-env(); # need for every method using %*ENV
    return %*ENV<REMOTE_USER> ?? %*ENV<REMOTE_USER> !! '';
} # remote-user

#### Method: user-name
# Try to return the remote user's name by hook or by
# crook
####
method user-name() {
    state %*ENV = get-env(); # need for every method using %*ENV
    return .http('from') || %*ENV<REMOTE_IDENT> || %*ENV<REMOTE_USER>;
} # user-name
