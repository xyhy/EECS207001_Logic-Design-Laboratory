`timescale 1ns/1ps

module Mux_8bit_t;
reg [8-1:0] a = 8'b0;
reg [8-1:0] b = 8'b11110000;
reg [8-1:0] c = 8'b10101010;
reg [8-1:0] d = 8'b01010101;
reg sel1=1'b0,sel2=1'b0,sel3=1'b0;
wire [8-1:0] f;

Mux_8bits m1 (
  .a (a),
  .b (b),
  .c(c),
  .d(d),
  .sel1 (sel1),
  .sel2 (sel2),
  .sel3 (sel3),
  .f (f)
);

initial begin
  repeat (2**3) begin
    #1{sel1,sel2,sel3} = {sel1,sel2,sel3} + 1'b1;
  end
  
  #1 $finish;
end
endmodule
