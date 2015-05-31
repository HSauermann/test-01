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
use Dumpvalue;
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

my $file_name;
my $xml_content;
my $_department_key;
my $_department_name;
my $_department_hash;
my $_employee_key;
my $_employee_hash;
my $_id_key;
my $_id_hash;
my $_family_name;
my $_first_name;
my $_role_key;
my $_role_name;



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
print( "[DEBUG] opt_f: $opt_f \n" )							if $DEBUG;

$file_name = $opt_f;
die( "ERROR: XML-File \"$file_name\" don't exist. \n" )		unless -e $file_name;


# prüfen, ob xml-Format ...
#use XML::LibXML;
#my $schema_file = 'employees.xsd';
#my $document    = 'employees.xml';
#my $schema = XML::LibXML::Schema->new(location => $schema_file);
#my $parser = XML::LibXML->new;
#my $doc    = $parser->parse_file($document);
#eval { $schema->validate($doc) };
#die $@ if $@;
#print "$document validated successfully\n";
#print( "[DEBUG] End of program (exit-code: $?) \n" );
#exit;




$xml_content = XMLin( "$file_name",
				KeyAttr => { department => 'name', employee => 'id' },
				ForceArray => 1,
				ForceArray => [ 'department', 'employee' ],
			);

print( "[DEBUG] XML-Content-View-1:\n", Dumper( $xml_content ) )		if $DEBUG;
print( "[DEBUG] XML-Content-View-2:\n" )								if $DEBUG;
Dumpvalue->new->dumpValue( $xml_content )								if $DEBUG;


# processing ...
while ( (my ($_key, $_val)) = each %$xml_content ) {
	if ("$_key" eq "department" ) {
		# here we are on the department section ...
		$_department_key = $_key;
		$_department_hash = $_val;
		print( "DEPARTMENT_KEY:$_department_key \n" )					if $DEBUG;

		my $_cnt = 1;
		print( "Following employees would be found in the file \"$file_name\": \n\n" )		if $_cnt == 1;
		
		while ( (my ($_key, $_val)) = each %$_department_hash ) {
			# --- Departments
			print( "Key: $_key ### Value: $_val\n" )					if $DEBUG;
			$_department_name = $_key;
			print( "DEPARTMENT_NAME:$_department_name \n" )				if $DEBUG;

			while ( (my ($_key, $_val)) = each %$_val ) {
				$_employee_key = $_key;
				$_employee_hash = $_val;
				print( "EMPLOYEE_KEY:$_employee_key \n" )				if $DEBUG;
			
				while ( (my ($_key, $_val)) = each %$_employee_hash ) {
					$_id_key = $_key;
					$_id_hash = $_val;
					print( "Key: $_key ### Value: $_val\n" )			if $DEBUG;
					print( "ID_KEY:$_id_key \n" )						if $DEBUG;

					while ( (my ($_key, $_val)) = each %$_id_hash ) {
						print( "Key: $_key ### Value: $_val\n" )		if $DEBUG;
						
						if ( "$_key" eq "role" ) {
							$_role_key = $_key;
							$_role_name = $_val;
						}
						elsif ( "$_key" eq "first_name" ) {
							$_first_name = $_val;
						}
						elsif ( "$_key" eq "family_name" ) {
							$_family_name = $_val;
						}
						else {
							# do nothing
						}
						
					}
					
					my $str = "[$_cnt] $_first_name $_family_name ($_employee_key id $_id_key) works in the \"$_department_name\" $_department_key as $_role_name.";
					print( "$str \n" );
					$_cnt++;					
				}
			}
			
		}
	}
}





print( "[DEBUG] End of program (exit-code: $?) \n" )		if $DEBUG;
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
  print( "[DEBUG] CommandLine-Arguments:\n", Dumper \@_argv )			if defined $opt_d;

  die( "ERROR: Unknown argument(s): @ARGV \n", $USAGE )					if @ARGV;

  die( "ERROR: Option -f is missing. \n", $USAGE )						unless defined $opt_f;
  $opt_f = lc( $opt_f );
}



# End of File
