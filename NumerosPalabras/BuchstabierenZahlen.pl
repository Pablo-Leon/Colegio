#!/usr/bin/perl -w

=head1 		Copyright SQL*TECHNOLOGY 2016

=head1 NOMBRE

BuchstabierenZahlen.pl - 

=head1 SINOPSIS

   BuchstabierenZahlen.pl [switches]
      --help         Obtener ayuda
      --debug        Mostrar mensajes de debug (STDERR)
      --trace        Guardar mensajes de debug en BuchstabierenZahlen.pl.trc
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
	,'digits' => 3 
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

SetSep(' ') if($optctl->{'sep'});

my $nDigits=$optctl->{'digits'};

die "Parametro --digitos:[$nDigits] supre máximo de 9."
	if($nDigits >9);

#
# Body
#



#
# Init
#

# use Date::Spoken::German;
# use Lingua::EN::Numbers qw(num2en num2en_ordinal);

# my $x = 234;
# my $y = 54;
# print "You have ", num2en($x), " things to do today!\n";
# print "You will stop caring after the ", num2en_ordinal($y), ".\n";

#
#
#

print "\n\n";
 
# print timetospoken( time() ), "\n";
# print datetospoken( 1, 1, 9086 ), "\n";

my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) =
                                                localtime(time);
$mon+=1;
$year+=1900;

my $sTimestamp=sprintf("%02d%02d%02d-%02d%02d"
	,$year%100, $mon, $mday, $hour, $min  );
$sTimestamp=sprintf("%02d%02d%02d-%02d"
	,$year%100, $mon, $mday, $hour  );
&{$::debug}("sTimestamp:[$sTimestamp]");

my $sQFile=sprintf("Nummern-%s-q.txt", $sTimestamp);
open QF, ">:utf8", $sQFile
	or die "No se pudo abrir archivo [$sQFile] para escritura. $!";
print QF "### Nummern -- Preguntas ($sTimestamp)\n\n";

my $sAFile=sprintf("Nummern-%s-a.txt", $sTimestamp);
open AF, ">:utf8", $sAFile
	or die "No se pudo abrir archivo [$sAFile] para escritura. $!";
print AF "### Nummern -- Respuestas ($sTimestamp)\n\n";


my $nSets=12;

my $nSetSize=6;
my $nLimit=10**$nDigits;
&{$::debug}("nDigits:[$nDigits] nLimit:[$nLimit]");

if ($optctl->{'test'}) {
	Test_Num2De();
	Test_GenNumSeq();
	Test_Shuffle();
} else {


for (my $nSet=1; $nSet <= $nSets; $nSet+=1) 
{
	print QF "\n\n### Set $nSet\n\n";
	print AF "\n\n### Set $nSet\n\n";

	my @aSeq= GenNumSeq($nDigits, $nSetSize);
	&{$::debug}("aSeq:[%s]", Dumper(\@aSeq));
	my @aShuf=Shuffle(@aSeq);
	&{$::debug}("aShuf:[%s]", Dumper(\@aShuf));

	for (my $i=0; $i < scalar(@aSeq); $i+=1) {
		# print $aSeq[$i], " --- ", $aShuf[$i], "\n";
		my ($this, $that)=(0+$aSeq[$i], 0+$aShuf[$i]);

		print AF sprintf("- %60s *-----> %*d\n\n"
			,Num2De($this), $nDigits, $this );

		print QF sprintf("- %60s *     > %*d\n\n"
			,Num2De($this), $nDigits, $that );
	}

}
}
	

close AF;	
close QF;	

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



