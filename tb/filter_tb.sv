`timescale 1ns/1ns

module filter_tb ();
  localparam FILE_PATH = "E:/Study-related_stuff/EE3041_XLTHSFPGA/EE3041_DSPonFPGA-main/EE3041_DSPonFPGA-main/Lab1/SFTM.hex";
  localparam OUT_PATH  = "E:/Study-related_stuff/EE3041_XLTHSFPGA/EE3041_DSPonFPGA-main/EE3041_DSPonFPGA-main/Lab1/samples/output.hex";
  localparam FREQ = 100_000_000;

  localparam WD_IN       = 24                ; // Data width
  localparam WD_OUT      = 24                ;
  localparam PERIOD      = 1_000_000_000/FREQ;
  localparam HALF_PERIOD = PERIOD/2          ;

  // Testbench signals
  reg               clk, reset_n;
  reg  [ WD_IN-1:0] data_in ;
  wire [WD_OUT-1:0] data_out;
  
  // Testbench gain
  reg	 [1:0]			bass_sel, mid_sel, treble_sel;
  
  // 3 Filter out
  wire [WD_OUT-1:0] bass_out;
  wire [WD_OUT-1:0] mid_out;
  wire [WD_OUT-1:0] treble_out;
  
  // 3 Filter out
  wire [WD_OUT-1:0] bass_gain;
  wire [WD_OUT-1:0] mid_gain;
  wire [WD_OUT-1:0] treble_gain;

  integer file, status, outfile;

  real analog_in, analog_out;
  assign analog_in  = $itor($signed(data_in));
  assign analog_out = $itor($signed(data_out));
  
  // Filter analog out
  real analog_bass, analog_mid, analog_treble;
  real gain_bass, gain_mid, gain_treble;
  
  assign analog_bass = $itor($signed(bass_out));
  assign analog_mid = $itor($signed(mid_out));
  assign analog_treble = $itor($signed(treble_out));
  
  assign gain_bass = $itor($signed(bass_gain));
  assign gain_mid = $itor($signed(mid_gain));
  assign gain_treble = $itor($signed(treble_gain));

  // Instantiate the FIR filter module
  filter dut (
  // Sys
    .clk									(clk     ),
    .reset_n							(reset_n ),
	 // Data_in
    .data_in							(data_in ),
	 // Sel_in
	 .bass_sel_in						(bass_sel),
	 .mid_sel_in						(mid_sel),
	 .treble_sel_in					(treble_sel),
	 // Filter stage
	 .bass_out							(bass_out),
	 .mid_out							(mid_out),
	 .treble_out						(treble_out),
	 // Gain stage
	 .bass_eql							(bass_gain),
	 .mid_eql							(mid_gain),
	 .treble_eql						(treble_gain),
	 // Final stage
    .data_out							(data_out)
  );

  // Clock generation
  always #HALF_PERIOD clk = ~clk;

  // Test procedure
  initial begin
    // Initialize inputs
    clk     = 0;
    reset_n = 0;
    data_in = 0;

    // Apply reset
    #PERIOD reset_n = 1;  // Deassert reset after a period
	 
	 // Apply aud_eql gain
	 bass_sel	=	2'b00;
	 mid_sel	=	2'b00;
	 treble_sel	=	2'b00;

    // Read hex file
    file = $fopen(FILE_PATH,"r");
    outfile = $fopen(OUT_PATH, "w");
    if (file == 0)    $error("Hex file not opened");
    if (outfile == 0) $error("Output file not opened");
    do begin
      status = $fscanf(file, "%h", data_in);
      @(posedge clk);
      $fdisplay(outfile, "%h", data_out);
    end while (status != -1);

    // Wait for a while to observe output
    #100 $finish;  // Stop simulation after 100 time units
    $fclose(file);
    $fclose(outfile);
  end

  // Monitor signals for debugging
  initial begin
    $monitor("Time = %0t | Reset = %b | Data In = %h | Data Out = %h | Bass Out = %h | Mid Out = %h | Treble Out = %h",
      $time, reset_n, data_in, data_out, bass_out, mid_out, treble_out);
  end

endmodule