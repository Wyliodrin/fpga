
PROJECT_NAME=test
PARTNAME=xc3s500e-5fg320

all: $(PROJECT_NAME).bit

$(PROJECT_NAME).ngc: $(PROJECT_NAME).xst $(PROJECT_NAME).prj 
	xst  -intstyle xflow -ifn "$(PROJECT_NAME).xst"

$(PROJECT_NAME).ngd: $(PROJECT_NAME).ngc
	ngdbuild -intstyle xflow -p $(PARTNAME) $(PROJECT_NAME).ngc $(PROJECT_NAME).ngd

$(PROJECT_NAME)_map.ncd: $(PROJECT_NAME).ngd
	map -intstyle xflow -p $(PARTNAME) -ir off -o $(PROJECT_NAME)_map.ncd $(PROJECT_NAME).ngd $(PROJECT_NAME).pcf

$(PROJECT_NAME).ncd: $(PROJECT_NAME)_map.ncd
	par -intstyle xflow -w $(PROJECT_NAME)_map.ncd $(PROJECT_NAME).ncd $(PROJECT_NAME).pcf

$(PROJECT_NAME).bit: $(PROJECT_NAME).ncd
	bitgen -intstyle xflow -m $(PROJECT_NAME).ncd

.PHONY: program
program: $(PROJECT_NAME).bit impact.commands
	impact -batch impact.commands