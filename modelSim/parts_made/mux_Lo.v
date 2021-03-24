module muxLo(
input wire loControl,
input wire [31:0] mult,
input wire [31:0] div,
output reg [31:0] lo
);

always @ (*) begin
	case (loControl)
		1'd0: begin
			lo = mult;
		end
		1'd1: begin
			lo = div;
		end
	endcase
end
	
endmodule