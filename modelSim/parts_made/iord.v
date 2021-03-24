module iord(
input wire [2:0]iordmux,
input wire [31:0] pcOut,
input wire [31:0] aluResult,
input wire [31:0] aluOutOut,
output reg [31:0] iordOut
);

parameter  D = 32'd253;
parameter  E = 32'd254;
parameter  F = 32'd255;


always @ (*) begin
	case(iordmux)
		3'b000: iordOut = pcOut;
		3'b001: iordOut = aluResult;
		3'b010: iordOut = aluOutOut;
		3'b011: iordOut = D;
		3'b100: iordOut = E;
		3'b101: iordOut = F;
	endcase
	
endmodule