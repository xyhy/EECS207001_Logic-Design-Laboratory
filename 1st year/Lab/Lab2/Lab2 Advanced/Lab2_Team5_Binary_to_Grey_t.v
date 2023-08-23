`timescale 1ns/1ps

module Binary_to_Grey_t;

reg CLK = 1;

reg [4-1:0] Din;
wire [4-1:0] Dout;
reg pass=1;

Binary_to_Grey testing_instance( .din(Din), .dout(Dout) );

always #5 CLK = ~CLK;

initial begin
    Din = 4'b0;
    repeat (2**4) begin
        @(posedge CLK)
            Test;
        @(negedge CLK)
            Din = Din + 1'b1;
    end
    $finish;
end


task Test;
begin

	if(Din === 4'b0000) begin
        if(Dout !== 4'b0000) begin
            Wrong;
        end
	end
    else if(Din === 4'b0001) begin
        if(Dout !== 4'b0001) begin
            Wrong;
        end
    end
    else if(Din === 4'b0010) begin
        if(Dout !== 4'b0011) begin
            Wrong;
        end
    end
    else if(Din === 4'b0011) begin
        if(Dout !== 4'b0010) begin
            Wrong;
        end
    end
    else if(Din === 4'b0100) begin
        if(Dout !== 4'b0110) begin
            Wrong;
        end
    end
    else if(Din === 4'b0101) begin
        if(Dout !== 4'b0111) begin
            Wrong;
        end
    end
    else if(Din === 4'b0110) begin
        if(Dout !== 4'b0101) begin
            Wrong;
        end
    end
    else if(Din === 4'b0111) begin
        if(Dout !== 4'b0100) begin
            Wrong;
        end
    end
    else if(Din === 4'b1000) begin
        if(Dout !== 4'b1100) begin
            Wrong;
        end
    end
    else if(Din === 4'b1001) begin
        if(Dout !== 4'b1101) begin
            Wrong;
        end
    end
    else if(Din === 4'b1010) begin
        if(Dout !== 4'b1111) begin
            Wrong;
        end
    end
    else if(Din === 4'b1011) begin
        if(Dout !== 4'b1110) begin
            Wrong;
        end
    end
    else if(Din === 4'b1100) begin
        if(Dout !== 4'b1010) begin
            Wrong;
        end
    end
    else if(Din === 4'b1101) begin
        if(Dout !== 4'b1011) begin
            Wrong;
        end
    end
    else if(Din === 4'b1110) begin
        if(Dout !== 4'b1001) begin
            Wrong;
        end
    end
    else if(Din === 4'b1111) begin
        if(Dout !== 4'b1000) begin
            Wrong;
        end
    end
    
    
end
endtask


task Wrong;
begin
    pass =0;
    $display("[ERROR]");
    $write("Binary:%4b",Din);
    $write("Grey:%4b",Dout);
    $display;
end
endtask

endmodule