`default_nettype none
`include "cblock/cblock.sim.v"

module QL (clk, D, E, Q);
	input wire clk;
	input wire D;
    input wire E;
	output wire Q;

    QL_FF ff0(clk, D, E, Q);
endmodule
