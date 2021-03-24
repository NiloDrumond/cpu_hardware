module mult(
	input wire clk,
	input wire Reset,
	input wire [31:0]a,
	input wire [31:0]b,
	input wire multControl,
	output reg multStop,
	output reg [31:0] hi,
	output reg [31:0] lo
);

reg [64:0] soma;
reg [64:0] sub;
reg [64:0] produto;
reg [31:0] aNegativo;
reg aux;
integer counter = 33;

initial begin
	multStop = 1'b0;
	aux = 1'b0;
end 

always @ (posedge clk) begin
	if(Reset == 1)begin
		multStop = 1'b0;
		soma = 65'd0;
		sub = 65'd0;
		produto = 65'd0;
		aNegativo = 65'd0;
		counter = 33;
		hi = 32'd0;
	  lo = 32'd0;
	end

  // Começa o algoritmo
	if(multControl == 1'b1) begin
		aNegativo = (~a + 1'b1);
		soma = {a,33'b0};
		sub = {aNegativo, 33'b0};
		produto = {32'b0, b, 1'b0};
		counter = 33;
		multStop = 1'b0;
		aux = 1'b1;	
	end
	
	case(produto[1:0])
		2'b01: begin
			produto = produto + soma;
		end
		2'b10: begin
			produto = produto + sub;
		end		
	endcase
	
	produto = (produto >> 1);
	if(produto[63] == 1'b1) begin
		produto[64] = 1'b1;
	end	
	
	if(counter > 1) begin
		counter = (counter - 1);
	end

  // Fim do algoritmo
	if(counter == 1) begin
		hi = produto[64:33];
		lo = produto[32:1];
		counter = 0;
		if (aux == 1) begin
		   multStop = 1'b1;
		   aux = 0;	
		end		
	end	

  // Mantém os campos limpos caso não esteja executando o algoritmo
	if(counter == 0) begin
		soma = 65'd0;
		aNegativo = 32'd0;
		sub = 65'd0;
		produto = 65'd0;
	end
end

endmodule