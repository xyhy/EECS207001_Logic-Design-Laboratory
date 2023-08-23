//one-hot encoding
`define STOP 10'd0
`define FAST 10'd3
`define MID 10'd2
`define SLOW 10'd1

module Top(clk, rst, startUP, startDOWN, vgaRed, vgaBlue, vgaGreen, hsync, vsync);
	input clk, rst, startUP, startDOWN;//button
    output [3:0] vgaRed, vgaGreen, vgaBlue;
    output hsync, vsync;
	
	wire clk_d2;//25MHz
    wire clk_d19; // 100/2^19 MHz
    wire [16:0] pixel_addr;
    wire [11:0] pixel;
	wire [11:0] data;
    wire valid;
	//640*480
    wire [9:0] h_cnt, v_cnt; // h=640, v=480
	wire [9:0] h_cnt_re, v_cnt_re;
	wire [9:0] A_v_count, B_v_count, C_v_count;
	wire run;
	//signals
	wire startUP_db, rst_db, startDOWN_db;
	wire startUP_op, rst_op, startDOWN_op;
	
	assign h_cnt_re = h_cnt>>1;
	assign v_cnt_re = v_cnt>>1;
	
	assign {vgaRed, vgaGreen, vgaBlue} = (valid==1'b1) ? pixel : 12'h0;
	
	//clock
	clk_div #(2) CD0(.clk(clk), .clk_d(clk_d2));
	clk_div #(19) CD1(.clk(clk), .clk_d(clk_d19));
	
	//signals
	debounce DB0(.s(startUP), .s_db(startUP_db), .clk(clk));
	debounce DB1(.s(rst), .s_db(rst_db), .clk(clk));
	debounce DB2(.s(startDOWN), .s_db(startDOWN_db), .clk(clk));

	onepulse OP0(.s(startUP_db), .s_op(startUP_op), .clk(clk_d19));
	onepulse OP1(.s(rst_db), .s_op(rst_op), .clk(clk_d19));
	onepulse OP2(.s(startDOWN_db), .s_op(startDOWN_op), .clk(clk_d19));
	
	//control
	state_control SC0(
		.clk(clk_d19),
		.rst(rst_op),
		.startUP(startUP_op),
		.startDOWN(startDOWN_op),
		.A_v_count(A_v_count),
		.B_v_count(B_v_count),
		.C_v_count(C_v_count)
	);
	mem_addr_gen MAG(
		.h_cnt(h_cnt_re),
		.v_cnt(v_cnt_re), 
		.A_v_count(A_v_count),
		.B_v_count(B_v_count),
		.C_v_count(C_v_count),
		.pixel_addr(pixel_addr)
	);
     
	//display
    blk_mem_gen_0 BMG0(
		.clka(clk_d2),
        .wea(0),
        .addra(pixel_addr),
        .dina(data[11:0]),
        .douta(pixel)
    ); 

    vga_controller VC0(
        .pclk(clk_d2),
        .reset(rst_op),
        .hsync(hsync),
        .vsync(vsync),
        .valid(valid),
        .h_cnt(h_cnt),
        .v_cnt(v_cnt)
    );
	
endmodule

module onepulse(s, s_op, clk);
	input s, clk;
	output reg s_op;
	reg s_delay;
	always@(posedge clk)begin
		s_op <= s&(!s_delay);
		s_delay <= s;
	end
endmodule

module debounce(s, s_db, clk);
	input s, clk;
	output s_db;
	reg [3:0] DFF;
	
	always@(posedge clk)begin
		DFF[3:1] <= DFF[2:0];
		DFF[0] <= s;
	end
	assign s_db = (DFF == 4'b1111)? 1'b1 : 1'b0;
endmodule

module clk_div #(parameter n = 2)(clk, clk_d);
	input clk;
	output clk_d;
	reg [n-1:0]count;
	wire[n-1:0]next_count;
	
	always@(posedge clk)begin
		count <= next_count;
	end
	
	assign next_count = count + 1;
	assign clk_d = count[n-1];
endmodule

module state_control(clk, rst, startUP, startDOWN, A_v_count, B_v_count, C_v_count);
	input clk, rst, startUP, startDOWN;
	
	reg [9:0]A_state, B_state, C_state; 
	wire [9:0]next_A_state, next_B_state, next_C_state;
	
	reg [9:0]counter;
	wire [9:0]next_counter;
	
	output reg [9:0]A_v_count, B_v_count, C_v_count;
	reg [9:0]next_A_v_count, next_B_v_count, next_C_v_count;
	
	reg [9:0]A_to, B_to, C_to;

	reg flag_up;
	
	always@(posedge clk)begin
		if(rst)begin
			A_state <= `STOP;
			B_state <= `STOP;
			C_state <= `STOP;
			counter <= 10'd0;
			A_v_count <= 10'd0;
			B_v_count <= 10'd0;
			C_v_count <= 10'd0;
			flag_up <= 1'b0;
		end
		else begin
			A_state <= next_A_state;
			B_state <= next_B_state;
			C_state <= next_C_state;
			counter <= next_counter;
			A_v_count <= next_A_v_count;
			B_v_count <= next_B_v_count;
			C_v_count <= next_C_v_count;
			if(startUP==1'b1 && startDOWN==1'b0 && counter==10'd0) begin
				flag_up <= 1'b1;
			end
			else if(startUP==1'b0 && startDOWN==1'b1 && counter==10'd0)begin
				flag_up <= 1'b0;
			end
			else begin 
				flag_up <= flag_up;
			end
		end
	end
	
	always@(*)begin
		case(C_state)
			`STOP:begin
				if(startUP==1'b1 && startDOWN==1'b0 && counter==10'd0) begin
					C_to = `SLOW;
				end
				else if(startUP==1'b0 && startDOWN==1'b1 && counter==10'd0) begin
					C_to = `SLOW;
				end
				else begin
					C_to = `STOP;
				end
				//C_to = (start==1'b1 && counter==10'd0)? `SLOW : `STOP;
			end
			`SLOW:begin
				C_to = (counter>=10'd959)? `STOP : (counter>=10'd239 && counter<10'd359)? `MID : `SLOW;
			end
			`MID:begin
				C_to = (counter>=10'd719)? `SLOW : (counter>=10'd359 && counter<10'd599)? `FAST : `MID;
			end
			`FAST:begin
				C_to = (counter>=10'd599)? `MID : `FAST;
			end
		endcase
	end
	always@(*)begin
		case(B_state)
			`STOP:begin
				if(startUP==1'b1 && startDOWN==1'b0 && counter==10'd0) begin
					B_to = `SLOW;
				end
				else if(startUP==1'b0 && startDOWN==1'b1 && counter==10'd0) begin
					B_to = `SLOW;
				end
				else begin
					B_to = `STOP;
				end
				//B_to = (start==1'b1 && counter==10'd0)? `SLOW : `STOP;
			end
			`SLOW:begin
				B_to = (counter>=10'd799)? `STOP : (counter>=10'd239 && counter<10'd359)? `MID : `SLOW;
			end
			`MID:begin
				B_to = (counter>=10'd559)? `SLOW : (counter>=10'd359 && counter<10'd439)? `FAST : `MID;
			end
			`FAST:begin
				B_to = (counter>=10'd439)? `MID : `FAST;
			end
		endcase
	end
	always@(*)begin
		case(A_state)
			`STOP:begin
				if(startUP==1'b1 && startDOWN==1'b0 && counter==10'd0) begin
					A_to = `SLOW;
				end
				else if(startUP==1'b0 && startDOWN==1'b1 && counter==10'd0) begin
					A_to = `SLOW;
				end
				else begin
					A_to = `STOP;
				end
				//A_to = (start==1'b1 && counter==10'd0)? `SLOW : `STOP;
			end
			`SLOW:begin
				A_to = (counter>=10'd599)? `STOP : (counter>=10'd239 && counter<10'd359)? `MID : `SLOW;
			end
			`MID:begin
				A_to = (counter>=10'd359)? `SLOW : `MID;
			end
			`FAST:begin
				A_to = `STOP;
			end
		endcase
	end
	
	assign next_counter = ((startUP==1'b0 && startDOWN==1'b0 && counter==10'd0) || (counter >= 10'd1000))? 10'd0 : counter+1'b1;
	assign next_C_state = C_to;
	assign next_B_state = B_to;
	assign next_A_state = A_to;
	
	always@(*) begin
		if(counter >= 10'd1000)begin
			next_A_v_count <= 10'd0;
			next_B_v_count <= 10'd0;
			next_C_v_count <= 10'd0;
		end
		else begin
			if(flag_up == 1'b1) begin
				if(A_v_count < A_state) begin
					next_A_v_count = A_v_count - A_state + 10'd240;
				end
				else begin
					next_A_v_count = A_v_count - A_state;
				end

				if(B_v_count < B_state) begin
					next_B_v_count = B_v_count - B_state + 10'd240;
				end
				else begin
					next_B_v_count = B_v_count - B_state;
				end

				if(C_v_count < C_state) begin
					next_C_v_count = C_v_count - C_state + 10'd240;
				end
				else begin
					next_C_v_count = C_v_count - C_state;
				end
			end
			else begin 
				if(A_v_count + A_state >= 10'd240) begin
					next_A_v_count = A_v_count + A_state - 10'd240;
				end
				else begin
					next_A_v_count = A_v_count + A_state;
				end

				if(B_v_count + B_state >= 10'd240) begin
					next_B_v_count = B_v_count + B_state - 10'd240;
				end
				else begin
					next_B_v_count = B_v_count + B_state;
				end

				if(C_v_count + C_state >= 10'd240) begin
					next_C_v_count = C_v_count + C_state - 10'd240;
				end
				else begin
					next_C_v_count = C_v_count + C_state;
				end
			
			end
		end
	end
	
		
endmodule

module mem_addr_gen(h_cnt, v_cnt, A_v_count, B_v_count, C_v_count, pixel_addr);
    input [9:0] h_cnt, v_cnt;
    input [9:0] A_v_count, B_v_count, C_v_count;
    output[16:0] pixel_addr;
    
    wire [16:0] v_cnt_new, v_cnt_total;
	wire [16:0] v_mem;
	
	assign v_mem = (h_cnt < 10'd110)? A_v_count :(h_cnt > 10'd210)? C_v_count : B_v_count;
	assign v_cnt_total = v_cnt + (16'd239 - v_mem);
	assign v_cnt_new = (v_cnt_total >= 16'd239)? v_cnt_total - 16'd239 : v_cnt_total;
	
	assign pixel_addr = v_cnt_new*320 + h_cnt;
endmodule

module vga_controller(pclk, reset, hsync, vsync, valid, h_cnt, v_cnt);
    input pclk, reset;
    output hsync, vsync;
	output valid;
    output [9:0]h_cnt, v_cnt;
    
    reg [9:0]pixel_cnt;
    reg [9:0]line_cnt;
    reg hsync_i,vsync_i;
	wire hsync_default, vsync_default;
    wire [9:0] HD, HF, HS, HB, HT, VD, VF, VS, VB, VT;
	
    assign HD = 640;
    assign HF = 16;
    assign HS = 96;
    assign HB = 48;
    assign HT = 800; 
    assign VD = 480;
    assign VF = 10;
    assign VS = 2;
    assign VB = 33;
    assign VT = 525;
    assign hsync_default = 1'b1;
    assign vsync_default = 1'b1;
     
    always@(posedge pclk)
        if(reset)
            pixel_cnt <= 0;
        else if(pixel_cnt < (HT - 1))
            pixel_cnt <= pixel_cnt + 1;
        else
            pixel_cnt <= 0;

    always@(posedge pclk)
        if(reset)
            hsync_i <= hsync_default;
        else if((pixel_cnt >= (HD + HF - 1))&&(pixel_cnt < (HD + HF + HS - 1)))
            hsync_i <= ~hsync_default;
        else
            hsync_i <= hsync_default; 
    
    always@(posedge pclk)
        if(reset)
            line_cnt <= 0;
        else if( pixel_cnt == (HT-1) )
            if( line_cnt < (VT-1) )
                line_cnt <= line_cnt + 1;
            else
                line_cnt <= 0;
                  
				  
    always@(posedge pclk)
        if(reset)
            vsync_i <= vsync_default; 
        else if((line_cnt >= (VD + VF - 1))&&(line_cnt < (VD + VF + VS - 1)))
            vsync_i <= ~vsync_default;
        else
            vsync_i <= vsync_default; 

    assign hsync = hsync_i;
    assign vsync = vsync_i;
    assign valid = ((pixel_cnt < HD) && (line_cnt < VD));
	
    assign h_cnt = (pixel_cnt < HD)? pixel_cnt : 10'd0;//639
    assign v_cnt = (line_cnt < VD)? line_cnt : 10'd0;//479
	
endmodule