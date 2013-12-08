#!/usr/bin/perl

#------------------------------------------------
# Utility takes http requests as an input. Once
# it finds out the iVysilani request it starts
# the downloading process on background.
#
# The usage could be done in following manner
#
# $ sudo tcpflow -c | ./capture.pl 
#
# Note tcpflow needs to be run with root 
# permissions.
#------------------------------------------------
use strict;
use warnings;
use LWP::Simple;
use XML::LibXML;

while (<>) {
	my $line=$_;
	if ($line =~ /GET \/ls\/ClientLink/ && !($line =~ /suppress/)) {
		$line =~ s/^[^-]*-0*(\d*)\.0*(\d*)\.0*(\d*)\.0*(\d*).*GET (.*) HTTP.*/http:\/\/$1.$2.$3.$4$5&suppress/;	
		
		print "Getting URL: $line";
		my $xml = get($line);
		my $dom = XML::LibXML->load_xml(string => $xml);
		
		#print $dom;

		#getting title
		my $titleNode = $dom->find('//Gemius/Param[@name=\'NAZEV\']/@value');
		if ($titleNode->size == 0) {
			die "Unable to get title tag from xml file";
		}
		my $title = $titleNode->get_node(1)->string_value();
		print "Title: $title\n";
	
		#gettin base
		my $baseNode = $dom->find('//switchItem[1]/@base');
		if ($baseNode->size == 0) {
			die "Unable to find rtmp base in xml file";
		} 	
		my $base = $baseNode->get_node(1)->string_value();
		
		#getting src (assumption - first is the best quality)
		my $srcNode = $dom->find('//switchItem/video/@src');
		if ($srcNode->size == 0) {
			die "Unable to get src video tag from xml file";
		}
		my $src = $srcNode->get_node(1)->string_value();
	
		my $rtmpUrl = $base."/".$src;
		$title =~ s/[^a-zA-Z0-9-]/_/g;
		$title = $title.".flv";
	
		my $cmd = "rtmpdump -r \"$rtmpUrl\" -o $title --live > /dev/null 2>&1 &";
		print "Running downloading on background: $cmd\n";
		print "----------------------------------------------\n";
		system($cmd);

	}	
}

