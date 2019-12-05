`default_nettype none

(* whitebox *)
module QL_FF(clk, D, Q);
	input wire clk;
	(* SETUP="clk 10e-12" *)
	input wire D;
	(* CLK_TO_Q = "clk 10e-12" *)
	output reg Q;
	always @(posedge clk) begin
		Q <= D;
	end
endmodule
