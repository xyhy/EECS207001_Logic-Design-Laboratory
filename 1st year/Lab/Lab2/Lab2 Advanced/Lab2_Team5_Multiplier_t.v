`timescale 1ns/1ps

module Multiplier_t;

reg CLK = 1;

reg [4-1:0]a;
reg [4-1:0]b;
wire [7:0] p ;
reg pass=1;

Multiplier c1 (
  .a (a),
  .b (b),
  .p (p)
);

always #0.5 CLK = ~CLK;

initial begin
    {a, b} = 8'b0;
    repeat(2**8)begin
    @ (posedge CLK)
      Test;
    @ (negedge CLK)
      {a, b} ={a, b} + 1'b1;
    end
    $finish;
end


task Test;
begin 

  if(p !== (a*b))begin
    pass=0;
		$display("[ERROR]");
		$write("A:%d",a);
		$write("B:%d",b);
    $write("A * B = %d",a*b);
		$write("multiplier_answer:%d",p);
		$display;
	end
  else begin
    pass =1;
  end
end
endtask

endmodule