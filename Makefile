SHELL=		/bin/sh
RM=		/bin/rm
LATEX=		/usr/local/texlive/2013/bin/x86_64-linux/latex
BIBTEX=		/usr/local/texlive/2013/bin/x86_64-linux/bibtex
DVIPS=		/usr/local/texlive/2013/bin/x86_64-linux/dvips
PS2PDF=		/usr/bin/ps2pdf
GS=		/usr/bin/gs

.SUFFIXES:      .tex .dvi .eps .ps .pdf

MAIN = thesis

EMAIN = ethesis

FIGDIR = figures

FIGURES =	$(FIGDIR)/NTU.eps

FILES = thesis.tex thesis.sty						\
	abstract.tex ack.tex contents.tex tables.tex figures.tex	\
	chap1.tex chap2.tex chap3.tex chap4.tex chap5.tex	\
	bib.tex ref.bib apdxa.tex

$(MAIN).dvi:    $(MAIN).tex $(FIGURES) $(FILES)
	$(LATEX) $*.tex; 
	$(BIBTEX) $*;
	$(LATEX) $*.tex;
	while grep -s 'Rerun' $*.log 2> /dev/null; do	\
		$(LATEX) $*.tex;			\
	done

# GhostScript command line options based upon:
# http://pages.cs.wisc.edu/~ghost/doc/cvs/Ps2pdf.htm#PDFA
$(EMAIN).pdf:	$(MAIN).ps
	$(GS) -sPAPERSIZE=a4 -sProcessColorModel=DeviceCMYK -q \
	-dPDFA -dBATCH -dNOPAUSE -dNOOUTERSAVE -dUseCIEColor \
	-sDEVICE=pdfwrite -sOutputFile=$@ pdfa/PDFA_def.ps  $<

.dvi.ps:        $*.dvi
	$(DVIPS) -Ppdf -G0 -t a4 -o $@ $<
 
.ps.pdf:       $*.dvi
	$(PS2PDF) -sPAPERSIZE=a4 $< $@

clean:
	$(RM) -f *.aux \
		$(MAIN).log $(MAIN).dvi $(MAIN).ps $(MAIN).blg $(MAIN).bbl \
		$(MAIN).lot $(MAIN).lof $(MAIN).toc $(MAIN).pdf $(EMAIN).pdf

# Suggested by Neil B.
neat:
	$(RM) -f *.aux \
		$(MAIN).log $(MAIN).blg $(MAIN).bbl \
		$(MAIN).lot $(MAIN).lof $(MAIN).toc
