module mux_hi(
    input wire seletor,
    input wire [31:0] mult,
    input wire [31:0] div,
    output reg [31:0] hi
);

always @ (*) begin
	case (seletor)
		1'd0:hi = mult;
		1'd1:hi = div;
	endcase
end

endmodule