##!/usr/bin/perl -w

=head1 		Copyright SQL*TECHNOLOGY 2016

=head1 NOMBRE

lib_buchstab.pl - 

=head1 SINOPSIS


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

use utf8;

use strict;
use warnings;
use English;

# use strict 'refs';
use Data::Dumper;
use Getopt::Long ();

sub Num2De($);
sub Test_Num2De();
sub Test_GenNumSeq();
sub GenNumSeq($$);
sub Test_Shuffle();
sub Shuffle(@);
sub Sep();
sub SetSep($);



sub LibFuncion
{
	my ($sParam1, $sParam2)=@_;
	my $ret='';
	
	&{$::debug}("LibFuncion( %s )", join(' ', map( (defined($_)?"[$_]":'<undef>'), @_)));

	# Cuerpo de Funcion
	
	&{$::debug}("LibFuncion()->[%s]", $ret);
	return $ret;
}

{
my $sSep=' ';

sub Sep() { return $sSep; }
sub SetSep($) { return $sSep=$_[0]; }

}


sub Test_GenNumSeq()
{
	my ($dummy)=@_;
	my $ret='';
	
	&{$::debug}("Test_GenNumSeq( %s )", join(' ', map( (defined($_)?"[$_]":'<undef>'), @_)));

	# Cuerpo de Funcion
	my @a;
	@a = GenNumSeq(1,1);
	&{$::debug}("a: [%s]", Dumper(\@a));

	@a = GenNumSeq(1,4);
	&{$::debug}("a: [%s]", Dumper(\@a));

	@a = GenNumSeq(2,4);
	&{$::debug}("a: [%s]", Dumper(\@a));

	@a = GenNumSeq(3,4);
	&{$::debug}("a: [%s]", Dumper(\@a));

	@a = GenNumSeq(3,6);
	&{$::debug}("a: [%s]", Dumper(\@a));
	
	@a = GenNumSeq(4,6);
	&{$::debug}("a: [%s]", Dumper(\@a));
	
	&{$::debug}("Test_GenNumSeq()->[%s]", $ret);
	return $ret;
}

sub GenNumSeq($$)
{
	my ($nNumLen, $nSeqLen)=@_;
	my $ret='';
	
	&{$::debug}("GenNumSeq( %s )", join(' ', map( (defined($_)?"[$_]":'<undef>'), @_)));

	# Cuerpo de Funcion
	my $nLimit=10**$nNumLen;
	my $sNumber = sprintf("%0*d", $nNumLen, int(rand($nLimit)));
	&{$::debug}("sNumber:[%s]", $sNumber);
	
	my $rhNum={ $sNumber => 1};

	my ($i, $sOldDigit, $sNewDigit, $nPos);
	while (scalar(keys(%{$rhNum})) < $nSeqLen) {
		$nPos = int(rand($nNumLen));
		$sOldDigit=substr($sNumber, $nPos, 1);
		do {
			$sNewDigit = '' . int(rand(10));
		} while ($sNewDigit eq $sOldDigit);
		substr($sNumber, $nPos, 1)=$sNewDigit;
		&{$::debug}("sNumber:[%s]", $sNumber);
		$rhNum->{$sNumber}=1;
	}
	
	my @aSeq=keys(%{$rhNum});
	
	&{$::debug}("GenNumSeq()->[%s]", \@aSeq);
	return @aSeq;
}


sub Test_Num2De()
{
	my ($dummy)=@_;
	my $ret='';
	
	&{$::debug}("Test_Num2De( %s )", join(' ', map( (defined($_)?"[$_]":'<undef>'), @_)));

	# Cuerpo de Funcion
	my @aNums;
	#@aNums= (0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20
	#	,21,29,33,40,49,50,51,66,77,83,99);
	#@aNums= (100,101,202,330,404,505,676,787,898,909);
	#@aNums= (101,21);
	# @aNums= (1000,2001,2023,3034,4045,5056,6767,7878,8989,9090);
	@aNums= (0,1,2,10,11,19,20
		,21,99,100,101,345,421,603,840,999
		,1000,1001,2007,3010,9999,10000,10001,10010,10100,11000
		,99999, 100000, 100001
		,123456, 1234567, 2345678, 999999999
		) ;

	foreach my $n (@aNums) {
		&{$::debug}("n:[%s] words:[%s]", $n, Num2De($n));
		print sprintf("n:[%s] %s\n", $n, Num2De($n));
	}
	
	&{$::debug}("Test_Num2De()->[%s]", $ret);
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
		$ret = ((($nRes == 1)? 'ein' : $cipher{$nRes})
				.Sep()."und".Sep() )
			if ($nRes>0);
		$ret.= $hTens{$nTens};
	} elsif( $num < 1000 ) {
		my $nRes=$num%100;
		my $nHund=($num-$nRes)/100;
		$ret = $cipher{$nHund}.Sep()."hundert";
		$ret.= Sep().Num2De($nRes)
			if ($nRes>0);
	} elsif( $num < 1000000 ) {
		my $nRes=$num%1000;
		my $nTaus=($num-$nRes)/1000;
		$ret = Num2De($nTaus).Sep() ."tausend";
		$ret.= Sep().Num2De($nRes)
			if ($nRes>0);
	} elsif( $num < 1000000000 ) {
		my $nRes=$num%1000000;
		my $nMill=($num-$nRes)/1000000;
		$ret='ein Million';
		$ret=Num2De($nMill).Sep().'Millionen'
			if ($nMill>1);
		$ret.= Sep().Num2De($nRes)
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

sub Test_Shuffle()
{
	my ($dummy)=@_;
	my $ret='';
	
	&{$::debug}("Funcion( %s )", join(' ', map( (defined($_)?"[$_]":'<undef>'), @_)));

	# Cuerpo de Funcion
	my @a=(1,2,3,4,5,6,7,8,9,10);
	
	my @b;
	@b = Shuffle(@a);
	&{$::debug}("b: %s", Dumper(\@b));
	@b = Shuffle(@a);
	&{$::debug}("b: %s", Dumper(\@b));
	@b = Shuffle(@a);
	&{$::debug}("b: %s", Dumper(\@b));
	
	&{$::debug}("Funcion()->[%s]", $ret);
	return $ret;
}


sub Shuffle(@)
{
	&{$::debug}("Shuffle( %s )", join(' ', map( (defined($_)?"[$_]":'<undef>'), @_)));

	# Cuerpo de Funcion
	my %h=();
	foreach my $n (@_) { $h{rand()}=$n };
	my @a=();
	foreach my $k (sort(keys(%h))) { push @a, $h{$k} };
	
	&{$::debug}("Shuffle()->[%s]", \@a);
	return @a;
}

1;

