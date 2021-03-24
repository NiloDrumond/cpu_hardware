module shiftLeft2_2(
input logic [31:0] signExt,
output logic [31:0] shiftLeft2Out2
);

always @ (*) shiftLeft2Out2 = signExt << 2;
	
endmodule