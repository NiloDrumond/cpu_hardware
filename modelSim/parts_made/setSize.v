module setSize(
input wire [1:0] SSControl,
input wire [31:0] B,
input wire [31:0] mdr,
output reg [31:0] saidaSetSize
);

always @ (*) begin
    case(SSControl)
        2'b01: saidaSetSize = B;
        2'b10: saidaSetSize =  {mdr[31:16], B[15:0]};
        2'b11: saidaSetSize =  {mdr[31:8], B[7:0]};
    endcase
end

endmodule