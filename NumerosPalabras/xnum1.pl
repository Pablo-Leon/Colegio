#!/usr/bin/perl -w

=head1 		Copyright SQL*TECHNOLOGY 2016

=head1 NOMBRE

xnum1.pl - 

=head1 SINOPSIS

   xnum1.pl [switches]
      --help         Obtener ayuda
      --debug        Mostrar mensajes de debug (STDERR)
      --trace        Guardar mensajes de debug en xnum1.pl.trc
      --sqltech=dir  Directorio de herramientas (SQLTECHHOME)

=head1 DESCRIPCION


=head1 PARAMETROS


=head1 OBSERVACIONES

=head1 VARIABLES

=head1 PROGRAMAS ASOCIADOS

=head1 RCS

 	$Name$
	$Source$
 	$Id$

=cut

use strict;
use warnings;
use English;

# use strict 'refs';
use Data::Dumper;
use Getopt::Long ();

use utf8;

require 'lib_buchstab.pl';



sub help () {
	my ($pack, $file, $line)=caller();
	system('perldoc -t '.$file);
	exit 1;
}

my ($program)=$0; $program=~s/^.*\/([^\/]+)$/$1/;
	
#
# Recibir parametros
#

my $optctl = {
	'sep' => '' 
	,'test' => '' 
	,'digits' => 4 
};

Getopt::Long::GetOptions($optctl,
	 '--help'
	,'--debug'
	,'--trace'
	,'sep!'
	,'--digits=i'
	,'test!'
	) || help();


if ( defined $optctl->{'help'} ) {
    help();
}

if ( defined $optctl->{'sqltech'} ) {
    $ENV{'SQLTECHHOME'}=$optctl->{'sqltech'};
}

die 'Environment Variable SQLTECHHOME is undefined'
	unless defined $ENV{'SQLTECHHOME'} ;

require $ENV{'SQLTECHHOME'}.'/product/sqltlib/lib_init.pl';

#
# Debug
#
{
my $sDbgCurrentFile='';

$::debug=sub { 1; };
if ( $optctl->{'debug'} ) 
{
	$::debug=sub { my ( $fmt )=shift; printf(STDERR "DBG/${program}: ".$fmt."\n",@_); 1; };
	&{$::debug}("Debug activado");
	$::debugf=1;
}

$optctl->{'trace'} = 1
	if (!defined($optctl->{'debug'}));
if ( $optctl->{'trace'} ) 
{
   # open TRC,  ">", "${program}.trc";
   open TRC,  ">:utf8", "${program}.trc";
	select(TRC); $OUTPUT_AUTOFLUSH=1; select(STDOUT);
	$::debug=sub {
			my ( $fmt )=shift;
			my ($package, $filename, $line) = caller;
			if ("$package:$filename" ne $sDbgCurrentFile)
			{
				print TRC sprintf("En %s:%s\n",$package,$filename);
				$sDbgCurrentFile="$package:$filename";
			}
			print TRC sprintf("[$line]: $fmt\n",@_);
			1;
		};
	&{$::debug}("Debug activado");
	$::debugf=1;
}
}


#
# Init
#

$|=1; # $OUTPUT_AUTOFLUSH=1

my ($rc);

#
# Params
#


#
# Init
#


#
# Body
#

# Test_Shuffle();

sub Sep();
sub SepSep($);

SepSep('~');

print "[", Sep(), "]", "\n"; 

#
# Close
#



close TRC
   if($optctl->{'trace'});

exit;
###############################################################################

sub Funcion
{
	my ($sParam1, $sParam2)=@_;
	my $ret='';
	
	&{$::debug}("Funcion( %s )", join(' ', map( (defined($_)?"[$_]":'<undef>'), @_)));

	# Cuerpo de Funcion
	
	&{$::debug}("Funcion()->[%s]", $ret);
	return $ret;
}

{
my $sSep=' ';

sub Sep() { return $sSep; }
sub SepSep($) { return $sSep=$_[0]; }

}


#####
# EOF
#####

