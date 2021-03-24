module sign_xtend_1_to_32(
    input wire Data_in,
    output reg [31:0] Data_out
);
always@(*)begin
    Data_out = (32'b00000000000000000000000000000000 + Data_in);
end
endmodule