module loadOnlyByte(
	input logic [31:0] adress,
	output logic [31:0] result
);

always
	result = {24'b0, adress[7:0]};
	
endmodule: loadOnlyByte