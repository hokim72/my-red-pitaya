`timescale 1ns / 1ps

module bcntr_tb #(
	// time periods
	realtime TP = 8.0ns // 125MHz
);

logic clk;
logic [31:0] q;

bcntr cntr0(
	.CLK(clk),
	.Q(q)
);

initial clk = 1'h0;
always #(TP/2) clk = ~clk;

initial begin
	repeat(100) @(posedge clk);
	$finish;
end

initial begin
	$dumpfile("bcntr_tb.vcd");
	$dumpvars(0, bcntr_tb);
end

endmodule
