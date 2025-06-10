module IIR_bass 
#(
	parameter WD_IN = 24,
	parameter WD_OUT = 24,
	parameter WD_CO = 32,
	parameter N = 5												// Order + 1
)
(
	input logic clk,
	input logic reset_n,
	input logic signed [WD_IN-1:0] data_in,
	output logic signed [WD_OUT-1:0] data_out
);

localparam b_path = "../coeffs/bass/b_coeffs.hex";

localparam a_path = "../coeffs/bass/a_coeffs.hex";

logic signed [WD_IN-1:0] dl_input;

logic signed [WD_CO-1:0] b_coeffs [N-1:0];
logic signed [WD_CO-1:0] a_coeffs [N-2:0];

logic signed [WD_CO+WD_OUT-1:0] mul_b [N-1:0];

logic signed [WD_CO+WD_OUT:0] acc [N-1:0];

logic signed [WD_OUT-1:0] acc_out;

initial begin
	$readmemh(b_path, b_coeffs);
	$readmemh(a_path, a_coeffs);
end

always @(posedge clk or negedge reset_n) begin
	integer i;
	if (!reset_n) begin
		dl_input <= 24'sd0;
		acc_out = 24'sd0;
		data_out <= 24'sd0;
		for (i = 0; i < N; i++) begin
			mul_b[i] <= 56'sd0;
		end
		for (i = N-1; i >= 0; i--) begin
			acc[i] <= 57'sd0;
		end
	end
	else begin
		dl_input <= data_in;
		for (i = 0; i < N; i++) begin
			mul_b[i] <= dl_input * b_coeffs[i];
		end
		acc[N-1] <= 57'sd0;
		acc_out = (acc[0] + mul_b[0]) >>> 28;
		for (i = N-2; i >= 0; i--) begin
			acc[i] <= acc[i+1] + mul_b[i+1] - (acc_out * a_coeffs[i]);
		end
		data_out <= acc_out;
	end
end
												
endmodule 