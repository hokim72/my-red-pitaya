`timescale 1ns / 1ps

module axis_red_pitaya_adc_tb #(
	// time preiods
	realtime TP = 8.0ns // 125MHz
);

logic adc_clk, adc_csn, adc_clk_p, adc_clk_n;
logic [13:0] adc_dat_a, adc_dat_b;
logic tvalid;
logic [31:0] tdata;

axis_red_pitaya_adc adc0(
	.adc_clk(adc_clk),
	.adc_csn(adc_csn),
	.adc_clk_p(adc_clk_p),
	.adc_clk_n(adc_clk_n),
	.adc_dat_a(adc_dat_a),
	.adc_dat_b(adc_dat_b),
	.m_axis_tvalid(tvalid),
	.m_axis_tdata(tdata)
);

initial  begin
	adc_clk_p = 1'h0;
	adc_clk_n = 1'h1;
end
always begin
	#(TP/2) adc_clk_p = ~adc_clk_p; 
	adc_clk_n = ~adc_clk_n;
end

int i;
initial begin
	for (i=0; i<512; i++) begin
		@(posedge adc_clk_p);
		adc_dat_a = i;
		adc_dat_b = i+1;
	end
	repeat(10) @(posedge adc_clk_p);
	$finish;
end

initial begin
	$dumpfile("axis_red_pitaya_adc_tb.vcd");
	$dumpvars(0, axis_red_pitaya_adc_tb);
end

endmodule
