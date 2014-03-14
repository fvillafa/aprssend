#! /usr/bin/perl

use IO::Socket;

$aprsServer = "finland.aprs2.net";
$port = 14580;
$callsign = "HA2NON-1";
$pass = "11111"; # can be computed with aprspass
$coord = "4738.48N/01818.15Ey";
$altInFeet = 502;
$comment = "HA2NON's QTH - www.nonoo.hu";

my $sock = new IO::Socket::INET (
				    PeerAddr => $aprsServer,
				    PeerPort => $port,
				    Proto => 'tcp'
				);
die( "Could not create socket: $!\n" ) unless $sock;

$sock->recv( $recv_data,1024 );

print $sock "user $callsign pass $pass ver\n";

$sock->recv( $recv_data,1024 );
if( $recv_data !~ /^# logresp $callsign verified.*/ )
{
    die( "Error: invalid response from server: $recv_data\n" );
}

($sec,$min,$hour,$mday,$mon,$year,$wday,$yday) = gmtime();
$message = sprintf( "%s>APRS,TCPIP*:@%02d%02d%02dz%s/A=%06d %s\n",
    $callsign,$hour,$min,$sec,$coord,$altInFeet,$comment );
print $sock $message;
close( $sock );

print "beacon sent.\n"
