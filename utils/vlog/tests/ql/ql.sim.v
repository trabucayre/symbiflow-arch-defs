`default_nettype none
`include "cblock/cblock.sim.v"

module QL (clk, D, Q);
	input wire clk;
	input wire D;
	output wire Q;

    QL_FF ff0(clk, D, Q);
endmodule
