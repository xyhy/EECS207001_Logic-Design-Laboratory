`timescale 1ns/1ps

module Decoder_t;
reg  [4-1:0] a = 0;
wire [16-1:0] b;

Decoder d1 (
  .din (a),
  .dout (b)
);

initial begin
  repeat (2 ** 4) begin
    #1 
    a = a + 3'b1;
  end
  #1 $finish;
end
endmodule











