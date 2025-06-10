module filter (
	// Input
	input logic clk,
	input logic reset_n,
	input logic signed [23:0] data_in,
	// Test input
	input logic [1:0] bass_sel_in,
	input logic [1:0] mid_sel_in,
	input logic [1:0] treble_sel_in,
	// Test output
	output logic signed [23:0] bass_out,
	output logic signed [23:0] mid_out,
	output logic signed [23:0] treble_out,
	// Test output gain
	output logic signed [23:0] bass_eql,
	output logic signed [23:0] mid_eql,
	output logic signed [23:0] treble_eql,
	// Output
	output logic signed [23:0] data_out
);

wire signed [23:0] treble_fix;

// Bass section
IIR_bass bass_dut(
	.clk				(clk),
	.reset_n			(reset_n),
	.data_in			(data_in),
	.data_out		(bass_out)
);

mul_gain gain_bass(
	.sel_in			(bass_sel_in),
	.data_in			(bass_out),
	.data_out		(bass_eql)
);

// Mid section
FIR_mid  mid_dut(
	.clk				(clk),
	.reset_n			(reset_n),
	.data_in			(data_in),
	.data_out		(mid_out)
);

mul_gain gain_mid(
	.sel_in			(mid_sel_in),
	.data_in			(mid_out),
	.data_out		(mid_eql)
);

// Treble section
filter_treble treble_dut(
	.clk				(clk),
	.reset_n			(reset_n),
	.data_in			(data_in),
	.data_out		(treble_out)
);

assign treble_fix = treble_out >>> 1;

mul_gain gain_treble(
	.sel_in			(treble_sel_in),
	.data_in			(treble_fix),
	.data_out		(treble_eql)
);

assign data_out = bass_eql + mid_eql + treble_eql;

endmodule 