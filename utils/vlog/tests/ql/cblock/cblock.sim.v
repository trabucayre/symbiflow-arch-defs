`default_nettype none

(* whitebox *)
module QL_FF(clk, D, E, Q);
	input wire clk;
	(* SETUP="clk 10e-12" *)
	(* NO_COMB *)
	input wire D;
	(* SETUP="clk 10e-12" *)
	(* NO_COMB *)
	input wire E;
    (* CLK_TO_Q = "clk 10e-12" *)
	output reg Q;
	always @(posedge clk) begin
		if (E)
			Q <= D;
	end
endmodule
