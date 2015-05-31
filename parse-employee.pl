#!C:\Perl\bin\perl -w

# =============================================================================
#
#  File Name        : parse-employee.pl
#
#  Version          : "@(#) parse-employee.pl"
#
#  Project Name     : 
#
#  Copyright        : 
#
#  Author           : H. Sauermann
#
#  Platform         : Windows7
#
#  Date written     : Mai 2015
#
#  Last Modification: 
#
#  Description      : 
#
#
#
#  Modification History:
#
#  Author          Date        Version         Comment
#  =============== =========== =============== ===============================
#
#  End Modification History
#
# =============================================================================
#

require 5;						# requires Perl version 5 or higher



#############
##
## Includes
##

use strict;
use warnings;
use English;
use File::Basename;
use Getopt::Std;
use vars qw($opt_f $opt_d $opt_h);
use Data::Dumper qw(Dumper);

use XML::Simple qw(:strict);



##############
##
## Constants
##

my $USAGE =
'usage: ' . basename($0) . ' -f<file> [-d] [-h]
       <file>         ::= Data file (in xml-Format)
       [-d]           Debug mode (prints more output)
       [-h]           Print this help.
';

my $VALID_OPTIONS = ("f:dh");

my $TRUE	= 1;
my $FALSE	= 0;

my $DEBUG	= $FALSE;



##############
##
## Variables
##



############################
##
## Function predefinitions
##

sub checkCmdArgs();



#########
##
## main
##

checkCmdArgs();

print( "[DEBUG] CommandLine Parameters are OK ... \n" )		if $DEBUG;
print( "[DEBUG] opt_f: $opt_f \n")							if $DEBUG;

my $file_name = $opt_f;
die( "ERROR: XML-File \"$file_name\" don't exist. \n")		unless -e $file_name;

my $xml_content = XMLin("$file_name",
					KeyAttr => { server => 'name' },
					ForceArray => [ 'server', 'address' ]
				);
print("[DEBUG] XML-Content:\n", Dumper($xml_content))		if $DEBUG;





exit 0;



#########################
##
## Function definitions
##

#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#
# Sub:				checkCmdArgs
# Parameters:		none
# Return Value:		none
# Comment:			checks the command line arguments
#
sub checkCmdArgs() {
  my @_argv = @ARGV;

  die( "ERROR: Missing Parameter(s) \n", $USAGE )						unless @ARGV;
  die( "ERROR: Invalid Option(s) or missing argument(s) \n", $USAGE )	unless getopts( $VALID_OPTIONS );

  print( "$USAGE" ), exit(0)											if defined $opt_h;

  $DEBUG = $TRUE														if defined $opt_d;
  print("[DEBUG] CommandLine-Arguments:\n", Dumper \@_argv)				if defined $opt_d;

  die( "ERROR: Unknown argument(s): @ARGV \n", $USAGE )					if @ARGV;

  die( "ERROR: Option -f is missing. \n", $USAGE )						unless defined $opt_f;
  $opt_f = lc( $opt_f );
}



# End of File
