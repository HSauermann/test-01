#!C:\Perl\bin\perl -w

# =============================================================================
#
#  File Name        : parse_employee.pl
#
#  Version          : "@(#) parse_employee.pl"
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
use Data::Dumper qw(Dumper);

use English;
use File::Basename;
use Getopt::Std;
use vars qw($opt_f $opt_d $opt_h);



##############
##
## Constants
##

my $USAGE =
'usage: ' . basename($0) . ' -f<file> -p<project_list> [-d] [-h]
       <file>         ::= Data file (in xml-Format)
       [-d]           Debug mode (no commands will be execute)
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

print( "CommandLine Parameters are OK ... \n" );


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
  print ("[DEBUG] CommandLine-Arguments:\n", Dumper \@_argv)			if defined $opt_d;

  die( "ERROR: Unknown argument(s): @ARGV \n", $USAGE )					if @ARGV;

  die( "ERROR: Option -f is missing. \n", $USAGE )						unless defined $opt_f;
  $opt_f = lc( $opt_f );
}



# End of File
