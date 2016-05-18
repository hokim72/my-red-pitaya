`timescale 1ns / 1ps

module fifo36e1_tb #(
	// time periods
	realtime TP = 8.0ns // 125MHz
);

glbl glbl();

logic clk;
logic rstn;
logic full;
//logic empty;
wire empty;
logic wren;
logic [63:0] wdata;
logic rden;
logic [71:0] rdata0;
logic [63:0] rdata;
logic rderr;

FIFO36E1 #(
	.FIRST_WORD_FALL_THROUGH("TRUE"),
	.ALMOST_EMPTY_OFFSET(13'hf),
	.DATA_WIDTH(72),
	.FIFO_MODE("FIFO36_72")
) fifo0 (
	.FULL(full),
	.ALMOSTEMPTY(empty),
	.RST(~rstn),
	.WRCLK(clk),
	.WREN(wren),
	.DI(wdata),
	.RDCLK(clk),
	.RDEN(rden),
	.DO(rdata0),
	.RDERR(rderr)
);


assign rdata = rdata0[63:0];

initial clk = 1'h0;
always #(TP/2) clk = ~clk;

int i;
initial begin
	$monitor("@ %gns rdata = %0d, empty = %b, rderr = %b", $time, rdata, empty, rderr);
	wren = 1'b0;
	rden = 1'b0;
	rstn = 1'b0;
	repeat(10) @(negedge clk);
	rstn = 1'b1;
	repeat(10) @(posedge clk);
	wren = 1'b1;
	rden = 1'b0;
	for (i=0; i<64; i++) begin
		wdata = 72'h1 + i;
		@(posedge clk);
	end
	wren = 1'b0;
	repeat(10) @(posedge clk);
	rden = 1'b1;
	for (i=0; i<64; i++) begin
		@(posedge clk);
	end
	wren = 1'b0;
	rden = 1'b0;
	repeat(10) @(posedge clk);
	$finish;
end

initial begin
	$dumpfile("fifo36e1_tb.vcd");
	$dumpvars(0, fifo36e1_tb);
end

endmodule

