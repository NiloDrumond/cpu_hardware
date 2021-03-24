module concat(
    input wire [31:0] PC_out,
    input wire [4:0] inst25_21,
    input wire [4:0] inst20_16,
    input wire [15:0] inst15_0,
    output reg [31:0] saida
);

reg [27:0] aux20_16;
reg [27:0] aux25_21;

always @ (*) begin
	aux20_16 = (inst20_16 << 16);
	aux25_21 = (inst25_21 << 21);
	saida = (32'b00000000000000000000000000000000 + inst15_0);
	saida = (saida + aux20_16 + aux25_21);
	saida = (saida << 2);
	saida[31] = (PC_out[31]);
	saida[30] = (PC_out[30]);
	saida[29] = (PC_out[29]);
	saida[28] = (PC_out[28]);
end		

endmodule