module mux_lo(
    input wire seletor,
    input wire [31:0] mult,
    input wire [31:0] div,
    output reg [31:0] lo
);

always @ (*) begin
	case (seletor)
		1'd0:lo = mult;
		1'd1:lo = div;
	endcase
end
	
endmodule