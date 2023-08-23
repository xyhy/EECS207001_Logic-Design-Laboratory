`timescale 1ns/1ps

module Decode_and_Execute_t ;

reg CLK = 1;

reg [3-1:0] Op_code;
reg [4-1:0] Rs,Rt;
wire [4-1:0] Rd;
reg pass=1;


Decode_and_Execute D0 (
  .op_code (Op_code),
  .rs (Rs),
  .rt (Rt),
  .rd (Rd)
);


always #1 CLK = ~CLK;

initial begin
    Rt = 4'b1;
    Rs = 4'b1;
    Op_code = 3'b0;
    repeat (2**3) begin
        repeat (2**3) begin
            @ (posedge CLK)
                Test;
            @ (negedge CLK)
                Op_code = Op_code + 1'b1;
        end
        Rs = Rs + 1'b1;
    end
    Op_code = 3'b0;
    Rt = 4'b0010;
    Rs = 4'b0010;
    repeat (2**2+1) begin
        repeat (2**3) begin
            @ (posedge CLK)
                Test;
            @ (negedge CLK)
                Op_code = Op_code + 1'b1;
        end
        Rs = Rs + 1'b1;
    end
    Rt = 4'b0011;
    Rs = 4'b0011;
    Op_code = 3'b0;
    repeat (2) begin
        repeat (2**3) begin
            @ (posedge CLK)
                Test;
            @ (negedge CLK)
                Op_code = Op_code + 1'b1;
        end
        Rs = Rs + 1'b1;
    end
    $finish;
end

task Test;
begin

    if(Op_code === 000) begin
        if(Rd !== (Rs + Rt)) begin 
            Wrong;
        end
        else begin
            pass=1;
        end
    end
    if(Op_code === 001) begin
        if(Rd !== (Rs - Rt)) begin
            Wrong;
        end
    end
    if(Op_code === 010) begin
        if(Rd !== (Rs + 1'b1)) begin 
            Wrong;
        end
    end
    if(Op_code === 011) begin
        if(Rd !== (~(Rs|Rt)) ) begin 
            Wrong;
        end
    end
    if(Op_code === 100) begin
        if(Rd !== (~(Rs&Rt)) ) begin 
            Wrong;
        end
    end
    if(Op_code === 101) begin
        if(Rd !== (Rs >> 2)) begin 
            Wrong;
        end
    end
    if(Op_code === 110) begin
        if(Rd !== (Rs << 1)) begin 
            Wrong;
        end
    end
    if(Op_code === 111) begin
        if(Rd !== (Rs * Rt)) begin 
            Wrong;
        end
    end

end
endtask


task Wrong;
begin
pass=0;
$display("[ERROR]");
$write("Op_code:%3b",Op_code);
$write("Rs:%4b",Rs);
$write("Rt:%4b",Rt);
$write("Rd:%4b",Rd);
$display;

end
endtask


endmodule