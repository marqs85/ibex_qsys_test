`define PO_RESET_WIDTH 1000

module ibex_qsys_test(
    ///////// CLOCK /////////
    input              CLOCK_125_p,
    input              CLOCK_50_B3B,
    input              CLOCK_50_B5B,
    input              CLOCK_50_B6A,
    input              CLOCK_50_B7A,
    input              CLOCK_50_B8A,

    ///////// CPU /////////
    input              CPU_RESET_n,

    ///////// HEX0 /////////
    output      [6:0]  HEX0,

    ///////// HEX1 /////////
    output      [6:0]  HEX1,

    ///////// LEDG /////////
    output      [7:0]  LEDG,

    ///////// LEDR /////////
    output      [9:0]  LEDR,

    ///////// SW /////////
    input       [9:0]  SW
);

reg [15:0] po_reset_ctr = 0;
reg po_reset_n = 1'b0;

wire jtagm_reset_req;
wire [7:0] gpio;
wire CPU_RESET_n_deb;
wire sys_reset_n = (po_reset_n & CPU_RESET_n_deb & ~jtagm_reset_req);

assign LEDG = gpio;
assign LEDR[9:1] = '0;
assign HEX0 = '0;
assign HEX1 = '0;

// Power-on reset pulse generation (seems to be needed for serial flash controller)
always @(posedge CLOCK_50_B6A)
begin
    if (po_reset_ctr == `PO_RESET_WIDTH)
        po_reset_n <= 1'b1;
    else
        po_reset_ctr <= po_reset_ctr + 1'b1;
end

btn_debounce #(.MIN_PULSE_WIDTH(100000), .RESET_VAL(1)) deb0 (
    .i_clk          (CLOCK_50_B6A),
    .i_rstn         (po_reset_n),
    .i_btn          (CPU_RESET_n),
    .o_btn          (CPU_RESET_n_deb)
);

sys u0 (
    .clk_clk                            (CLOCK_50_B6A),
    .reset_reset_n                      (sys_reset_n),
    .master_0_master_reset_reset        (jtagm_reset_req), 
    .ibex_0_config_boot_addr_i          (32'h02800000),
//    .ibex_0_config_boot_addr_i          (32'h00008000),
    .ibex_0_config_core_sleep_o         (LEDR[0]),
    .pio_0_external_connection_export   (gpio)
);

endmodule
