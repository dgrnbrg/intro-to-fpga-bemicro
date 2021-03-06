#-------------------------------------------------------------------------------
# Independent Clocks
#-------------------------------------------------------------------------------

# derive_pll_clocks with -create_base_clocks switch will define all 
# independent clocks for the design


#-------------------------------------------------------------------------------
# PLL Clocks
#-------------------------------------------------------------------------------
derive_pll_clocks -create_base_clocks


# Aliases for long clock names
set NIOS_PLL_CLK0    "nios2_bemicro_sopc_inst|the_pll|sd1|pll7|clk[0]"
set NIOS_PLL_CLK1    "nios2_bemicro_sopc_inst|the_pll|sd1|pll7|clk[1]"
set NIOS_PLL_CLK2    "nios2_bemicro_sopc_inst|the_pll|sd1|pll7|clk[2]"


#-------------------------------------------------------------------------------
# Generated Clocks
#-------------------------------------------------------------------------------


#-------------------------------------------------------------------------------
# Clock Uncertainty
#-------------------------------------------------------------------------------
derive_clock_uncertainty

#-------------------------------------------------------------------------------
# Mobile DDR Timing
#-------------------------------------------------------------------------------

# Call in a seperate file
source "mobile_ddr_sdram.sdc"

#-------------------------------------------------------------------------------
# Temp. Sensor Timing
#-------------------------------------------------------------------------------
#
#  The Cyclone IV FPGA interfaces to LM71 temperature sensor.  The sensor has the 
#  following interface signals:
#
#   output   wire  TEMP_CS_N,
#   output   wire  TEMP_SC,
#   output   wire  TEMP_MOSI,
#   input    wire  TEMP_MISO,
#
#  From the datasheet:
#
#                          Min         Max
#                          ���         ���
#     TEMP_SC               0          6.25      MHz
#     Tsu - MOSI           30                    ns     wrt rising edge TEMP_SC
#     Th - MOSI            50                    ns     wrt rising edge TEMP_SC
#     Tco - MISO            0           70       ns     wrt falling edge TEMP_SC
#
#
#  The clock signal is generated by a register clocked by the NIOS PLL:
#
#     nios2_bemicro_sopc_inst|the_pll|sd1|pll7|clk[2]    <- 40 MHz
#  
#  The fastest clock frequency supported by LM71 is 6.25 MHz.  Will assume
#  this frequency for constraining purposes
#
#  TEMP_SC is NOT a free running clock.  It is only active when TEMP_CS_N
#  is asserted
#-------------------------------------------------------------------------------


# Define TEMP_SC as a clock node
# - this is a two step process
#   (a)  TEMP_SC output is generated by a register.  Declare
#        the output of the register as a clock node
#   (b)  The output of the register is tied to TEMP_SC FPGA 
#        I/O pin.  Define TEMP_SC FPGA I/O pin as a clock

# create alias for REALLY long instance name
set TEMP_SC_REG   {nios2_bemicro_sopc:nios2_bemicro_sopc_inst|temp_sense_spi:the_temp_sense_spi|SCLK_reg}

# define TEMP_SC register as a clock node, 6.25 MHz
create_generated_clock -name TEMP_SC_REG_CLK \
                       -multiply_by 5 \
                       -divide_by 32 \
                       -source [get_pins $NIOS_PLL_CLK2] \
                       [get_registers "$TEMP_SC_REG"]

# define TEMP_SC FPGA IO pin as a clock node
create_generated_clock -name TEMP_SC \
                       -source [get_registers $TEMP_SC_REG] \
                       [get_ports TEMP_SC]


#From the Micro SD Specification:
#  Tco_max     70 ns    wrt falling edge TEMP_SC
#  Tco_min      0 ns
#  Tsu         30 ns
#  Th          50 ns
#
#  Assuming clock & data paths are trace delay matched
set Tco_max_temp    70.000
set Tco_min_temp     0.000
set Tsu_temp        30.000
set Th_temp        -50.000

