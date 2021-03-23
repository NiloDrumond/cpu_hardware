module mux_ulaB(
    input wire [1:0]seletor,
    input wire [31:0]B_out,
    input wire [31:0]sign16_to_32,
    input wire [31:0]shiftLeft2,
    output wire [31:0]Data_out
);

always 
	case (seletor)
		2'd0:Data_out = B_out;
		2'd1:Data_out = 32'd4;
		2'd2:Data_out = sign16_to_32;
        2'd3:Data_out = shiftLeft2;
	endcase
	
endmodule
