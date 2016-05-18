`timescale 1ns / 1ps

module axi_bram_reader_tb #(
	// time periods
	realtime TP = 8.0ns // 125MHz
);

glbl glbl();

logic clk;
logic rstn;
logic wea;
logic [8:0] addra;
logic [63:0] dina;

logic clk2;
logic [31:0] axi_araddr;
logic axi_arvalid;
logic axi_arready;
logic [31:0] axi_rdata;
logic [1:0] axi_rresp;
logic axi_rvalid;
logic axi_rready;
logic [9:0] addrb;
logic [31:0] doutb;


blk_mem_gen bram0 (
	.clka(clk),
	.wea(wea),
	.addra(addra),
	.dina(dina),
	.douta(),
	.clkb(clk2),
	.web(1'b0),
	.addrb(addrb),
	.dinb('h0),
	.doutb(doutb)
);

axi_bram_reader #(
	.AXI_DATA_WIDTH(32),
	.AXI_ADDR_WIDTH(32),
	.BRAM_DATA_WIDTH(32),
	.BRAM_ADDR_WIDTH(10)
) reader0 (
	.aclk(clk),
	.aresetn(rstn),
	.s_axi_araddr(axi_araddr),
	.s_axi_arvalid(axi_arvalid),
	.s_axi_arready(axi_arready),
	.s_axi_rdata(axi_rdata),
	.s_axi_rresp(axi_rresp),
	.s_axi_rvalid(axi_rvalid),
	.s_axi_rready(axi_rready),
	.bram_porta_clk(clk2),
	.bram_porta_addr(addrb),
	.bram_porta_rddata(doutb)
);

axi_master_model_v1 #(
	.AW(32),
	.DW(32)
) master (
	.aclk_i(clk),
	.arstn_i(rstn),
	.axi_araddr_o(axi_araddr),
	.axi_arvalid_o(axi_arvalid),
	.axi_arready_i(axi_arready),
	.axi_rdata_i(axi_rdata),
	.axi_rresp_i(axi_rresp),
	.axi_rvalid_i(axi_rvalid),
	.axi_rready_o(axi_rready)
);



initial clk = 1'h0;
always #(TP/2) clk = ~clk;

logic [1:0] resp;
logic [31:0] rdat;

int i;
initial begin
	rstn = 1'b0;
	repeat(10) @(negedge clk);
	rstn = 1'b1;
	wea = 1'b0;
	repeat(10) @(posedge clk);
	wea = 1'b1;
	for (i=0; i<512; i++) begin
		@(posedge clk);
		addra = i;
		dina[31:0] = i*2;
		dina[63:32] = i*2+1;
	end
	@(posedge clk);
	wea = 1'b0;
	repeat(10) @(posedge clk);
	for (i=0; i<1024; i++) begin
		repeat(10) @(posedge clk);
		master.rd_single(i*4, rdat, resp);
		$display("%h %h", i, rdat);
	end
	repeat(10) @(posedge clk);
	$finish;
end

initial begin
	$dumpfile("axi_bram_reader_tb.vcd");
	$dumpvars(0, axi_bram_reader_tb);
end

endmodule
