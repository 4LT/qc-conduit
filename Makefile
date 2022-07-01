MODDIR=$(QUAKEDIR)/ntcn
PROGS=progs.dat
OUTPUT=$(MODDIR)/$(PROGS)
FGD=ntcn.fgd
FGD_OUT=$(MODDIR)/$(FGD)

.PHONY: all chkdir install package clean

all: $(PROGS)

chkdir: 
	if [ -z "$(QUAKEDIR)" ] ; then\
		echo ;\
		echo "QUAKEDIR must be set!" ;\
		echo ;\
		exit 1;\
	fi

install: chkdir all $(OUTPUT) $(FGD_OUT)

package: all $(PROGS) $(FGD)
	mkdir -p build/ntcn
	cp $(PROGS) build/ntcn/
	cp $(FGD) build/ntcn/
	cp README.md build/ntcn/
	rm -f build/ntcn.zip
	zip -r build/ntcn.zip build/ntcn

clean:
	rm -f progs.dat
	rm -f progs.lno
	rm -rf build/


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
