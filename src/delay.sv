/* Delay with {N} Cycles
// Adjust the parameter*/
module delay 
#(
	parameter DATA_WIDTH = 24,
	parameter N_cycles = 3
)
(
	// Input
	input clk_i,
	input clr_i,
	input [DATA_WIDTH-1:0] data_i,
	
	// Output 
	output [DATA_WIDTH-1:0] data_o
);

wire [DATA_WIDTH-1:0] tmp [N_cycles-1:0];

genvar i;

generate
	DFlop
	#(
		.DATA_WIDTH		(DATA_WIDTH)
	)
	dff_first
	(
		.clk_i			(clk_i),
		.clr_i			(clr_i),
		.d_i				(data_i),
		.q_o				(tmp[0])
	);
	
	for (i = 1; i < N_cycles; i = i + 1) begin: PROCEDURE_LOOP
		DFlop 
		#(
			.DATA_WIDTH			(DATA_WIDTH)
		)
		dff_loop
		(
			.clk_i		(clk_i),
			.clr_i		(clr_i),
			.d_i			(tmp[i-1]),
			.q_o			(tmp[i])
		);
	end
	
	assign data_o = tmp[N_cycles-1];
endgenerate

endmodule 