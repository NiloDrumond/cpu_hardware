module mux_hi(
input wire seletor,
input wire [31:0] mult,
input wire [31:0] div,
output reg [31:0] hi
);

always @ (*) begin
	case (seletor)
		1'd0: begin
			hi = mult;
		end
		1'd1: begin
			hi = div;
		end
	endcase
end

endmodule