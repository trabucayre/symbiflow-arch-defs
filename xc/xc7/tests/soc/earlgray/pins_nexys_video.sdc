create_clock -period 10.000 IO_CLK_BUFG -waveform {0.000 5.000}

create_clock -period 20.000 clkgen.clk_50_unbuf -waveform {0.000 10.000}
create_clock -period 20.833 clkgen.clk_48_unbuf -waveform {0.000 10.416}
create_clock -period 10.000 clkgen.clk_fb_unbuf -waveform {0.000 5.000}

set_clock_groups -exclusive -group {clk_50_unbuf clk_50_buf} -group {clk_48_unbuf clk_48_buf} -group {clk_fg_unbuf clk_fg_buf}
