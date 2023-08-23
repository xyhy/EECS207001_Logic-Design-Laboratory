`timescale 1ns/1ps
module tracker_sensor(clk, reset, left_signal, right_signal, mid_signal, state);
    input clk;
    input reset;
    input left_signal, right_signal, mid_signal;
    output reg [1:0] state;
    reg [1:0] next_state;

    // [TO-DO] Receive three signals and make your own policy.
    // Hint: You can use output state to change your action.

    parameter LEFT = 2'b00;
    parameter MID = 2'b01;
    parameter RIGHT = 2'b10;
    // parameter OTHER = 2'b11;

    always@(posedge clk) begin
        if(reset) begin
            state <= MID;
        end
        else begin
            state <= next_state;
        end
    end

    always@(*) begin //1 for white, 0 for black
        case({left_signal, mid_signal, right_signal})
            3'b000: next_state = state;
            3'b001: next_state = RIGHT;
            3'b010: next_state = MID;
            3'b011: next_state = RIGHT;
            3'b100: next_state = LEFT;
            3'b101: next_state = state;
            3'b110: next_state = LEFT;
            3'b111: next_state = MID;
            default: next_state = state;
        endcase
    end

endmodule
