`timescale 1ns / 1ps

module blk_mem_gen_tb #(
	// time periods
	realtime TP = 8.0ns // 125MHz
);

logic clk;
logic wea;
logic [8:0] addra;
logic [63:0] dina;
logic [9:0] addrb;
logic [31:0] doutb;

blk_mem_gen bram0 (
	.clka(clk),
	.wea(wea),
	.addra(addra),
	.dina(dina),
	.douta(),
	.clkb(clk),
	.web(1'b0),
	.addrb(addrb),
	.dinb('h0),
	.doutb(doutb)
);


initial clk = 1'h0;
always #(TP/2) clk = ~clk;

int i;
initial begin
	wea = 1'b0;
	repeat(10) @(posedge clk);
	for (i=0; i<512; i++) begin
		@(posedge clk);
		wea = 1'b1;
		addra = i;
		dina[31:0] = i*2;
		dina[63:32] = i*2+1;
	end
	@(posedge clk);
	wea = 1'b0;
	repeat(10) @(posedge clk);
	for (i=0; i<1024; i++) begin
		addrb = i;
		@(posedge clk);
	end
	repeat(10) @(posedge clk);
	$finish;
end

initial begin
	$monitor("@ %gns addrb = %h, doutb = %h", $time, addrb, doutb);
	$dumpfile("blk_mem_gen_tb.vcd");
	$dumpvars(0, blk_mem_gen_tb);
end

endmodule
