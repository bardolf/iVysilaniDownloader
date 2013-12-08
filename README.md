iVysilaniDownloader
===================
Script for downloading from http://www.ceskatelevize.cz/ivysilani

Utility takes http requests as an input. Once it finds out the iVysilani vidoe request 
it starts the downloading process on background. The usage could be done in following manner

Usage:
1. be sure you have installed rtmpdump, tcpflow packages
	apt-get install rtmpdump
	apt-get install tcpflow
2. run the the following commandline 
	sudo tcpflow -c | ./capture.pl 
   Note tcpflow needs root permisions.
3. browse in any browser you like for the video on http://www.ceskatelevize.cz/ivysilani/
4. Let the process run until all videos downloaded
