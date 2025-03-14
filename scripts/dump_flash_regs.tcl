# flash details
set flash_base                  0x02000000
set flash_imem_offset           0x00800000
set flash_imem_base             [format 0x%.8x [expr $flash_base + $flash_imem_offset]]
set flash_secsize               65536

# flash controller register addresses
set control_register            0x00004000
set operating_protocols_setting 0x00004010
set read_instr                  0x00004014
set write_instr                 0x00004018
set flash_cmd_setting           0x0000401c
set flash_cmd_ctrl              0x00004020
set flash_cmd_addr_register     0x00004024
set flash_cmd_write_data_0      0x00004028
set flash_cmd_read_data_0       0x00004030

#Select the master service type and check for available service paths.
set service_paths [get_service_paths master]

#Set the master service path.
set master_service_path [lindex $service_paths 0]

#Open the master service.
set claim_path [claim_service master $master_service_path mylib]

puts "Halting CPU"
master_write_32 $claim_path 0x40 0x00000001
master_write_32 $claim_path 0x40 0x80000001

#read status reg
master_write_32 $claim_path $flash_cmd_setting 0x00001805
master_write_32 $claim_path $flash_cmd_ctrl 0x1
set st [master_read_8 $claim_path $flash_cmd_read_data_0 1]
puts "\nSTATUS: $st"

#read flag reg
master_write_32 $claim_path $flash_cmd_setting 0x00001870
master_write_32 $claim_path $flash_cmd_ctrl 0x1
set flags [master_read_8 $claim_path $flash_cmd_read_data_0 1]
puts "FLAGS: $flags"

#read vcr reg
master_write_32 $claim_path $flash_cmd_setting 0x00001885
master_write_32 $claim_path $flash_cmd_ctrl 0x1
set vcr [master_read_8 $claim_path $flash_cmd_read_data_0 1]
puts "VCR: $vcr"

#read nvcr reg
master_write_32 $claim_path $flash_cmd_setting 0x000028B5
master_write_32 $claim_path $flash_cmd_ctrl 0x1
set nvcr [master_read_16 $claim_path $flash_cmd_read_data_0 1]
puts "NVCR: $nvcr"

#read evcr reg
master_write_32 $claim_path $flash_cmd_setting 0x00001865
master_write_32 $claim_path $flash_cmd_ctrl 0x1
set evcr [master_read_8 $claim_path $flash_cmd_read_data_0 1]
puts "EVCR: $evcr"

#clear flag register
master_write_32 $claim_path $flash_cmd_setting 0x00000050
master_write_32 $claim_path $flash_cmd_ctrl 0x1

