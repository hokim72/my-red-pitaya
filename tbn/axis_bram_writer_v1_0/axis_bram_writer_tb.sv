`timescale 1ns / 1ps

module axis_bram_writer_tb #(
	// time periods
	realtime TP = 8.0ns // 125MHz
);

logic clk;
logic rstn, rstn2;
logic [31:0] cfg_data;
logic [31:0] tdata;
logic tvalid;

logic [63:0] tdata2;
logic tvalid2;
logic tready2;

logic [8:0] sts_data;
logic bram_porta_clk;
logic bram_porta_rst;
logic [8:0] bram_porta_addr;
logic [63:0] bram_porta_wrdata;
logic [7:0] bram_porta_we;

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

axis_dwidth_converter dwconvert0(
	.aclk(clk),
//	.aresetn(rstn),
	.aresetn(rstn2),
	.s_axis_tvalid(tvalid),
	.s_axis_tready(),
	.s_axis_tdata(tdata),
	.m_axis_tvalid(tvalid2),
	.m_axis_tready(tready2),
	.m_axis_tdata(tdata2)
);

axis_bram_writer #(
	.AXIS_TDATA_WIDTH(64),
	.BRAM_DATA_WIDTH(64),
	.BRAM_ADDR_WIDTH(9)
) bram_writer0 (
	.aclk(clk),
	.aresetn(rstn2),
	.sts_data(sts_data),
	.s_axis_tready(tready2),
	.s_axis_tdata(tdata2),
	.s_axis_tvalid(tvalid2),
	.bram_porta_clk(bram_porta_clk),
	.bram_porta_rst(bram_porta_rst),
	.bram_porta_addr(bram_porta_addr),
	.bram_porta_wrdata(bram_porta_wrdata),
	.bram_porta_we(bram_porta_we)
);

initial clk = 1'h0;
always #(TP/2) clk = ~clk;

int i;
initial begin
	cfg_data = 32'd2047;
	rstn = 1'b0;
	rstn2 = 1'b0;
	repeat(10) @(negedge clk);
	rstn2 = 1'b1;
	repeat(10) @(negedge clk);
	rstn = 1'b1;
	for (i=0 ; i<3000; i++) begin
		@(posedge clk);
	end
	repeat(10) @(negedge clk);
	$finish;
end

initial begin
	$monitor("@ %gns, data = %h", $time, sts_data);
	$dumpfile("axis_bram_writer_tb.vcd");
	$dumpvars(0, axis_bram_writer_tb);
end

endmodule

