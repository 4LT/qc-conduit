MODDIR=$(QUAKEDIR)/ntcn
PROGS=progs.dat
OUTPUT=$(MODDIR)/$(PROGS)
FGD=ntcn.fgd
FGD_OUT=$(MODDIR)/$(FGD)

.PHONY: all chkdir install clean

all: $(PROGS)

chkdir: $(QUAKEDIR)/
	if [ -z "$(QUAKEDIR)" ] ; then\
		echo ;\
		echo "QUAKEDIR must be set!" ;\
		echo ;\
		exit 1;\
	fi

install: chkdir all $(OUTPUT) $(FGD_OUT)

clean:
	rm -f progs.dat
	rm -f progs.lno


$(PROGS): *.qc progs.src
	fteqcc

$(OUTPUT): $(PROGS) $(MODDIR)
	cp $(PROGS) "$(OUTPUT)"

$(FGD_OUT): $(FGD) $(MODDIR)
	cp $(FGD) "$(FGD_OUT)"

$(MODDIR):
	if [ \! -e "$(MODDIR)" ] ; then\
		mkdir "$(MODDIR)" ;\
   	fi
