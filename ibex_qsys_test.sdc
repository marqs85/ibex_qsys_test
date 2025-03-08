### Clocks ###

create_clock -period 50MHz -name clk50 [get_ports CLOCK_50_B6A]

create_generated_clock -name flash_clk -divide_by 2 -source [get_ports CLOCK_50_B6A] [get_pins sys:u0|sys_intel_generic_serial_flash_interface_top_0:intel_generic_serial_flash_interface_top_0|sys_intel_generic_serial_flash_interface_top_0_qspi_inf_inst:qspi_inf_inst|flash_clk_reg|q]

#derive_pll_clocks
derive_clock_uncertainty

### Groups ###

set_clock_groups -asynchronous -group \
                            {clk50 flash_clk}


### IO ###

set_false_path -from [get_ports CPU_RESET_n]
set_false_path -to [get_ports "LEDG* LEDR* HEX*"]


### JTAG Signal Constraints ###

# max 10MHz JTAG clock
remove_clock altera_reserved_tck
create_clock -name altera_reserved_tck -period "10MHz" [get_ports altera_reserved_tck]
set_clock_groups -exclusive -group [get_clocks altera_reserved_tck]
set_input_delay -clock altera_reserved_tck 20 [get_ports altera_reserved_tdi]
set_input_delay -clock altera_reserved_tck 20 [get_ports altera_reserved_tms]
set_output_delay -clock altera_reserved_tck 20 [get_ports altera_reserved_tdo]
