create_clock -period 10.000 IO_CLK_BUFG -waveform {0.000 5.000}

create_clock -period 20.000 clk_50_bufg -waveform {0.000 10.000}
create_clock -period 20.833 clk_48_bufg -waveform {0.000 10.416}
create_clock -period 10.000 clk_fg_bufg -waveform {0.000 5.000}

set_clock_groups -exclusive -group {clk_50_unbuf clk_50_bufg} -group {clk_48_unbuf clk_48_bufg} -group {clk_fg_unbuf clk_fg_bufg}
