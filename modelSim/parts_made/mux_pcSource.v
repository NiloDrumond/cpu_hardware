module pcSource(
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
        3'd0: begin
            pcSourceOut = LSControlOut;
        end
		3'd1: begin
			pcSourceOut = aluResult;
		end
		3'd2: begin
			pcSourceOut = aluOutOut;
		end
		3'd3: begin
			pcSourceOut = shiftLeft2Out;
		end
		3'd4: begin
			pcSourceOut = epcOut;
		end
	endcase
	
endmodule
