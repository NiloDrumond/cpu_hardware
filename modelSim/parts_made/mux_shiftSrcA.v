module mux_shiftSrcA(
    input wire seletor,
    input wire [31:0] A_out,
    input wire [31:0] B_out,
    output reg [31:0] Data_out
);

always@(*)begin
    case (seletor)
		2'd0:Data_out = A_out;
		2'd1:Data_out = B_out;
	endcase
end
endmodule