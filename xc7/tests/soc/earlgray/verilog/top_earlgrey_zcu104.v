module top_earlgrey_zcu104 (
	IO_CLK_P,
	IO_CLK_N,
	IO_URX,
	IO_UTX
);
	input IO_CLK_P;
	input IO_CLK_N;
	input IO_URX;
	output IO_UTX;
	wire clk_sys;
	wire clk_48mhz;
	wire rst_sys_n;
	wire [31:0] cio_gpio_p2d;
	wire [31:0] cio_gpio_d2p;
	wire [31:0] cio_gpio_en_d2p;
	wire cio_uart_rx_p2d;
	wire cio_uart_tx_d2p;
	wire cio_uart_tx_en_d2p;
	wire cio_usbdev_sense_p2d;
	wire cio_usbdev_pullup_d2p;
	wire cio_usbdev_pullup_en_d2p;
	wire cio_usbdev_dp_p2d;
	wire cio_usbdev_dp_d2p;
	wire cio_usbdev_dp_en_d2p;
	wire cio_usbdev_dn_p2d;
	wire cio_usbdev_dn_d2p;
	wire cio_usbdev_dn_en_d2p;
	reg [31:0] cnt = 0;
	reg IO_RST_N = 0;
	wire clk;
	wire clk_unbuf;
	wire IO_JTCK = 0;
	wire IO_JTMS = 0;
	wire IO_JTDI = 0;
	wire IO_JTRST_N = IO_RST_N;
	wire IO_JTDO;
	wire IO_USB_DP0 = 0;
	wire IO_USB_DN0 = 0;
	wire IO_USB_SENSE0 = 0;
	wire IO_USB_PULLUP0;
	always @(posedge clk_sys)
		if (cnt < 1000) begin
			cnt <= cnt + 1;
			IO_RST_N <= 0;
		end
		else
			IO_RST_N <= 1;
	IBUFDS clk_iobuf(
		.I(IO_CLK_P),
		.IB(IO_CLK_N),
		.O(clk_unbuf)
	);
	BUFG clk_buf(
		.I(clk_unbuf),
		.O(clk)
	);
	top_earlgrey top_earlgrey(
		.clk_i(clk_sys),
		.rst_ni(rst_sys_n),
		.clk_usb_48mhz_i(clk_48mhz),
		.jtag_tck_i(IO_JTCK),
		.jtag_tms_i(IO_JTMS),
		.jtag_trst_ni(IO_JTRST_N),
		.jtag_td_i(IO_JTDI),
		.jtag_td_o(IO_JTDO),
		.dio_uart_rx_i(cio_uart_rx_p2d),
		.dio_uart_tx_o(cio_uart_tx_d2p),
		.dio_uart_tx_en_o(cio_uart_tx_en_d2p),
		.mio_in_i(cio_gpio_p2d),
		.mio_out_o(cio_gpio_d2p),
		.mio_oe_o(cio_gpio_en_d2p),
		.dio_spi_device_sck_i(1'b0),
		.dio_spi_device_csb_i(1'b0),
		.dio_spi_device_mosi_i(1'b0),
		.dio_usbdev_sense_i(cio_usbdev_sense_p2d),
		.dio_usbdev_pullup_o(cio_usbdev_pullup_d2p),
		.dio_usbdev_pullup_en_o(cio_usbdev_pullup_en_d2p),
		.dio_usbdev_dp_i(cio_usbdev_dp_p2d),
		.dio_usbdev_dp_o(cio_usbdev_dp_d2p),
		.dio_usbdev_dp_en_o(cio_usbdev_dp_en_d2p),
		.dio_usbdev_dn_i(cio_usbdev_dn_p2d),
		.dio_usbdev_dn_o(cio_usbdev_dn_d2p),
		.dio_usbdev_dn_en_o(cio_usbdev_dn_en_d2p),
		.scanmode_i(1'b0)
	);

	assign cio_uart_rx_p2d = IO_URX;
	assign IO_UTX = (cio_uart_tx_en_d2p ? cio_uart_tx_d2p : 1'bz);
	assign cio_gpio_p2d = 1'b0;
	assign cio_gpio_p2d = 1'b0;
	assign cio_usbdev_sense_p2d = 1'b0;
	assign cio_usbdev_dp_p2d = 1'b0;
	assign cio_usbdev_dn_p2d = 1'b0;

	clkgen_xilusp clkgen(
		.IO_CLK(clk),
		.IO_RST_N(IO_RST_N),
		.clk_sys(clk_sys),
		.clk_48MHz(clk_48mhz),
		.rst_sys_n(rst_sys_n)
	);
endmodule
