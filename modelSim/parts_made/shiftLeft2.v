module shiftLeft2(
input wire [31:0] signExt,
output reg [31:0] shiftLeft2Out2
);

always @ (*) begin
    shiftLeft2Out2 = signExt << 2;
end

endmodule