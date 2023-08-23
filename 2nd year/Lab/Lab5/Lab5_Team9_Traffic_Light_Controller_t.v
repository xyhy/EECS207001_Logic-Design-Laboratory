`timescale 1ns/1ps
`define CYC 4

module  Traffic_Light_Controller_t;
    reg clk = 1, rst_n = 1'b1;
    reg car = 0;
    wire [3-1:0] hw_light, lr_light;

    Traffic_Light_Controller Traffic_Light( .clk(clk), .rst_n(rst_n), .lr_has_car(car), .hw_light(hw_light), .lr_light(lr_light) );

    always #(`CYC/2)    clk = ~clk;

    initial begin
        # (`CYC/2);
        rst_n = 1'b0;
        # `CYC;
        rst_n = 1'b1;


        # (70*`CYC); 
        car = 1'b1;  // has car but < 80;
        # (31*`CYC); //lr = green but don't has car
        car = 1'b0;
        # (101*`CYC); //銝��儐�

        # (100*`CYC); // <80 雿���
        car = 1'b1; // has car;//��府霈���
        # (21*`CYC); // lr_gl;
        car = 1'b0; // no car;
        # (101*`CYC); 
        
         # (260*`CYC); // EXEED 8 BIT = 256
        car = 1'b1; // has car;//��府霈���
        # (21*`CYC); // lr_gl;
        car = 1'b0; // no car;
        # (101*`CYC); 
        


        #1 $finish;
    end
endmodule