module mux_aluSrcA(
    input wire [1:0]seletor,
    input wire [31:0]PC_out,
    input wire [31:0]A_out,
    input wire [31:0]MDR_out,
    output reg [31:0]Data_out
);

always@(*)begin
    case (seletor)
		2'd0:Data_out = PC_out;
		2'd1:Data_out = A_out;
		2'd2:Data_out = MDR_out;
	endcase
end
	
endmodule