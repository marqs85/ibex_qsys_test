//
// Copyright (C) 2017-2025  Markus Hiienkari <mhiienka@niksula.hut.fi>
//
// This file is part of CPS2_digiav project.
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.
//

module btn_debounce #(
    parameter MIN_PULSE_WIDTH=100,
    parameter RESET_VAL = 0
) (
    input i_clk,
    input i_rstn,
    input i_btn,
    output reg o_btn
);

reg [$clog2(MIN_PULSE_WIDTH)-1:0] clk_ctr;
reg i_btn_prev;

always @(posedge i_clk or negedge i_rstn) begin
    if (!i_rstn) begin
        o_btn <= RESET_VAL;
        clk_ctr <= 0;
    end else begin
        if (i_btn == i_btn_prev) begin
            if (clk_ctr == MIN_PULSE_WIDTH-1'b1)
                o_btn <= i_btn;
            else
                clk_ctr <= clk_ctr + 1'b1;
        end else begin
            clk_ctr <= 0;
        end

        i_btn_prev <= i_btn;
    end
end

endmodule
