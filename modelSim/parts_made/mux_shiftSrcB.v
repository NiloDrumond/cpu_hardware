module mux_shiftSrcB(
    input wire seletor,
    input wire [31:0] B_out4_0, 
    input wire [15:0] inst10_6, // vem do immediate
    output reg [4:0] Data_out
);

always@(*)begin
    case (seletor)
		2'd0:Data_out = B_out4_0[4:0];
		2'd1:Data_out = inst10_6[10:6];
	endcase
end
endmodule