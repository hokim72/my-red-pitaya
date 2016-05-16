`timescale 1ns / 1ps

module axi_cfg_register_tb #(
	// time periods
	realtime TP = 8.0ns, // 125MHz
	parameter CFG_DATA_WIDTH = 64
);

glbl glbl();

logic [CFG_DATA_WIDTH-1:0] cfg_data;

logic clk;
logic rstn;

logic [31:0] 	axi_awaddr;
logic 			axi_awvalid;
logic			axi_awready;
logic [31:0]	axi_wdata;
logic [3:0]		axi_wstrb;
logic			axi_wvalid;
logic			axi_wready;
logic [1:0]		axi_bresp;
logic 			axi_bvalid;
logic			axi_bready;
logic [31:0]	axi_araddr;
logic			axi_arvalid;
logic			axi_arready;
logic [31:0]	axi_rdata;
logic [1:0]		axi_rresp;
logic			axi_rvalid;
logic			axi_rready;

axi_master_model_v1 #(
	.AW(32),
	.DW(32)
) master (
	.aclk_i(clk),
	.arstn_i(rstn),
	.axi_awaddr_o(axi_awaddr),
	.axi_awvalid_o(axi_awvalid),
	.axi_awready_i(axi_awready),
	.axi_wdata_o(axi_wdata),
	.axi_wstrb_o(axi_wstrb),
	.axi_wvalid_o(axi_wvalid),
	.axi_wready_i(axi_wready),
	.axi_bresp_i(axi_bresp),
	.axi_bvalid_i(axi_bvalid),
	.axi_bready_o(axi_bready),
	.axi_araddr_o(axi_araddr),
	.axi_arvalid_o(axi_arvalid),
	.axi_arready_i(axi_arready),
	.axi_rdata_i(axi_rdata),
	.axi_rresp_i(axi_rresp),
	.axi_rvalid_i(axi_rvalid),
	.axi_rready_o(axi_rready)
);

axi_cfg_register #(
	.CFG_DATA_WIDTH(CFG_DATA_WIDTH),
	.AXI_DATA_WIDTH(32),
	.AXI_ADDR_WIDTH(32),
	.NON_REG_MASK('h1)
) cfg0 (
	.aclk(clk),
	.aresetn(rstn),
	.cfg_data(cfg_data),
	.s_axi_awaddr(axi_awaddr),
	.s_axi_awvalid(axi_awvalid),
	.s_axi_awready(axi_awready),
	.s_axi_wdata(axi_wdata),
	.s_axi_wstrb(axi_wstrb),
	.s_axi_wvalid(axi_wvalid),
	.s_axi_wready(axi_wready),
	.s_axi_bresp(axi_bresp),
	.s_axi_bvalid(axi_bvalid),
	.s_axi_bready(axi_bready),
	.s_axi_araddr(axi_araddr),
	.s_axi_arvalid(axi_arvalid),
	.s_axi_arready(axi_arready),
	.s_axi_rdata(axi_rdata),
	.s_axi_rresp(axi_rresp),
	.s_axi_rvalid(axi_rvalid),
	.s_axi_rready(axi_rready)
);

logic [1:0] resp;
logic [31:0] rdat;

initial clk = 1'h0;
always #(TP/2) clk = ~clk;

int i;
initial begin
	rstn = 1'b0;
	repeat(10) @(negedge clk);
	rstn = 1'b1;
	repeat(10) @(posedge clk);
	master.wr_single(32'h00, 32'h33445566, resp);
	repeat(10) @(posedge clk);
	master.wr_single(32'h04, 32'h11223344, resp);
	repeat(10) @(posedge clk);
	master.rd_single(32'h00, rdat, resp);
	repeat(10) @(posedge clk);
	master.rd_single(32'h04, rdat, resp);
	repeat(10) @(posedge clk);
	$display("address     data");
	for (i=0; i<CFG_DATA_WIDTH/32; i++) begin
		$display("%h  %h", i*4, cfg_data[i*32+31-:32]);
	end
	$finish;
end

initial begin
	$dumpfile("axi_cfg_register_tb.vcd");
	$dumpvars(0, axi_cfg_register_tb);
end

endmodule
