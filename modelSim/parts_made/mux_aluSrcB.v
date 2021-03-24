module mux_aluSrcB(
    input wire [1:0]seletor,
    input wire [31:0]B_out,
    input wire [31:0]sign16_to_32,
    input wire [31:0]shiftLeft2,
    output reg [31:0]Data_out
);

always@(*)begin
   case (seletor)
		2'd0:Data_out = B_out;
		2'd1:Data_out = 32'd4;
		2'd2:Data_out = sign16_to_32;
        2'd3:Data_out = shiftLeft2;
	endcase 
end
	
endmodule
