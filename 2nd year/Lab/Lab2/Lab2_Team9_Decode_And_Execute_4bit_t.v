`timescale 1ns/1ps

module Decode_tb;
reg [4-1:0] rs=4'b0000, rt=4'b0000;
reg [3-1:0] sel = 3'b000;
wire [4-1:0] rd;
reg CLK = 1;
reg pass = 1;

Decode_And_Execute de_and_ex(.rs(rs), .rt(rt), .sel(sel), .rd(rd));

always #1 CLK = ~CLK;

initial begin
    $fsdbDumpfile("decode_nwave.fsdb");
    $fsdbDumpvars;
    
    repeat(2**11) begin
        @(posedge CLK)
            simulate;
        @(negedge CLK)
            {sel, rs, rt} = {sel, rs, rt}+1'b1;
    end

    #2 $finish;

end

task simulate;
    case(sel)
        3'b000:
            if(rs+rt !== rd) begin
                pass = 0;
                $display("ERROR rs=%b, rt=%b, rd=%b, sel=%b", rs, rt, rd, sel);
            end
            else begin
                pass = 1;
                $display("Correct");
            end
        3'b001:
            if(rs-rt !== rd) begin
                pass = 0;
                $display("ERROR rs=%b, rt=%b, rd=%b, sel=%b", rs, rt, rd, sel);
            end
            else begin
                pass = 1;
                $display("Correct");
            end
        3'b010:
            if((rs&rt) !== rd) begin
                pass = 0;
                $display("ERROR rs=%b, rt=%b, rd=%b, ans=%b sel=%b", rs, rt, rd, rs&rt, sel);
            end
            else begin
                pass = 1;
                $display("Correct");
            end
        3'b011:
            if((rs|rt) !== rd) begin
                pass = 0;
                $display("ERROR rs=%b, rt=%b, rd=%b, ans=%b sel=%b", rs, rt, rd, rs|rt, sel);
            end
            else begin
                pass = 1;
                $display("Correct");
            end
        3'b100:
            if(rd !== {rs[2:0],rs[3]} ) begin
                pass = 0;
                $display("ERROR rs=%b, rt=%b, rd=%b, ans=%b, sel=%b", rs, rt, rd, (rs<<<1), sel);
            end
            else begin
                pass = 1;
                $display("Correct");
            end
        3'b101:
            if(rd !== ({rt[3], rt[3:1]})) begin
                pass = 0;
                $display("ERROR rs=%b, rt=%b, rd=%b, sel=%b", rs, rt, rd, sel);
            end
            else begin
                pass = 1;
                $display("Correct");
            end
        3'b110:
            if(rs === rt) begin
                pass = (rd===4'b1111)?1:0;
                $display("rs=%b, rt=%b, rd=%b, sel=%b", rs, rt, rd, sel);
            end
            else begin
                pass = (rd===4'b1110)?1:0;
                $display("rs=%b, rt=%b, rd=%b, sel=%b", rs, rt, rd, sel);
            end
        3'b111:
            if(rs > rt) begin
                pass = (rd===4'b1011)?1:0;
                $display("rs=%b, rt=%b, rd=%b, sel=%b", rs, rt, rd, sel);
            end
            else begin
                pass = (rd===4'b1010)?1:0;
                $display("rs=%b, rt=%b, rd=%b, sel=%b", rs, rt, rd, sel);
            end
        default: pass = 0; 
    endcase
endtask
endmodule