`timescale 1ns/1ps
`define CYC 4

module  Traffic_Light_Controller_t;
    reg clk = 0, rst_n = 1'b1;
    reg car = 0;
    wire [3-1:0] hw_light, lr_light;

    Traffic_Light_Controller Traffic_Light( .clk(clk), .rst_n(rst_n), .lr_has_car(car), .hw_light(hw_light), .lr_light(lr_light) );

    always #(`CYC/2)    clk = ~clk;

    initial begin
        # `CYC;
        rst_n = 1'b0;
        # `CYC;
        rst_n = 1'b1;

// 102 cycles in a round.
        # (40*`CYC); // >35cycles;
        car = 1'b1;  // has car;
        # (55*`CYC); // lr_gl and still has car;
        car = 1'b0;  // lr_yl don't have car;
        # (12*`CYC); // back to start;

        # (15*`CYC); // <35cycles;
        car = 1'b1; // has car;
        # (42*`CYC); // lr_gl;
        car = 1'b0; // no car;
        # (45*`CYC); // back to start;

        # (30*`CYC); // <35cycles;
        car = 1'b1; // has car;
        # (72*`CYC); //back to start;
        # (101*`CYC) // one more round;
        


        #1 $finish;
    end
endmodule