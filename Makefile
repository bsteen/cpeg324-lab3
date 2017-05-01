# Benjamin Steenkamer and Abraham McIlvaine
# CPEG 324-010
# Lab 2: VHDL Componetns - Makefile
# 4/5/17

GHDL = ghdl-0.33-x86_64-linux/bin/ghdl
COMP = -a --ieee=standard
EXE = -e --ieee=standard
RUN = -r

###################################################
calculator:
	$(GHDL) $(COMP) reg_file.vhdl
	$(GHDL) $(COMP) clk_filter.vhdl
	$(GHDL) $(COMP) addsub_8bit.vhdl
	$(GHDL) $(COMP) calculator.vhdl
#	Generate the executable for the test bench
	# $(GHDL) $(EXE) mux4to1_tb

test-mux4to1: make-mux4to1
#	Run the test benchRun the test bench
	$(GHDL) $(RUN) mux4to1_tb

test-dump-mux4to1: make-mux4to1
	$(GHDL) $(RUN) mux4to1_tb --vcd=mux4to1_tb.vcd
#Use a tool like GTK wave to view the vcd file and see the waveforms.
###################################################

clean:
	rm -f *.o *.cf *.out *.vcd
