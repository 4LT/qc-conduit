MODDIR=$(QUAKEDIR)/conduit
PROGS=progs.dat
OUTPUT=$(MODDIR)/$(PROGS)
FGD=conduit.fgd
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
	mkdir -p build/conduit
	cp $(PROGS) build/conduit/
	cp $(FGD) build/conduit/
	cp README.md build/conduit/
	cd build && rm -f conduit.zip && zip -r conduit.zip conduit/

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
