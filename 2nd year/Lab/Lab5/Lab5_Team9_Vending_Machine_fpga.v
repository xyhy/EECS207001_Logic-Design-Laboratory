module top (
    inout wire PS2_DATA,
	inout wire PS2_CLK,
    input clk,
    input IN5,
    input IN10,
    input IN50,
    input CANCEL,
    input RESET,
    output  [7:0] digit,
    output  [3:0] an,
    output  [3:0] led
);
    parameter INITIAL = 3'b000;
    parameter COFFEE = 3'b001;
    parameter COKE = 3'b010;
    parameter OOLONG = 3'b011;
    parameter WATER = 3'b100;
    parameter RETURN = 3'b101;

    reg [6:0] count,next_count ;
    reg [26:0] freq_count;
    reg [2:0] state,next_state ;

    wire [511:0] key_down;
	wire [8:0] last_change;
	wire been_ready;

    wire in5,in10,in50;
    wire i5,i10,i50;
    wire cancel,reset;
    wire can,res;
    wire a,s,d,f;
    wire aaa,sss,ddd,fff;
    wire A,S,D,F;



    assign A = key_down[9'b0_0001_1100] ;
    assign S = key_down[9'b0_0001_1011] ;
    assign D = key_down[9'b0_0010_0011] ;
    assign F = key_down[9'b0_0010_1011] ;

    debounce d1(i5,IN5,clk);
    onepulse o1(in5,i5, clk);
    debounce d2(i10,IN10, clk);
    onepulse o2(in10,i10, clk);
    debounce d3(i50,IN50, clk);
    onepulse o3(in50,i50, clk);
    debounce d4(can,CANCEL, clk);
    onepulse o4(cancel,can, clk);
    debounce d5(res,RESET, clk);
    onepulse o5(reset,res, clk);
    debounce d6(aaa,A, clk);
    onepulse o6(a,aaa, clk);
    debounce d7(sss,S, clk);
    onepulse o7(s,sss, clk);
    debounce d8(ddd,D, clk);
    onepulse o8(d,ddd, clk);
    debounce d9(fff,F, clk);
    onepulse o9(f,fff, clk);

    KeyboardDecoder key_de (
		.key_down(key_down),
		.last_change(last_change),
		.key_valid(been_ready),
		.PS2_DATA(PS2_DATA),
		.PS2_CLK(PS2_CLK),
		.rst(reset),
		.clk(clk)
	);


    always @(posedge clk or posedge  reset) begin
        if(reset==1'b1) begin
            state <= INITIAL;
        end
        else begin
            state <= next_state;
        end
    end
    always @(*) begin
        case(state)
            INITIAL: begin
                
                if(a==1'b1 && count>=7'd75 && ~(s==1'b1||d==1'b1||f==1'b1||cancel==1'b1)) begin
                    next_state = COFFEE;
                end
                else if(s==1'b1 && count>=7'd50 && ~(a==1'b1||d==1'b1||f==1'b1||cancel==1'b1)) begin
                    next_state = COKE;
                end
                else if(d==1'b1 && count>=7'd30 && ~(a==1'b1||s==1'b1||f==1'b1||cancel==1'b1)) begin
                    next_state = OOLONG;
                end
                else if(f==1'b1 && count>=7'd25 && ~(a==1'b1||s==1'b1||d==1'b1||cancel==1'b1)) begin
                    next_state = WATER;
                end
                else if(cancel==1'b1 && ~(a==1'b1||s==1'b1||d==1'b1||f==1'b1)) begin
                    next_state = RETURN;
                end
                else begin
                    next_state = INITIAL;
                end
                
            end
            COFFEE: begin
                next_state = RETURN;
            end
            COKE: begin
                next_state = RETURN;
            end
            OOLONG: begin
                next_state = RETURN;
            end
            WATER : begin
                next_state = RETURN;
            end
            RETURN: begin
                if(count==7'd0) begin
                    next_state =INITIAL;
                end
                else begin
                    next_state =RETURN;
                end
            end
            default :begin
                next_state = INITIAL;
            end
        endcase
    end

    always @(posedge clk or posedge reset) begin
        if(reset ==1'b1) begin
            count <= 0;
        end
        else begin
            if(state ==RETURN) begin
                if(freq_count==27'd99999999) begin
                    freq_count <=0;
                    count <= next_count;
                end
                else begin
                    freq_count <= freq_count+1;
                    count <=count;
                end
            end
            else begin
                count <= next_count;
                freq_count <= 0;
            end
        end
    end
    always @(*) begin
        case (state)
            INITIAL: begin
                if(in5==1'b1 && ~(in10==1'b1||in50==1'b1)) begin
                    if(count+7'd5>=7'd100) begin
                        next_count = 7'd100;
                    end
                    else begin
                        next_count = count +7'd5;
                    end
                end
                else if(in10==1'b1 && ~(in5==1'b1||in50==1'b1)) begin
                    if(count+7'd10>=7'd100) begin
                        next_count = 7'd100;
                    end
                    else begin
                        next_count = count +7'd10;
                    end
                end
                else if(in50==1'b1 && ~(in5==1'b1||in10==1'b1)) begin
                    if(count>=7'd50) begin
                        next_count = 7'd100;
                    end
                    else begin
                        next_count = count +7'd50;
                    end
                end
                else begin
                    next_count = count;
                end
                
            end
            COFFEE : begin
                next_count = count -7'd75;
            end
            COKE : begin
                next_count = count -7'd50;
            end
            OOLONG: begin
                next_count = count - 7'd30;
            end
            WATER : begin
                next_count = count -7'd25;
            end
            RETURN : begin
                if (count <= 7'd5) begin
                    next_count = 7'd0;
                end
                else begin
                    next_count = count-7'd5;
                end
            end
            default : begin
                next_count = count;
            end
        endcase
    end

    reg [3:0] num_ten,num_one,num_hun;
    always @(*) begin
        num_hun = count/100;
        num_ten = count/10;
        num_one = count%10;
    end
    display dis(num_ten,num_one,num_hun,clk,an,digit);
    assign led[3] = (count>=75 && state==INITIAL) ? 1'b1 : 1'b0 ;
    assign led[2] = (count>=50 && state==INITIAL) ? 1'b1 : 1'b0 ; 
    assign led[1] = (count>=30 && state==INITIAL) ? 1'b1 : 1'b0 ; 
    assign led[0] = (count>=25 && state==INITIAL) ? 1'b1 : 1'b0 ;  
endmodule

module display (
    input [3:0] num_ten,
    input [3:0] num_one,
    input [3:0] num_hun,
    input clk,
    output reg [3:0] an,
    output reg [7:0] out
);
    wire clk_17;
    divider #(.n(17)) clk17 (clk,clk_17);
    
    reg [1:0] count;
    reg [7:0] hun,ten,one;

    always @(posedge clk_17 ) begin
        count <= count+1;
    end
    always @(*)begin
        case(count)
            2'b00:begin
            out = one;
            an = 4'b1110;
            end
            2'b01:begin
            out = ten;
            an = 4'b1101;
            end
            2'b10:begin
            out = hun;
            an = 4'b1011;
            end
            2'b11:begin
            out = 8'b11111111;
            an = 4'b0111;
            end
    endcase
    end
    always @(*) begin
        if(num_hun==1)begin
            hun = 8'b10011111;
        end
        else begin
            hun = 8'b11111111;
        end
    end

    always @(*) begin
        case (num_ten)
            0 : ten = 8'b11111111;	
            1 : ten = 8'b10011111;                                                   
            2 : ten = 8'b00100101;                                                   
            3 : ten = 8'b00001101;                                                
            4 : ten = 8'b10011001;                                                  
            5 : ten = 8'b01001001;                                                  
            6 : ten = 8'b01000001;   
            7 : ten = 8'b00011111;   
            8 : ten = 8'b00000001;   
            9 : ten = 8'b00001001;
            10 : ten = 8'b00000011;
            default : ten = 8'b11111111;
        endcase
    end
    always @(*) begin
        case (num_one)
            0 : one = 8'b00000011;	
            1 : one = 8'b10011111;                                                   
            2 : one = 8'b00100101;                                                   
            3 : one = 8'b00001101;                                                
            4 : one = 8'b10011001;                                                  
            5 : one = 8'b01001001;                                                  
            6 : one = 8'b01000001;   
            7 : one = 8'b00011111;   
            8 : one = 8'b00000001;   
            9 : one = 8'b00001001;
            default : one = 8'b11111111;
        endcase
    end
endmodule

module debounce(pb_debounced, pb, clk_de);
output pb_debounced;//after 
input pb;//button
input clk_de;
reg [2:0]DFF;

always @(posedge clk_de)   begin
        DFF[2:1]<=DFF[1:0];
        DFF[0]<=pb;
end
assign pb_debounced = ((DFF == 4'b111) ? 1'b1 : 1'b0);
endmodule


module onepulse(pb_one_pulse, pb_debounced, clk_one);
input pb_debounced;
input clk_one;
output reg pb_one_pulse;
reg pb_debounced_delay;
always @(posedge clk_one)begin
        pb_one_pulse <= pb_debounced & (!pb_debounced_delay);
        pb_debounced_delay <= pb_debounced;
end
endmodule
	

module OnePulse (
	output reg signal_single_pulse,
	input wire signal,
	input wire clock
);
	
	reg signal_delay;

	always @(posedge clock) begin
		if (signal == 1'b1 & signal_delay == 1'b0)
		  signal_single_pulse <= 1'b1;
		else
		  signal_single_pulse <= 1'b0;

		signal_delay <= signal;
	end
endmodule

module KeyboardDecoder(
	output reg [511:0] key_down,
	output wire [8:0] last_change,
	output reg key_valid,
	inout wire PS2_DATA,
	inout wire PS2_CLK,
	input wire rst,
	input wire clk
);
    
    parameter [1:0] INIT			= 2'b00;
    parameter [1:0] WAIT_FOR_SIGNAL = 2'b01;
    parameter [1:0] GET_SIGNAL_DOWN = 2'b10;
    parameter [1:0] WAIT_RELEASE    = 2'b11;
    
	parameter [7:0] IS_INIT			= 8'hAA;
    parameter [7:0] IS_EXTEND		= 8'hE0;
    parameter [7:0] IS_BREAK		= 8'hF0;
    
    reg [9:0] key;		// key = {been_extend, been_break, key_in}
    reg [1:0] state;
    reg been_ready, been_extend, been_break;
    
    wire [7:0] key_in;
    wire is_extend;
    wire is_break;
    wire valid;
    wire err;
    
    wire [511:0] key_decode = 1 << last_change;
    assign last_change = {key[9], key[7:0]};
    
    KeyboardCtrl_0 inst (
		.key_in(key_in),
		.is_extend(is_extend),
		.is_break(is_break),
		.valid(valid),
		.err(err),
		.PS2_DATA(PS2_DATA),
		.PS2_CLK(PS2_CLK),
		.rst(rst),
		.clk(clk)
	);
	
	OnePulse op (
		.signal_single_pulse(pulse_been_ready),
		.signal(been_ready),
		.clock(clk)
	);
    
    always @ (posedge clk, posedge rst) begin
    	if (rst) begin
    		state <= INIT;
    		been_ready  <= 1'b0;
    		been_extend <= 1'b0;
    		been_break  <= 1'b0;
    		key <= 10'b0_0_0000_0000;
    	end else begin
    		state <= state;
			been_ready  <= been_ready;
			been_extend <= (is_extend) ? 1'b1 : been_extend;
			been_break  <= (is_break ) ? 1'b1 : been_break;
			key <= key;
    		case (state)
    			INIT : begin
    					if (key_in == IS_INIT) begin
    						state <= WAIT_FOR_SIGNAL;
    						been_ready  <= 1'b0;
							been_extend <= 1'b0;
							been_break  <= 1'b0;
							key <= 10'b0_0_0000_0000;
    					end else begin
    						state <= INIT;
    					end
    				end
    			WAIT_FOR_SIGNAL : begin
    					if (valid == 0) begin
    						state <= WAIT_FOR_SIGNAL;
    						been_ready <= 1'b0;
    					end else begin
    						state <= GET_SIGNAL_DOWN;
    					end
    				end
    			GET_SIGNAL_DOWN : begin
						state <= WAIT_RELEASE;
						key <= {been_extend, been_break, key_in};
						been_ready  <= 1'b1;
    				end
    			WAIT_RELEASE : begin
    					if (valid == 1) begin
    						state <= WAIT_RELEASE;
    					end else begin
    						state <= WAIT_FOR_SIGNAL;
    						been_extend <= 1'b0;
    						been_break  <= 1'b0;
    					end
    				end
    			default : begin
    					state <= INIT;
						been_ready  <= 1'b0;
						been_extend <= 1'b0;
						been_break  <= 1'b0;
						key <= 10'b0_0_0000_0000;
    				end
    		endcase
    	end
    end
    
    always @ (posedge clk, posedge rst) begin
    	if (rst) begin
    		key_valid <= 1'b0;
    		key_down <= 511'b0;
    	end else if (key_decode[last_change] && pulse_been_ready) begin
    		key_valid <= 1'b1;
    		if (key[8] == 0) begin
    			key_down <= key_down | key_decode;
    		end else begin
    			key_down <= key_down & (~key_decode);
    		end
    	end else begin
    		key_valid <= 1'b0;
			key_down <= key_down;
    	end
    end

endmodule



module divider #(parameter n = 25) (clk, clk_div);
    // parameter n = 25;
    input clk;
    output clk_div;
    reg [n-1:0]num = 0;
    wire [n-1:0]next_num;
    
    always @(posedge clk) begin
        num <= next_num;
    end
    assign next_num = num + 1;
    assign clk_div = num[n-1];
endmodule