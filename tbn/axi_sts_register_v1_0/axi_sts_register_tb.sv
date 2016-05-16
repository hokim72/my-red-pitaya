`timescale 1ns / 1ps

module axi_sts_register_tb #(
	// time periods
	realtime TP = 8.0ns, // 125MHz
	parameter CFG_DATA_WIDTH = 1024,
	parameter STS_DATA_WIDTH = 1024
);

glbl glbl();

logic [CFG_DATA_WIDTH-1:0] cfg_data;
logic [STS_DATA_WIDTH-1:0] sts_data;

logic clk;
logic rstn;

logic [31:0] 	axi_awaddr[3];
logic 			axi_awvalid[3];
logic			axi_awready[3];
logic [31:0]	axi_wdata[3];
logic [3:0]		axi_wstrb[3];
logic			axi_wvalid[3];
logic			axi_wready[3];
logic [1:0]		axi_bresp[3];
logic 			axi_bvalid[3];
logic			axi_bready[3];
logic [31:0]	axi_araddr[3];
logic			axi_arvalid[3];
logic			axi_arready[3];
logic [31:0]	axi_rdata[3];
logic [1:0]		axi_rresp[3];
logic			axi_rvalid[3];
logic			axi_rready[3];

axi_master_model_v1 #(
	.AW(32),
	.DW(32)
) master (
	.aclk_i(clk),
	.arstn_i(rstn),
	.axi_awaddr_o(axi_awaddr[0]),
	.axi_awvalid_o(axi_awvalid[0]),
	.axi_awready_i(axi_awready[0]),
	.axi_wdata_o(axi_wdata[0]),
	.axi_wstrb_o(axi_wstrb[0]),
	.axi_wvalid_o(axi_wvalid[0]),
	.axi_wready_i(axi_wready[0]),
	.axi_bresp_i(axi_bresp[0]),
	.axi_bvalid_i(axi_bvalid[0]),
	.axi_bready_o(axi_bready[0]),
	.axi_araddr_o(axi_araddr[0]),
	.axi_arvalid_o(axi_arvalid[0]),
	.axi_arready_i(axi_arready[0]),
	.axi_rdata_i(axi_rdata[0]),
	.axi_rresp_i(axi_rresp[0]),
	.axi_rvalid_i(axi_rvalid[0]),
	.axi_rready_o(axi_rready[0])
);

axi_cfg_register #(
	.CFG_DATA_WIDTH(CFG_DATA_WIDTH),
	.AXI_DATA_WIDTH(32),
	.AXI_ADDR_WIDTH(32)
) cfg0 (
	.aclk(clk),
	.aresetn(rstn),
	.cfg_data(cfg_data),
	.s_axi_awaddr(axi_awaddr[1]),
	.s_axi_awvalid(axi_awvalid[1]),
	.s_axi_awready(axi_awready[1]),
	.s_axi_wdata(axi_wdata[1]),
	.s_axi_wstrb(axi_wstrb[1]),
	.s_axi_wvalid(axi_wvalid[1]),
	.s_axi_wready(axi_wready[1]),
	.s_axi_bresp(axi_bresp[1]),
	.s_axi_bvalid(axi_bvalid[1]),
	.s_axi_bready(axi_bready[1]),
	.s_axi_araddr(axi_araddr[1]),
	.s_axi_arvalid(axi_arvalid[1]),
	.s_axi_arready(axi_arready[1]),
	.s_axi_rdata(axi_rdata[1]),
	.s_axi_rresp(axi_rresp[1]),
	.s_axi_rvalid(axi_rvalid[1]),
	.s_axi_rready(axi_rready[1])
);

axi_sts_register #(
	.STS_DATA_WIDTH(STS_DATA_WIDTH),
	.AXI_DATA_WIDTH(32),
	.AXI_ADDR_WIDTH(32)
) sts0 (
	.aclk(clk),
	.aresetn(rstn),
	.sts_data(sts_data),
	.s_axi_araddr(axi_araddr[2]),
	.s_axi_arvalid(axi_arvalid[2]),
	.s_axi_arready(axi_arready[2]),
	.s_axi_rdata(axi_rdata[2]),
	.s_axi_rresp(axi_rresp[2]),
	.s_axi_rvalid(axi_rvalid[2]),
	.s_axi_rready(axi_rready[2])
);

assign sts_data = cfg_data;

logic [1:0] resp;
logic [31:0] rdat;

initial clk = 1'h0;
always #(TP/2) clk = ~clk;

logic sel;
always_comb
begin
	case (sel)
		1'b0: begin
			axi_awaddr[1] = axi_awaddr[0];
			axi_awvalid[1] = axi_awvalid[0];
			axi_awready[0] = axi_awready[1];
			axi_wdata[1] = axi_wdata[0];
			axi_wstrb[1] = axi_wstrb[0];
			axi_wvalid[1] = axi_wvalid[0];
			axi_wready[0] = axi_wready[1];
			axi_bresp[0] = axi_bresp[1];
			axi_bvalid[0] = axi_bvalid[1];
			axi_bready[1] = axi_bready[0];
			axi_araddr[1] = axi_araddr[0];
			axi_arvalid[1] = axi_arvalid[0];
			axi_arready[0] = axi_arready[1];
			axi_rdata[0] = axi_rdata[1];
			axi_rresp[0] = axi_rresp[1];
			axi_rvalid[0] = axi_rvalid[1];
			axi_rready[1] = axi_rready[0];
		end
		1'b1: begin
			axi_awaddr[2] = axi_awaddr[0];
			axi_awvalid[2] = axi_awvalid[0];
			axi_awready[0] = axi_awready[2];
			axi_wdata[2] = axi_wdata[0];
			axi_wstrb[2] = axi_wstrb[0];
			axi_wvalid[2] = axi_wvalid[0];
			axi_wready[0] = axi_wready[2];
			axi_bresp[0] = axi_bresp[2];
			axi_bvalid[0] = axi_bvalid[2];
			axi_bready[2] = axi_bready[0];
			axi_araddr[2] = axi_araddr[0];
			axi_arvalid[2] = axi_arvalid[0];
			axi_arready[0] = axi_arready[2];
			axi_rdata[0] = axi_rdata[2];
			axi_rresp[0] = axi_rresp[2];
			axi_rvalid[0] = axi_rvalid[2];
			axi_rready[2] = axi_rready[0];
		end
	endcase
end

int i;
initial begin
	sel = 1'b0;
	rstn = 1'b0;
	repeat(10) @(negedge clk);
	rstn = 1'b1;
	repeat(10) @(posedge clk);
	master.wr_single(32'h04, 32'h33445566, resp);
	repeat(10) @(posedge clk);
	master.wr_single(32'h60, 32'h11223344, resp);
	repeat(10) @(posedge clk);
	master.rd_single(32'h04, rdat, resp);
	repeat(10) @(posedge clk);
	master.rd_single(32'h60, rdat, resp);
	repeat(10) @(posedge clk);
	sel = 1'b1;
	master.rd_single(32'h04, rdat, resp);
	repeat(10) @(posedge clk);
	master.rd_single(32'h60, rdat, resp);
	repeat(10) @(posedge clk);
	$display("address     data");
	for (i=0; i<CFG_DATA_WIDTH/32; i++) begin
		$display("%h  %h", i*4, cfg_data[i*32+31-:32]);
	end
	$finish;
end

initial begin
	$dumpfile("axi_sts_register_tb.vcd");
	$dumpvars(0, axi_sts_register_tb);
end

endmodule
