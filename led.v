// led.v
// 簡単なPWM回路

`timescale 1 ps / 1 ps
module new_component (
		input  wire [7:0]  	s0_address,    // s0.address
		input  wire        	s0_read,       //   .read
		output reg  [31:0] 	s0_readdata,   //   .readdata
		input  wire        	s0_write,      //   .write
		input  wire [31:0] 	s0_writedata,  //   .writedata
		input  wire        	clk,          	// clk
		input  wire        	reset,			// reset
		output wire	[7:0]		led				// output
	);

	reg [31:0] count;
	reg [31:0] duty;
	reg [31:0] period;

	// レジスタ読み込み 
	always @(posedge clk)
	begin
		case(s0_address)
			8'h00   : s0_readdata <= period;
			8'h01   : s0_readdata <= duty;
			8'h02   : s0_readdata <= count;
			default : s0_readdata <= 0;
		endcase
	end
	
	// レジスタ書き込み
	always @(posedge clk)
	begin
		if(reset)
		begin
			duty  <= 0;
			period <= 0;
		end
		else if(s0_write)
		begin
			case(s0_address)
				8'h00   : period <= s0_writedata;
				8'h01   : duty   <= s0_writedata;
			endcase
		end
	end
	
	// PWMカウンタ
	always @(posedge clk)
	begin
		if(reset)
			count <= 0;
		else if(count>=period)
			count <= 0;
		else
			count <= count+1;
	end
	
	// とりあえずLED全点灯してみる
	assign led = (count<=duty) ? 8'hff : 8'h00;

endmodule
