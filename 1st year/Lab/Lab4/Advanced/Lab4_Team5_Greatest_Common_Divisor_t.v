`timescale 1ns/1ps
`define CYC 4

module  Greatest_Common_Divisor_t;
    reg clk=0, rst_n;
    reg Begin;
    reg [16-1:0] a;
    reg [16-1:0] b;
    wire Complete;
    wire [16-1:0] gcd;
    //reg [16-1:0] comp_gcd;
    //reg pass;

    Greatest_Common_Divisor GCD ( .clk(clk), .rst_n(rst_n), .Begin(Begin), .a(a), .b(b), .Complete(Complete), .gcd(gcd) ) ;

    always #(`CYC/2) clk = ~clk;

    initial begin
        rst_n = 1'b1;
        # `CYC;
        rst_n = 1'b0;
        # `CYC;
        rst_n = 1'b1;


// test Begin = 0, do not do anything.
        @(negedge clk)begin
            Begin = 1'b0;
            a = 16'd12;
            b = 16'd20;
        end

        # (`CYC*2);
        
// test GCD = a.
        @(negedge clk)begin
            Begin = 1'b1;
            a = 16'd5;
            b = 16'd20;
        end
        
        
// test GCD = b.       
        @(Complete==1) begin
            # (`CYC*2);
            @(negedge clk)begin
                Begin = 1'b1;
                a = 16'd63;
                b = 16'd7;
            end
        end

// test GCD = 1. -> 2 prime numbers.        
        @(Complete==1) begin
            # (`CYC*2);
            @(negedge clk)begin
                Begin = 1'b1;
                a = 16'd11;
                b = 16'd97;
            end
        end

// test GCD = 1. -> 2 not prime numbers.
        @(Complete==1) begin
            # (`CYC*2);
        @(negedge clk)begin
            Begin = 1'b1;
            a = 16'd20;
            b = 16'd9;
        end
        end

        
//checking GCD != a, b, 1.  (2 cases)
        @(Complete==1) begin
            # (`CYC*2);
        @(negedge clk)begin
            Begin = 1'b1;
            a = 16'd30;
            b = 16'd12;
        end
        end

        @(Complete==1) begin
            # (`CYC*2);
            @(negedge clk)begin
                Begin = 1'b1;
                a = 16'd18;
                b = 16'd100;
            end
        end

        #1 $finish;
    end
endmodule