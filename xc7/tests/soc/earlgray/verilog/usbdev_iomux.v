module usbdev_iomux (
	clk_i,
	rst_ni,
	clk_usb_48mhz_i,
	rst_usb_48mhz_ni,
	rx_differential_mode_i,
	tx_differential_mode_i,
	sys_reg2hw_config_i,
	sys_usb_sense_o,
	cio_usb_d_i,
	cio_usb_dp_i,
	cio_usb_dn_i,
	cio_usb_d_o,
	cio_usb_se0_o,
	cio_usb_dp_o,
	cio_usb_dn_o,
	cio_usb_oe_o,
	cio_usb_tx_mode_se_o,
	cio_usb_sense_i,
	cio_usb_pullup_en_o,
	cio_usb_suspend_o,
	usb_rx_d_o,
	usb_rx_se0_o,
	usb_tx_d_i,
	usb_tx_se0_i,
	usb_tx_oe_i,
	usb_pwr_sense_o,
	usb_pullup_en_i,
	usb_suspend_i
);
	input wire clk_i;
	input wire rst_ni;
	input wire clk_usb_48mhz_i;
	input wire rst_usb_48mhz_ni;
	input wire rx_differential_mode_i;
	input wire tx_differential_mode_i;
	input wire [4:0] sys_reg2hw_config_i;
	output wire sys_usb_sense_o;
	input wire cio_usb_d_i;
	input wire cio_usb_dp_i;
	input wire cio_usb_dn_i;
	output wire cio_usb_d_o;
	output wire cio_usb_se0_o;
	output reg cio_usb_dp_o;
	output reg cio_usb_dn_o;
	output wire cio_usb_oe_o;
	output reg cio_usb_tx_mode_se_o;
	input wire cio_usb_sense_i;
	output reg cio_usb_pullup_en_o;
	output reg cio_usb_suspend_o;
	output reg usb_rx_d_o;
	output reg usb_rx_se0_o;
	input wire usb_tx_d_i;
	input wire usb_tx_se0_i;
	input wire usb_tx_oe_i;
	output wire usb_pwr_sense_o;
	input wire usb_pullup_en_i;
	input wire usb_suspend_i;
	reg async_pwr_sense;
	wire sys_usb_sense;
	wire usb_rx_d;
	wire usb_rx_dp;
	wire usb_rx_dn;
	prim_flop_2sync #(.Width(1)) cdc_io_to_sys(
		.clk_i(clk_i),
		.rst_ni(rst_ni),
		.d(cio_usb_sense_i),
		.q(sys_usb_sense)
	);
	assign sys_usb_sense_o = sys_usb_sense;
	prim_flop_2sync #(.Width(4)) cdc_io_to_usb(
		.clk_i(clk_usb_48mhz_i),
		.rst_ni(rst_usb_48mhz_ni),
		.d({cio_usb_dp_i, cio_usb_dn_i, cio_usb_d_i, async_pwr_sense}),
		.q({usb_rx_dp, usb_rx_dn, usb_rx_d, usb_pwr_sense_o})
	);
	always @(*) begin : proc_drive_out
		cio_usb_dn_o = 1'b0;
		cio_usb_dp_o = 1'b0;
		cio_usb_pullup_en_o = usb_pullup_en_i;
		cio_usb_suspend_o = usb_suspend_i;
		if (tx_differential_mode_i)
			cio_usb_tx_mode_se_o = 1'b0;
		else begin
			cio_usb_tx_mode_se_o = 1'b1;
			if (usb_tx_se0_i) begin
				cio_usb_dp_o = 1'b0;
				cio_usb_dn_o = 1'b0;
			end
			else begin
				cio_usb_dp_o = usb_tx_d_i;
				cio_usb_dn_o = !usb_tx_d_i;
			end
		end
	end
	assign cio_usb_d_o = usb_tx_d_i;
	assign cio_usb_se0_o = usb_tx_se0_i;
	assign cio_usb_oe_o = usb_tx_oe_i;
	always @(*) begin : proc_mux_data_input
		usb_rx_se0_o = ~usb_rx_dp & ~usb_rx_dn;
		if (rx_differential_mode_i)
			usb_rx_d_o = usb_rx_d;
		else
			usb_rx_d_o = usb_rx_dp;
	end
	always @(*) begin : proc_mux_pwr_input
		if (sys_reg2hw_config_i[1])
			async_pwr_sense = sys_reg2hw_config_i[0];
		else
			async_pwr_sense = cio_usb_sense_i;
	end
endmodule
