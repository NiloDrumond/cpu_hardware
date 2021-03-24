module mux_regDst(
    input wire [2:0]seletor,
    input wire [4:0]inst_20_16,//0
    input wire [15:0]inst_15_11,//1
    input wire [4:0]inst_25_21,//4
    output reg [4:0]Data_out
);

always@(*)begin
    case (seletor)
        3'd0:Data_out = inst_20_16;
        3'd1:Data_out = inst_15_11[15:11];
        3'd2:Data_out = 5'd29;
        3'd3:Data_out = 5'd31;
        3'd4:Data_out = inst_25_21;
    endcase
end

	
endmodule
