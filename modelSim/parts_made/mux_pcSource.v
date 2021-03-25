module mux_pcSource(
input wire [2:0] muxpcsource,
input wire [31:0] LSControlOut,
input wire [31:0] aluResult,
input wire [31:0] aluOutOut,
input wire [31:0] shiftLeft2Out,
input wire [31:0] epcOut,
output reg [31:0] pcSourceOut // saida do mux do pcSource
);


always @ (*) begin
	case (muxpcsource)
    3'd0:pcSourceOut = LSControlOut;
		3'd1:pcSourceOut = aluResult;
		3'd2:pcSourceOut = aluOutOut;
		3'd3:pcSourceOut = shiftLeft2Out;
		3'd4:pcSourceOut = epcOut;
	endcase
end	
endmodule
