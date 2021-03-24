module setSize(
input wire [1:0] SSControl,
input wire [31:0] B,
input wire [31:0] mdr,
output reg [31:0] saidaSetSize
);

always @ (*) begin
	if(SSControl == 2'b01) begin
		saidaSetSize = B;
	end 
	else if(SSControl == 2'b10) begin
		saidaSetSize =  mdr[31:16], B[15:0]};
	end 
	else if(SSControl == 2'b11) begin 
		saidaSetSize =  mdr[31:8], B[7:0]};
	end
end

endmodule