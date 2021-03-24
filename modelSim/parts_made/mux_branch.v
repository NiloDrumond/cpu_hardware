module mux_branch(
input wire [5:0] Opcode,
input wire Igual,
input wire Maior,
input wire Menor,
output reg signal
);

always @ (*) begin
	case (Opcode)
		6'd4: begin
			signal = Igual;
		end
		6'd5: begin
			if (Igual) begin
				signal = 0;
			end
			else begin
				signal = 1;
			end
		end
		6'd06: begin
			if (Maior) begin
				signal = 0;
			end
			else begin
				signal = 1;
			end
		end
		6'd07: begin
			signal = Maior;
		end
		6'd1: begin
			signal = Menor;
		end
		default: begin
			signal = 0;
		end
	endcase
	
endmodule