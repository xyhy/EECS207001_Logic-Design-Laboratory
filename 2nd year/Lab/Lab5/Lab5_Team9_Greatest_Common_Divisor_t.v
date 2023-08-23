
module GCD_t();

reg clk = 0, rst = 1, start = 0;
reg [15:0] a=1, b=0;
wire done;
wire [15:0] gcd;

    Greatest_Common_Divisor GCD ( .clk(clk), .rst_n(rst), .start(start), .a(a), .b(b), .done(done), .gcd(gcd) );
    always #1 clk = ~clk;

    initial begin

        $fsdbDumpfile("GCD.fsdb");
        $fsdbDumpvars;

        @(negedge clk)
            rst = 0;
        @(negedge clk)
            rst = 1;
            //gcd = a = 5;
            start = 1;
            a = 16'd5;
            b = 16'd200;

        @(done == 1) begin
            test;
            #4;
            //gcd = b= 7;
            @(negedge clk)
                a = 16'd63;
                b = 16'd7;
        end

        @(done == 1) begin
            test;
            #4;
            //gcd = 1(prime);
            @(negedge clk)
                a = 16'd97;
                b = 16'd11;
        end

        @(done == 1) begin
            test;
            #4;
            //gcd = 1(not prime);
            @(negedge clk)
                a = 16'd25;
                b = 16'd192;
        end

        @(done == 1) begin
            test;
            #4;
            //no start
            @(negedge clk)
                start = 0;
                a = 16'd2;
                b = 16'd1;
        end
            #20;
            //big num test
            @(negedge clk)
                start = 1;
                a = 16'd35747;
                b = 16'd21483;
        repeat(50) begin
            @(done == 1) begin
            test;
            #4;
            @(negedge clk)
                a = a + 16'd212;
                b = b + 16'd307;
        end
        end

        #2 $finish;
    end

    task test;
        $display("a=%d b=%d gcd=%d done=%b", a, b, gcd, done);
    endtask


endmodule