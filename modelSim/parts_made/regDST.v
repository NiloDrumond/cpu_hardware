module regDST(
input wire [2:0] regDSTmux,
input wire [4:0] inst20_16,
input wire [4:0] inst15_11,
input wire [4:0] inst25_21,
output reg [4:0] regDSTOut
);

parameter  D = 5'd29;
parameter  E = 5'd31;

always @ (*) begin
	case(regDSTmux)
		3'b000: regDSTOut = inst20_16;
		3'b001: regDSTOut = inst15_11;
		3'b010: regDSTOut = D;
		3'b011: regDSTOut = E;
		3'b100: regDSTOut = inst25_21;
	endcase
end

endmodule