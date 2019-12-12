/*
A simplistic test for OBUFTDS. Two of them are instanciated and their outpus
are connected to LEDs. Data and tri-state inputs are controlled by switches.

Truth tables:

SW9  SW8  | LED3 LED2
 0    0   |  1    0
 0    1   |  0    1
 1    0   |  0    0
 1    1   |  0    0

SW11 SW10 | LED8 LED7
 0    0   |  0    1
 0    1   |  1    0
 1    0   |  0    0
 1    1   |  0    0

Couldn't use all switches and buttons at the same time as the differential
IOs use different IOSTANDARD than the single ended ones and have to be in
a separate bank.

*/
`default_nettype none

// ============================================================================
`define CLKFBOUT_MULT 2

module top
(
input wire clk,
input wire rst,

input  wire [7:0] sw,

output wire  diff_p,
output wire  diff_n
);
wire [7:0] INPUTS;
wire  buf_i;
wire  buf_t;
wire CLK;
wire CLKDIV;

BUFG bufg(.I(clk), .O(CLK));

assign INPUTS = sw;


OSERDESE2 #(
.DATA_RATE_OQ   ("DDR"),
.DATA_WIDTH     (8),
.DATA_RATE_TQ   ("BUF"),
.TRISTATE_WIDTH (1)
)
oserdes
(
.CLK    (CLK),
.CLKDIV (CLKDIV),
.RST    (rst),

.OCE    (1'b1),
.D1     (INPUTS[0]),
.D2     (INPUTS[1]),
.D3     (INPUTS[2]),
.D4     (INPUTS[3]),
.D5     (INPUTS[4]),
.D6     (INPUTS[5]),
.D7     (INPUTS[6]),
.D8     (INPUTS[7]),
.OQ     (buf_i),

.TCE    (1'b1),
.T1     (1'b0), // All 0 to keep OBUFT always on.
.T2     (1'b0),
.T3     (1'b0),
.T4     (1'b0),
.TQ     (buf_t)
);

// ============================================================================
// OBUFTDS

OBUFTDS # (
  .IOSTANDARD("DIFF_SSTL135"),
  .SLEW("FAST")
) obuftds_0 (
  .I(buf_i),
  .T(buf_t),
  .O(diff_p), // LED2
  .OB(diff_n) // LED3
);

wire locked;
wire pre_bufg_clkdiv;
wire clk_fb_i;
wire clk_fb_o;

PLLE2_ADV #(
.BANDWIDTH          ("HIGH"),
.COMPENSATION       ("ZHOLD"),
.CLKIN1_PERIOD      (10.0),  // 100MHz
.CLKFBOUT_MULT      (`CLKFBOUT_MULT),
.CLKOUT0_DIVIDE     (`CLKFBOUT_MULT * 4),
.CLKOUT1_DIVIDE     ((`CLKFBOUT_MULT * 4) * 4),
.STARTUP_WAIT       ("FALSE"),
.DIVCLK_DIVIDE      (1'd1)
)
pll
(
.CLKIN1     (CLK),
.CLKINSEL   (1),

.RST        (rst),
.PWRDWN     (0),
.LOCKED     (locked),

.CLKFBIN    (clk_fb_i),
.CLKFBOUT   (clk_fb_o),

.CLKOUT0    (pre_bufg_clkdiv),
);

BUFG bufg_clkdiv(.I(pre_bufg_clkdiv), .O(CLKDIV));

endmodule
