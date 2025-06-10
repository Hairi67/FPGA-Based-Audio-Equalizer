module DFlop 
#(
	parameter DATA_WIDTH = 24
)
(
	// Input
	input clk_i,
	input clr_i,
	input [DATA_WIDTH-1:0] d_i,
	
	// Output 
	output reg [DATA_WIDTH-1:0] q_o
);

always @(posedge clk_i) begin
	if (clr_i == 1) begin
		q_o <= 0;
	end
	else begin
		q_o <= d_i;
	end
end

endmodule 