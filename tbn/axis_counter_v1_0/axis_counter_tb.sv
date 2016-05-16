`timescale 1ns / 1ps

module axis_counter_tb #(
	// time periods
	realtime TP = 8.0ns // 125MHz
);

logic clk;
logic rstn;
logic [31:0] cfg_data;
logic [31:0] tdata;
logic tvalid;

axis_counter #(
	.AXIS_TDATA_WIDTH(32),
	.CNTR_WIDTH(32)
) cntr0 (
	.aclk(clk),
	.aresetn(rstn),
	.cfg_data(cfg_data),
	.m_axis_tdata(tdata),
	.m_axis_tvalid(tvalid)
);

initial clk = 1'h0;
always #(TP/2) clk = ~clk;

int i;
initial begin
	cfg_data = 32'd99;
	rstn = 1'b0;
	repeat(10) @(negedge clk);
	rstn = 1'b1;
	for (i=0 ; i<1024; i++) begin
		@(posedge clk);
	end
	repeat(10) @(negedge clk);
	$finish;
end

initial begin
	$monitor("@ %gns rstn = %b, data = %0d", $time, rstn, tdata);
	$dumpfile("axis_counter_tb.vcd");
	$dumpvars(0, axis_counter_tb);
end

endmodule

