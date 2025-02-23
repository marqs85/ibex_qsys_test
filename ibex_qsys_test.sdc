### Clocks ###

create_clock -period 50MHz -name clk50 [get_ports CLOCK_50_B6A]

#derive_pll_clocks
derive_clock_uncertainty


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
