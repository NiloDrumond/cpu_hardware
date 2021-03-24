module muxHi(
input wire  hiControl,
input wire [31:0] mult,
input wire [31:0] div,
output reg [31:0] hi
);

always @ (*) begin
	case (hiControl)
		1'd0: begin
			hi = mult;
		end
		1'd1: begin
			hi = div;
		end
	endcase
end

endmodule