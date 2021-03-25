module loadSize(
    input wire [1:0] LSControl,
	input wire [31:0] mdr,
	output reg [31:0] lsOut
);

always @ (*) begin
    case(LSControl)
        2'b01: lsOut = mdr;
        2'b10: lsOut = {16'b0, mdr[15:0]};
        2'b11: lsOut = {24'b0, mdr[7:0]};
    endcase
end

endmodule