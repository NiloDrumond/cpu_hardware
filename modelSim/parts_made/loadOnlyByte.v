module loadOnlyByte(
	input wire [31:0] adress,
	output reg [31:0] result
);

always @ (*) begin
	result = {24'b0, adress[7:0]};
end
	
endmodule