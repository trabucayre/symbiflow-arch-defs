module top (
    input  wire clk,

    input  wire [7:0] sw,
    output wire [7:0] led,
);
    wire O_LOCKED;
    wire RST;

    wire clk0;
    wire clk1;
    wire clk_out;
    wire clk_fb_i;
    wire clk_fb_o;

    reg [26:0] cnt_clk_out;
    reg [26:0] cnt_clk0;
    reg [26:0] cnt_clk1;

    assign RST = 1'b0;

    BUFG bufg0 (
        .I(clk_fb_i),
        .O(clk_fb_o)
    );

    wire clk_ibuf;
    IBUF ibuf0 (
        .I(clk),
        .O(clk_ibuf)
    );

    wire clk_bufg;
    BUFG bufg1 (
        .I(clk_ibuf),
        .O(clk_bufg)
    );

    PLLE2_ADV #(
        .BANDWIDTH          ("HIGH"),
        .COMPENSATION       ("ZHOLD"),

        .CLKIN1_PERIOD      (10.0),  // 100MHz

        .CLKFBOUT_MULT      (8),
        .CLKOUT0_DIVIDE     (8),
        .CLKOUT1_DIVIDE     (8 * 4),

        .STARTUP_WAIT       ("FALSE"),

        .DIVCLK_DIVIDE      (1)
    )
    pll (
        .CLKIN1     (clk_bufg),
        .CLKINSEL   (1),

        .RST        (RST),
        .PWRDWN     (0),
        .LOCKED     (O_LOCKED),

        .CLKFBIN    (clk_fb_i),
        .CLKFBOUT   (clk_fb_o),

        .CLKOUT0    (clk0),
        .CLKOUT1    (clk1)
    );

    wire clk0_bufg;
    BUFG bufg2 (
        .I(clk0),
        .O(clk0_bufg)
    );

    wire clk1_bufg;
    BUFG bufg3 (
        .I(clk1),
        .O(clk1_bufg)
    );

    BUFGMUX bufgmux (
      .I0(clk0_bufg),
      .I1(clk1_bufg),
      .S(sw[0]),
      .O(clk_out)
    );

    always @(posedge clk_out) begin
        cnt_clk_out <= cnt_clk_out + 1'b1;
    end
    assign led[0] = cnt_clk_out[25];

    always @(posedge clk0_bufg) begin
        cnt_clk0 <= cnt_clk0 + 1'b1;
    end
    assign led[1] = cnt_clk0[25];

    always @(posedge clk1_bufg) begin
        cnt_clk1 <= cnt_clk1 + 1'b1;
    end
    assign led[2] = cnt_clk1[25];
endmodule
