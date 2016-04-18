#
# Makefile -- Runner project / Carreras
#


SOURCE_FILES=Makefile num1.pl
	
PERL_EXE=/usr/bin/perl

.PHONY: all clean bkp chk file


all: hello

hello :
	echo "Hello!."
	
clean:
	rm *.trc
	rm trc/*.*
		
bkp : 
	bak.pl $(SOURCE_FILES)
	
chk:
	clear
	$(PERL_EXE) -c xnum1.pl

file : 
	file *.csv *.trc *.pl
	
x : 
	bak.pl Nummern-*.txt
	-rm Nummern-*.txt
	time ./xnum1.pl --sep --notest --digits=4  --trace	

	
