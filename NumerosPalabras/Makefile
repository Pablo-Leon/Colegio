#
# Makefile -- Runner project / Carreras
#


SOURCE_FILES=Makefile BuchstabierenZahlen.pl
X_FILES=xnum1.pl
	
PERL_EXE=/usr/bin/perl

.PHONY: all clean bkp chk file


all: Nummen

hello :
	echo "Hello!."
	
clean:
	rm *.trc
	rm trc/*.*
		
bkp : 
	bak.pl $(SOURCE_FILES)
	bak.pl $(X_FILES)
	
chk:
	clear
	$(PERL_EXE) -c xnum1.pl
	$(PERL_EXE) -c BuchstabierenZahlen.pl

file : 
	file *.csv *.trc *.pl

Nummen : 
	bak.pl Nummern-*.txt
	-rm Nummern-*.txt
	time ./BuchstabierenZahlen.pl --sep --notest --digits=3
	
test : 
	bak.pl Nummern-*.txt
	-rm Nummern-*.txt
	time ./BuchstabierenZahlen.pl --sep --test --digits=9
	
x : 
	clear
	time ./xnum1.pl --trace	

	
