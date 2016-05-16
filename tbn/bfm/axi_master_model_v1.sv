`timescale 1ns / 1ps

module axi_master_model_v1 #(
	parameter AW = 32,
	parameter DW = 32
)(
	input  logic			aclk_i,
	input  logic			arstn_i,

	output logic [AW-1:0]	axi_awaddr_o,
	output logic			axi_awvalid_o,
	input  logic			axi_awready_i,
	output logic [DW-1:0]	axi_wdata_o,
	output logic [DW/8-1:0]	axi_wstrb_o,
	output logic			axi_wvalid_o,
	input  logic			axi_wready_i,
	input  logic [1:0]		axi_bresp_i,
	input  logic			axi_bvalid_i,
	output logic			axi_bready_o,
	output logic [AW-1:0]	axi_araddr_o,
	output logic			axi_arvalid_o,
	input  logic			axi_arready_i,
	input  logic [DW-1:0]	axi_rdata_i,
	input  logic [1:0]		axi_rresp_i,
	input  logic			axi_rvalid_i,
	output logic			axi_rready_o
);

logic	wr_idle;
logic	rd_idle;

initial begin
	axi_awaddr_o = 'h0;
	axi_awvalid_o = 1'b0;
	axi_wdata_o = 'h0;
	axi_wstrb_o = 'h0;
	axi_wvalid_o = 1'b0;
	axi_bready_o = 1'b1;
	axi_araddr_o = 'h0;
	axi_arvalid_o = 1'b0;
	axi_rready_o = 1'b1;
end

// Write single data task
task wr_single;
	input  [AW-1:0] adr_i;
	input  [DW-1:0] dat_i;
	output [1:0]	resp_o;

	logic  [1:0]	dat_resp;
	logic			in_use;

begin:main
	if (in_use === 1'b1)
	begin
		$display("%m re-entered @ %t", $time);
		in_use = 1'b0;
		disable main;
	end

	if (arstn_i !== 1'b1)
	begin
		$display("%m called during axi reset @ %t", $time);
		disable main;
	end

	in_use = 1'b1;
	wr_idle = 1'b0;

	fork 
	begin // address
		@(posedge aclk_i);
		axi_awaddr_o = adr_i;
		axi_awvalid_o = 1'b1;

		@(posedge aclk_i);
		while (axi_awready_i === 1'b0)
			@(posedge aclk_i);
		axi_awvalid_o = 1'b0;
	end
	begin // data
		@(posedge aclk_i);
		axi_wvalid_o = 1'b1;
		axi_wdata_o = dat_i;
		axi_wstrb_o = {(DW/8){1'b1}};

		@(posedge aclk_i);
		while(axi_wready_i === 1'b0)
			@(posedge aclk_i);
		axi_wvalid_o = 1'b0;
	end
	join

	@(posedge aclk_i);
	while (axi_bvalid_i === 1'b0) begin
		@(posedge aclk_i);
	end

	in_use = 1'b0;
	wr_idle = 1'b1;
	@(posedge aclk_i);

	resp_o = axi_bresp_i;
end
endtask: wr_single

// Read single data task

task rd_single;
	input  [AW-1:0]   adr_i;
	output [DW-1:0]   dat_o;
	output [1:0]      resp_o;

	logic  [1:0]	  dat_resp;
	logic			  in_use;
begin:main

	if (in_use === 1'b1)
	begin
		$display("%m re-entered @ %t", $time);
		in_use = 1'b0;
		disable main;
	end

	if (arstn_i !== 1'b1)
	begin
		$display("%m called during axi reset @ %t", $time);
		disable main;
	end

	in_use = 1'b1;
	rd_idle = 1'b0;

	@(posedge aclk_i);
	axi_araddr_o = adr_i;
	axi_arvalid_o = 1'b1;

	@(posedge aclk_i);
	while (axi_arready_i === 1'b0)
		@(posedge aclk_i);

	axi_arvalid_o = 1'b0;
	axi_rready_o = 1'b1;

	while (axi_rvalid_i === 1'b0)
		@(posedge aclk_i);

	axi_rready_o = 1'b0;

	if (axi_rresp_i !== 0)
		$display("%m Received ERROR response! @ %t", $time);
	else
		begin
			$display("%m Received data = 0x%h @ %t", axi_rdata_i, $time);
			dat_o = axi_rdata_i;
		end

	in_use = 1'b0;
	rd_idle = 1'b1;
	@(posedge aclk_i);

	resp_o <= axi_rresp_i;
end
endtask: rd_single

endmodule: axi_master_model_v1
