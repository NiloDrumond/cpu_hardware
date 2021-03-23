module mux_ulaB(
    input wire [3:0]seletor,
    input wire [31:0]ALU_out, //0
    input wire [31:0]LoadSize_out,//1
    input wire [31:0]HI_out,//2
    input wire [31:0]LO_out,//3
    input wire [31:0]sign1_to_32,//4
    input wire [31:0]sign16_to_32,//5
    input wire [31:0]shiftLeft16,//6
    input wire [31:0]shiftRegOut,//7
    input wire [31:0]A_out,//9
    input wire [31:0]B_out,//10
    output wire [31:0]Data_out
);

always 
	case (seletor)
		4'd0:Data_out = ALU_out;
		4'd1:Data_out = LoadSize_out;
		4'd2:Data_out = HI_out;
        4'd3:Data_out = LO_out;
        4'd4:Data_out = sign1_to_32;
		4'd5:Data_out = sign16_to_32;
		4'd6:Data_out = shiftLeft16;
        4'd7:Data_out = shiftRegOut;
        4'd8:Data_out = 32'd227;
		4'd9:Data_out = A_out;
		4'd10:Data_out = B_out;
        
	endcase
	
endmodule
