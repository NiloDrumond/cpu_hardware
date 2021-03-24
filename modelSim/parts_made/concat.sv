module concat(
	input logic [31:0] pcin,
	input logic [4:0] inst25_21,
	input logic [4:0] inst20_16,
	input logic [15:0] inst15_0,
	output logic [31:0] saida
);

logic [27:0] aux20_16;
logic [27:0] aux25_21;

always @ (*) 
	begin
		aux20_16 = (inst20_16 << 16);
		aux25_21 = (inst25_21 << 21);
		saida = (32'b00000000000000000000000000000000 + inst15_0);
		saida = (saida + aux20_16 + aux25_21);
		saida = (saida << 2);
		saida[31] = (pcin[31]);
		saida[30] = (pcin[30]);
		saida[29] = (pcin[29]);
		saida[28] = (pcin[28]);
	end		

endmodule: concat