set_input_delay -clock TEMP_SC -clock_fall -max $Tco_max_temp [get_ports TEMP_MISO]
set_input_delay -clock TEMP_SC -clock_fall -min $Tco_min_temp [get_ports TEMP_MISO]

# False pathing output timing.  Timing will be met by design
#set_output_delay -clock TEMP_SC -max $Tsu_temp [get_ports TEMP_MOSI]
#set_output_delay -clock TEMP_SC -min $Th_temp  [get_ports TEMP_MOSI]
set_false_path -to [get_ports TEMP_MOSI]


# Since TEMP_SC register is forced into IO Element
# false path from register to pin because this delay is fixed
set_false_path -from [get_registers $TEMP_SC_REG] -to [get_ports {TEMP_SC }]


# Add multicycle constraints for IO timing:
# - Since the data generated is generated by $NIOS_PLL_CLK2 in the 40 MHz
#   clock domain but data will be captured by TEMP_SC in 6.25 MHz domain,
#   multicycles apply
# - when transfering data from a fast clock domain to a related slow clock 
#   domain source multicycles can be used
set_multicycle_path -setup -start 6 -from [get_clocks $NIOS_PLL_CLK2] -to [get_clocks TEMP_SC] 
set_multicycle_path -hold  -start 5 -from [get_clocks $NIOS_PLL_CLK2] -to [get_clocks TEMP_SC] 

# Conversely:
# - Since the data generated by the external device is in the 6.25 MHz domain
#   but will be captured by $NIOS_PLL_CLK2 in the 40 MHz clock domain, 
#   multicycles apply
# - when transfering data from a slow clock domain to a related fast clock 
#   domain destination multicycles can be used
set_multicycle_path -setup -end 6 -from [get_clocks TEMP_SC] -to [get_clocks $NIOS_PLL_CLK2] 
set_multicycle_path -hold  -end 5 -from [get_clocks TEMP_SC] -to [get_clocks $NIOS_PLL_CLK2] 


# Lastly, the LM71 has no timing requirements for TEMP_CS_N.  Therefore will
# false path
set_false_path -to [get_ports TEMP_CS_N]





#-------------------------------------------------------------------------------
# JTAG
#-------------------------------------------------------------------------------

#cut all paths to and from TCK
set_clock_groups -asynchronous -group [get_clocks altera_reserved_tck]

#constrain ports
set_input_delay  -clock altera_reserved_tck 20 [get_ports altera_reserved_tdi]
set_input_delay  -clock altera_reserved_tck 20 [get_ports altera_reserved_tms]
set_output_delay -clock altera_reserved_tck 20 [get_ports altera_reserved_tdo]



#-------------------------------------------------------------------------------
# Misc Timing
#-------------------------------------------------------------------------------

# LED interface is non-critical
set_false_path -to [get_ports "F_LED?"]

# DiP Switch interface is non-critical
set_false_path -from [get_ports "RECONFIG*"]



#-------------------------------------------------------------------------------
# Related Clock Domains
#-------------------------------------------------------------------------------
set_clock_groups -asynchronous \
		-group { \
					 CLK_FPGA_50M \
					 nios2_bemicro_sopc_inst|the_pll|sd1|pll7|clk[0] \
					 nios2_bemicro_sopc_inst|the_pll|sd1|pll7|clk[1] \
					 nios2_bemicro_sopc_inst|the_pll|sd1|pll7|clk[2] \
					 TEMP_SC_REG_CLK \
					 TEMP_SC \
				 } \
		-group {altera_reserved_tck}
 
 
#-------------------------------------------------------------------------------
# clock-to-Clock Multicycles
#-------------------------------------------------------------------------------

# already defined...

 
 
#-------------------------------------------------------------------------------
# False paths
#-------------------------------------------------------------------------------
 
# False path reset synchronizer
set_false_path -through [get_pins -compatibility_mode "*|clrn"] \
               -to [get_keepers "nios2_bemicro_sopc:nios2_bemicro_sopc_inst|nios2_bemicro_sopc_reset_pll_c1_out_domain_synch_module:nios2_bemicro_sopc_reset_pll_c1_out_domain_synch|*"]

