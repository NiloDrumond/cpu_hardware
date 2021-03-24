module loadSize(
    input wire [1:0] LSControl,
	input wire [31:0] mdr,
	output reg [31:0] lsOut
);

always @ (*) begin
	if(LSControl == 2'b01) begin
		lsOut = mdr;
	end else if(LSControl == 2'b10) begin
		lsOut = {16'b0, mdr[15:0]};
	end else if (LSControl == 2'b11) begin
		lsOut = {24'b0, mdr[7:0]};
	end
end

endmodule