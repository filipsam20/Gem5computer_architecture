# List of subdirectories with their Makefiles
SUBDIRS = /home/arch/Desktop/gem5/spec_cpu2006/401.bzip2/src /home/arch/Desktop/gem5/spec_cpu2006/429.mcf/src /home/arch/Desktop/gem5/spec_cpu2006/429.mcf/src /home/arch/Desktop/gem5/spec_cpu2006/458.sjeng/src /home/arch/Desktop/gem5/spec_cpu2006/470.lbm/src


.PHONY: all
all: $(SUBDIRS)



.PHONY: $(SUBDIRS)
$(SUBDIRS):
	@echo "Entering directory '$@'"
	$(MAKE) -C $@

.PHONY: clean
clean: 
	@echo "Cleaning all subdirectories"
	@for dir in $(SUBDIRS); do \
		$(MAKE) -C $$dir clean;\
	done