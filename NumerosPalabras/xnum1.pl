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
sub Num2De($);

my $sep='';
$sep=' ' if($optctl->{'sep'});

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


my $nSets=11;

my $nSetSize=4;
my $nLimit=10**$nDigits;
&{$::debug}("nDigits:[$nDigits] nLimit:[$nLimit]");

if ($optctl->{'test'}) {
	my @aNums;
	#@aNums= (0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20
	#	,21,29,33,40,49,50,51,66,77,83,99);
	#@aNums= (100,101,202,330,404,505,676,787,898,909);
	#@aNums= (101,21);
	# @aNums= (1000,2001,2023,3034,4045,5056,6767,7878,8989,9090);
	@aNums= (0,1,2,10,11,19,20,21,99,100,101,345,603,840,999
		,1000,1001,2007,3010,9999,10000,10001,10010,10100,11000
		,99999, 100000, 100001
		,123456, 1234567, 2345678, 999999999) ;

	foreach my $n (@aNums) {
		&{$::debug}("n:[%s] words:[%s]", $n, Num2De($n));
		print sprintf("n:[%s] %s\n", $n, Num2De($n));
	}
} else {


for (my $nSet=1; $nSet < $nSets; $nSet+=1) 
{
	my @aNumbers=();
	my $rToWrite={};

	print QF "\n\n### Set $nSet\n\n";
	print AF "\n\n### Set $nSet\n\n";

	for( my $i=0; $i < $nSetSize; $i+=1)
	{
		my $n;
		do { 
			$n = int(rand($nLimit));
		} while ($n < 10);

		my @aPair=($n, Num2De($n));
		push @aNumbers, \@aPair;
		$rToWrite->{$i}=$n;

		print AF sprintf("- %9d *----------> %s\n\n",@aPair);

	}
	&{$::debug}("aNumbers:[%s]", Dumper(\@aNumbers));
	&{$::debug}("rToWrite:[%s]", Dumper($rToWrite));

	my $j;
	for(my $i=0; $i < $nSetSize; $i+=1)
	{
		my $this=$aNumbers[$i]->[0];
		&{$::debug}("i:[$i] this:[%s]", $this);
		
		my @aOthers= keys(%{$rToWrite});
		&{$::debug}("aOthers:[%s]", Dumper(\@aOthers));
		if (scalar(@aOthers) == 1) {
			$j = $aOthers[0];
		} else {
			do { 
				$j = $aOthers[int(rand(scalar(@aOthers)))];
				&{$::debug}("j:[$j]");
			} while($j == $i);
		}
		delete($rToWrite->{$j});

		my $that=$aNumbers[$j]->[0];
		my $words=$aNumbers[$j]->[1];

		&{$::debug}("j:[$j] that:[%s] words:[%s]"
			,$that, $words);

		print QF sprintf("- %9d *          > %s\n\n"
			,$this, $words);

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


sub Num2De($)
{
	my ($num)=@_;
	my $ret='';
	
	&{$::debug}("Num2De( %s )", join(' ', map( (defined($_)?"[$_]":'<undef>'), @_)));

	# Cuerpo de Funcion
	my (%cipher, %hTens);
	%cipher = (	1 => "ein", 2 => "zwei", 3 => "drei"
		,4 => "vier", 5 => "fünf", 6 => "sechs"
		,7 => "sieben",8 => "acht", 9 => "neun"
		,10 => "zehn", 11 => "elf", 12 => "zwölf"
		,13 => "dreizehn", 14 => "veirzehn", 15 => "fünfzehn"
		,16 => "sechzehn", 17 => "siebzehn", 18 => "achzehn"
		,19 => "neunzehn" );
	%hTens = (	1 => "zehn", 2 => "zwanzig",3 => "dreissig"
		,4 => "vierzig", 5 => "fünfzig", 6 => "sechzig"
		,7 => "siebzig", 8 => "achzig", 9 => "neunzig" );

	my ($tens, $hundreds)=('','');

	# (my $tens = $num) =~ s/^.*(\d\d)$/$1/;

	if( $num == 0 ) {
		$ret = "null";
	} elsif( $num == 1 ) {
		$ret = "eins";
	} elsif( $num < 20 ) {
		$ret = $cipher{$num} || "null";
	} elsif( $num < 100 ) {
		my $nRes=$num%10;
		my $nTens=($num-$nRes)/10;
		$ret = (($nRes == 1)? 'ein' : $cipher{$nRes}
				.${sep}."und".${sep} )
			if ($nRes>0);
		$ret.= $hTens{$nTens};
	} elsif( $num < 1000 ) {
		my $nRes=$num%100;
		my $nHund=($num-$nRes)/100;
		$ret = $cipher{$nHund}.${sep}."hundert";
		$ret.= ${sep}.Num2De($nRes)
			if ($nRes>0);
	} elsif( $num < 1000000 ) {
		my $nRes=$num%1000;
		my $nTaus=($num-$nRes)/1000;
		$ret = Num2De($nTaus).${sep} ."tausend";
		$ret.= ${sep}.Num2De($nRes)
			if ($nRes>0);
	} elsif( $num < 1000000000 ) {
		my $nRes=$num%1000000;
		my $nMill=($num-$nRes)/1000000;
		$ret='ein Million';
		$ret=Num2De($nMill).${sep}.'Millionen'
			if ($nMill>1);
		$ret.= ${sep}.Num2De($nRes)
			if ($nRes>0);
	} else {
		$ret=$num;

	}
	
	&{$::debug}("Num2De()->[%s]", $ret);
	return $ret;
}

# /usr/local/share/perl5/Date/Spoken/German.pm
# sub yeartospoken
sub yeartospoken
{
	my $year = shift;
	(my $tens = $year) =~ s/^.*(\d\d)$/$1/;

	my %cipher = (	1 => "ein", 2 => "zwei", 3 => "drei"
		,4 => "vier", 5 => "fünf", 6 => "sechs"
		,7 => "sieben",8 => "acht", 9 => "neun"
		,10 => "zehn", 11 => "elf", 12 => "zwölf"
		,13 => "dreizehn", 14 => "veirzehn", 15 => "fünfzehn"
		,16 => "sechzehn", 17 => "siebzehn", 18 => "achzehn"
		,19 => "neunzehn" );
	my %hTens = (	1 => "zehn", 2 => "zwanzig",3 => "dreissig"
		,4 => "vierzig", 5 => "fünfzig", 6 => "sechzig"
		,7 => "siebzig", 8 => "achzig", 9 => "neunzig" );


	my $hundreds = "";
	if( $year < 10 ) {
		$year = $cipher{$year} || "null";
	} else {
		if( $tens == 0 ) {
			$tens = "";
		} elsif( ($tens % 10) == 0 ) {
			$tens =~ s/(.)(.)/$hTens{$1}/;
		} else {
			if( $tens < 10 ) {
				$tens =~ s/(.)(.)/$cipher{$2}/;
			} else {
				$tens =~ s/(.)(.)/$cipher{"$1$2"} || $cipher{$2}.(($1==1)?$hTens{$1}:"und".$hTens{$1})/e;
			}
		}
		if( $year >= 100 ) {
			($hundreds = $year) =~ s/^(.?.)..$/$1/;
			if( $hundreds >= 20 || $hundreds == 10 ) {
				$hundreds =~ s/(.)(.)/$cipher{$1}."tausend".(($2>0)?$cipher{$2}."hundert":"")/ex;
			} else {
				if( $hundreds > 10 ) {
					$hundreds =~ s/(.)(.)/($cipher{"$1$2"} || $cipher{$2}."zehn")."hundert"/e;
				} else {
					$hundreds = $cipher{$hundreds}."hundert";
				}
			}
		}
	}
	return $hundreds.$tens;
}


