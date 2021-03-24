module muxHi(
input logic  hiControl,
input logic [31:0] mult,
input logic [31:0] div,
output logic [31:0] hi
);

always 
	case (hiControl)
		1'd0: begin
			hi = mult;
		end
		1'd1: begin
			hi = div;
		end
	endcase
	
endmodule