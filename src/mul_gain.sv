module mul_gain 
#(
	parameter WD_IN = 24,
	parameter WD_OUT = 24
)
(
	// Input
	input logic [1:0] sel_in,
	input logic signed [WD_IN-1:0] data_in,
	// Output
	output logic signed [WD_OUT-1:0] data_out
);

// Cases
localparam KEEP = 2'b00;
localparam REMOVE = 2'b01;
localparam GAIN_UP_6dB = 2'b10;
localparam GAIN_DW_6dB = 2'b11;

always_comb begin
	case (sel_in)
		KEEP: begin
			data_out = data_in;
		end
		REMOVE: begin
			data_out = 24'sd0;
		end
		GAIN_UP_6dB: begin					// +6dB gain
			data_out = data_in <<< 1;
		end
		GAIN_DW_6dB: begin					// -6dB gain
			data_out = (data_in + (data_in[0] ? 1 : 0)) >>> 1;	
		end
		default: data_out = 24'sd0;
	endcase
end

endmodule 