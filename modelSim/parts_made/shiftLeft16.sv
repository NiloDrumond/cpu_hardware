module shiftLeft16(
input logic [31:0] immediate,
output logic [31:0] shiftLeft16Out
);

always @ (*) shiftLeft16Out = immediate << 16;
	
endmodule