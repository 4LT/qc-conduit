MODDIR=$(QUAKEDIR)/ntcn
PROGS=progs.dat
OUTPUT=$(MODDIR)/$(PROGS)
FGD=ntcn.fgd
FGD_OUT=$(MODDIR)/$(FGD)

.PHONY: all chkdir install

all: $(PROGS)

chkdir: $(QUAKEDIR)/
	if [ -z "$(QUAKEDIR)" ] ; then\
		echo ;\
		echo "QUAKEDIR must be set!" ;\
		echo ;\
		exit 1;\
	fi

install: chkdir all $(OUTPUT) $(FGD_OUT)


$(PROGS): *.qc progs.src Makefile
	fteqcc

$(OUTPUT): $(PROGS) $(MODDIR)
	cp $(PROGS) "$(OUTPUT)"

$(FGD_OUT): $(FGD) $(MODDIR)
	cp $(FGD) "$(FGD_OUT)"

$(MODDIR):
	if [ \! -e "$(MODDIR)" ] ; then\
		mkdir "$(MODDIR)" ;\
   	fi
