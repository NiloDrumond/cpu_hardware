module shiftLeft16(
    input wire [15:0] immediate,
    output reg [31:0] shiftLeft16Out
);

always @ (*) begin
    shiftLeft16Out = {immediate,{16{1'b0}}};
end
	
endmodule