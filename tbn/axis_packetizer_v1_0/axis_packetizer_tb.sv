`timescale 1ns / 1ps

module axis_packetizer_tb #(
	// time periods
	realtime TP = 8.0ns // 125MHz
);

logic clk;
logic rstn;
logic [31:0] cfg_data;
logic [31:0] tdata;
logic tvalid;

logic [31:0] cfg_data2;
logic [31:0] tdata2;
logic tvalid2;
logic tlast2;

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

axis_packetizer #(
	.AXIS_TDATA_WIDTH(32),
	.CNTR_WIDTH(32)
) pakz0 (
	.aclk(clk),
	.aresetn(rstn),
	.cfg_data(cfg_data2),
	.s_axis_tready(),
	.s_axis_tdata(tdata),
	.s_axis_tvalid(tvalid),
	.m_axis_tready(1'b1),
	.m_axis_tdata(tdata2),
	.m_axis_tvalid(tvalid2),
	.m_axis_tlast(tlast2)
);

initial clk = 1'h0;
always #(TP/2) clk = ~clk;

int i;
initial begin
	cfg_data = 32'd99;
	cfg_data2 = 32'd99;
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
	$monitor("@ %gns data = %0d", $time, tdata2);
	$dumpfile("axis_packetizer_tb.vcd");
	$dumpvars(0, axis_packetizer_tb);
end

endmodule

