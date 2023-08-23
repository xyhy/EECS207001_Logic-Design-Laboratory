`timescale 1ns/1ps

module Carry_Look_Ahead_Adder_t;
// global clock signal: change input at either edge
reg CLK = 1;

// inputs to module
reg [4-1:0] A, B;
reg Cin;
reg pass=1;
// outputs from module
wire [4-1:0] Sum;
wire Cout;

// instantiate  module
Carry_Look_Ahead_Adder testing_instance (
  .a (A),
  .b (B),
  .cin (Cin),
  .sum (Sum),
  .cout (Cout)
);

// clk period = 5 * 2 = 10 ns 
always #0.5 CLK = ~CLK;

// main testing
initial begin
  {A, B, Cin} = 9'b0;
	 
  repeat (2 ** 9) begin
	@ (posedge CLK)
		Test;
    @ (negedge CLK)
		{A, B, Cin} = {A, B, Cin} + 1'b1;
  end

  $finish;
end

// utility task for testing
task Test;
begin
	if({Cout, Sum} !== (A + B + Cin))begin
		pass=0;
		$display("[ERROR]");
		$write("A:%d",A);
		$write("B:%d",B);
		$write("Cin:%d",Cin);
		$write("Cout:%d",Cout);
		$write("Sum:%d",Sum);
		$display;
	end
	else begin
		pass=1;
	end
end
endtask

endmodule
