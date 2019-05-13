unit class CGI;

#| The default is to use the local environment which is the normal
#| case for server-side CGI scripts.  However, passing another
#| environment variable into the class with new is useful for testing
#| input from another server.
has %.env         = %*ENV;
has $.debug is rw = 0;

# methods from Perl 5 CGI;

#| Method: server-addr
#| Purpose: Return the IP address of the server
method server-addr() {
    return %.env<SERVER_ADDR> || 'localhost';
} # server-name

#| Method: server-name
#| Purpose: Return the name of the server
method server-name() {
    return %.env<SERVER_NAME> || 'localhost';
} # server-name

#| Method: virtual-host
#| Purpose: Return the name of the virtual-host (which is not always
#|          the same as the server)
method virtual-host() {
    my $vh = self.http('x_forwarded_host') || self.http('host') || self.server-name();
    $vh ~~ s/\:\d+$//;           # get rid of port number
    return $vh;
} # virtual-host

#| Method: remote-host
#| Purpose: Return the name of the remote host, or its IP address if
#|          unavailable.  If this variable isn't defined, it returns "localhost"
#|          for debugging purposes.
method remote-host() {
    return %.env<REMOTE_HOST> || %.env<REMOTE_ADDR>
    || 'localhost';
} # remote-host

#| Method: remote-addr
#| Purpose: Return the IP address of the remote host.
method remote-addr() {
    return %.env<REMOTE_ADDR> || '127.0.0.1';
} # remote-addr

#| Method: referer
#| Purpose: Return the HTTP_REFERER: useful for generating a GO BACK button.
method referer() {
    return .http('referer');
} # referer

#| Method: server-software
#| Purpose: Return the name of the server software
method server-software() {
    return %.env<SERVER_SOFTWARE> || 'cmdline';
} # server-software

#| Method: virtual-port
#| Purpose: Return the server port, taking virtual hosts into account
method virtual-port() {
    my $vh = self.http('x_forwarded_host') || self.http('host');
    if $vh {
        if $vh ~~ /\: (\d+) $/ {
	    return +$0;
	}
	else {
	    return self.protocol() eq 'https' ?? 443 !! 80;
	}
    }
    else {
        return self.server-port();
    }
} # virtual-port

#| Method: server-port
#| Purpose: Return the tcp/ip port the server is running on
method server-port() {
    return %.env<SERVER_PORT> || 80; # for debugging
} # server-port

#| Method: server-protocol
#| Purpose: Return the protocol (usually HTTP/1.0)
method server-protocol {
    return %.env<SERVER_PROTOCOL> || 'HTTP/1.0'; # for debugging
} # server-protocol

#| Method: protocol
#| Purpose: Return the protocol (currently 'http' or 'https')
method protocol() {
    return 'HTTPS' if uc(self.https()) eq 'ON';
    return 'HTTPS' if self.server-port() == 443;
    my $prot = self.server-protocol();
    my ($protocol,$version) = split '/', $prot;
    $protocol .= uc;
    return $protocol;
    # return "\L{$protocol}\E"; # \L and \E ???: \L - Lowercase till \E
} # protocol

#| Method: remote-ident
#| Purpose: Return the identity of the remote user (but only if his or her host is running identd)
method remote-ident() {
    return %.env<REMOTE_IDENT> ?? %.env<REMOTE_IDENT> !! '';
} # remote-ident

#| Method: auth-type
#| Purpose: Return the type of use verification/authorization in use, if any.
method auth-type {
    return %.env<AUTH_TYPE> ?? %.env<AUTH_TYPE> !! '';
} # auth-type

#| Method: remote-user
#| Purpose: Return the authorization name used for user verification.
method remote-user {
    return %.env<REMOTE_USER> ?? %.env<REMOTE_USER> !! '';
} # remote-user

#| Method: user-name
#| Purpose: Try to return the remote user's name by hook or by crook
method user-name() {
    return .http('from') || %.env<REMOTE_IDENT> || %.env<REMOTE_USER>;
} # user-name
#| Method: http
#| Purpose: Return the value of an HTTP variable, or the list of HTTP_*
#|          variables if no argument is provided
method http($param?) {
    my $parameter = $param ?? $param !! '';
    say "DEBUG1: \$parameter => '$parameter'" if $.debug;
    if $parameter {
	say "  DEBUG2: \$parameter => '$parameter'" if $.debug;
        $parameter .= trans( ['-', 'a'..'z'] => ['_', 'A'..'Z']);
	say "    DEBUG3: \$parameter => '$parameter'" if $.debug;
        if $parameter ~~ /^ HTTP [ '_' \w+]? $/ {
	    say "      DEBUG4: \$parameter => '$parameter'" if $.debug;
	    unless %.env{$parameter}:exists {
		return "UNKNOWN param '$parameter'";
	    }
	    return %.env{$parameter};
        }
	else {
	    say "    DEBUG5: \$parameter => 'HTTP_$parameter'" if $.debug;
            return %.env{$parameter};
	}
    }

    # returning a list
    return grep { /^ HTTP_ / }, %.env.keys.sort;
} # http

#| Method: https
#| Purpose: Return the value of HTTPS, or the value of an HTTPS
#|          variable, or the list of HTTPS_* variables if no argument is
#|          provided
method https($param?) {
    my $parameter = $param ?? $param !! '';
    say "DEBUG1: \$parameter => '$parameter'" if $.debug;
    if $parameter {
	say "  DEBUG2: \$parameter => '$parameter'" if $.debug;
        $parameter .= trans( ['-', 'a'..'z'] => ['_', 'A'..'Z']);
	say "    DEBUG3: \$parameter => '$parameter'" if $.debug;
        if $parameter ~~ /^ HTTPS [_\w+]? $/ {
	    say "      DEBUG4: \$parameter => '$parameter'" if $.debug;
	    unless %.env{$parameter}:exists {
		return "UNKNOWN param '$parameter'";
	    }
            return %.env{$parameter};
        }
        return %.env{"SSL_$parameter"};
    }

    # returning a list
    return grep { /^ HTTPS | SSL / }, %.env.keys.sort;
} # https

#| Method: ssl
#| Purpose: Return the value of an SSL variable, or the list of SSL
#|          variables if no argument is provided
method ssl($param?) {
    my $parameter = $param ?? $param !! '';
    say "DEBUG1: \$parameter => '$parameter'" if $.debug;
    if $parameter {
	say "  DEBUG2: \$parameter => '$parameter'" if $.debug;
        $parameter .= trans( ['-', 'a'..'z'] => ['_', 'A'..'Z']);
	say "    DEBUG3: \$parameter => '$parameter'" if $.debug;
        if $parameter ~~ /^ SSL [_\w+]? $/ {
	    say "      DEBUG4: \$parameter => '$parameter'" if $.debug;
	    unless %.env{$parameter}:exists {
		return "UNKNOWN param '$parameter'";
	    }
            return %.env{$parameter};
        }
        return %.env{"SSL_$parameter"};
    }

    # returning a list
    return grep { /^ SSL / }, %.env.keys;
} # ssl
