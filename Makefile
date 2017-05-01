# Benjamin Steenkamer and Abraham McIlvaine
# CPEG 324-010
# Lab 3: Single Cycle Calculator in VHDL - Makefile
# 5/3/17

GHDL = ghdl-0.33-x86_64-linux/bin/ghdl
COMP = -a --ieee=standard
EXE = -e --ieee=standard
RUN = -r

###################################################
calculator:
#	Compile VHDL files
	$(GHDL) $(COMP) reg_file.vhdl
	$(GHDL) $(COMP) clk_filter.vhdl
	$(GHDL) $(COMP) addsub_8bit.vhdl
	$(GHDL) $(COMP) calculator.vhdl
	$(GHDL) $(COMP) calculator_tb.vhdl
#	Generate the executable for the test bench
	$(GHDL) $(EXE) calculator_tb
###################################################

###################################################
run-calculator: calculator
#	Run the test bench
	$(GHDL) $(RUN) calculator_tb
###################################################

###################################################
dump-calculator_tb: calculator
	$(GHDL) $(RUN) calculator_tb --vcd=calculator_tb.vcd
#Use a tool like GTK wave to view the vcd file and see the waveforms.
###################################################

###################################################
clean:
	rm -f *.o *.cf *.out *.vcd
###################################################
