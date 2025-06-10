// Main program: Use testbench from this file

module filter_treble
#(
	parameter WD_IN = 24,									// Data_width of input data
	parameter WD_OUT = 24,									// Data_width of output data
	parameter CO_WD = 24,									// Data_width of coefficient data
	parameter CO_OR = 30
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

logic signed [CO_WD-1:0] COEF [CO_OR-1:0] = '{24'hffb15c,
24'hffec57,
24'hff58e3,
24'h6f69,  
24'hff559c,
24'h25e35, 
24'h6594,  
24'h428f5,
24'hd1b7,
24'h2752,
24'hfde354,
24'hf1652c,
24'hfc4674,
24'hd3edfb,
24'h39a36e,
24'h39a36e,
24'hd3edfb,
24'hfc4674,
24'hf1652c,
24'hfde354,
24'h2752,
24'hd1b7,
24'h428f5,
24'h6594,
24'h25e35,
24'hff559c,
24'h6f69,
24'hff58e3,
24'hffec57,
24'hffb15c};

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