// Main program: Use testbench from this file

module FIR_mid
#(
	parameter WD_IN = 24,									// Data_width of input data
	parameter WD_OUT = 24,									// Data_width of output data
	parameter CO_WD = 24,									// Data_width of coefficient data
	parameter CO_OR = 40
)
(
	// Input
	input logic clk,											// Input clock signal
	input logic reset_n,										// Negative reset signal
	input logic signed [WD_IN-1:0] data_in,			// Input data
	// Output
	output logic signed [WD_OUT-1:0] data_out			// Output data
	
	// Test:
//	output logic [CO_WD-1:0] delay_buffer,
//	output logic signed [2*CO_WD-1:0] tmp_reg
);

logic signed [CO_WD-1:0] COEF [CO_OR-1:0] = '{
24'h000002, 24'h000008, 24'h00000D, 24'h00001A, 24'h00001F, 24'h00001E, 
24'h000013, 24'h000000, 24'hFFFFE0, 24'hFFFFC6, 24'hFFFFA5, 24'hFFFF8F, 
24'hFFFF84, 24'hFFFF92, 24'hFFFFB2, 24'hFFFFD7, 24'h000035, 24'h00008A, 
24'h0000CF, 24'h000103, 24'h000103, 24'h0000CF, 24'h00008A, 24'h000035, 
24'hFFFFD7, 24'hFFFFB2, 24'hFFFF92, 24'hFFFF84, 24'hFFFF8F, 24'hFFFFA5, 
24'hFFFFC6, 24'hFFFFE0, 24'h000000, 24'h000013, 24'h00001E, 24'h00001F, 
24'h00001A, 24'h00000D, 24'h000008, 24'h000002
};

reg signed [WD_OUT-1:0] acc [CO_OR:0];
logic signed [CO_WD+WD_IN-1:0] tmp, delay_tmp;
logic signed [WD_IN-1:0] delay_input;

// Delay 1 cycle for input
delay
#(
	.DATA_WIDTH			(WD_IN),
	.N_cycles			(1)
)
dl
(
	.clk_i				(clk),
	.clr_i				(~reset_n),
	.data_i				(data_in),
	.data_o				(delay_input)
);

always_ff @(posedge clk or negedge reset_n) begin
	integer i;
	if (!reset_n) begin
		data_out = 24'sd0;
		for (i = 0; i < CO_OR; i++) begin
			acc[0] <= 24'sd0;
		end
	end
	else begin
		acc[CO_OR] <= 24'sd0;
		for (i = 0; i < CO_OR; i++) begin
			tmp = delay_input * COEF[i];											// Delay 1 cycle after multiply
			acc[i] <= acc[i+1] + tmp[(2*WD_OUT)-2:WD_OUT-1];			// Delay 1 cycle after calculate the accumulation
		end
		if (acc[0] === 24'hxxxxxx) begin
			data_out = 24'sd0;
		end
		else data_out = acc[0];
	end	
end

endmodule 