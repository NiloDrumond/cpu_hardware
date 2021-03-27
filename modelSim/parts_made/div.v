module div(
    input wire clk,
	input wire reset,
	input wire [31:0]a,
	input wire [31:0]b,
	input wire divControl,
	output reg divStop,
	output reg divZero, 
	output reg [31:0]hi,
	output reg [31:0]lo
);


integer counter = 31;
reg [31:0] quociente;
reg [31:0] resto;
reg [31:0] dividendo;
reg [31:0] divisor;
reg negativo;
reg divNegativo;
reg aux;

initial begin
	divStop = 1'b0;
	divZero = 0;
end


always @ (posedge clk) begin
	if(reset == 1'b1) begin
		quociente = 32'b0;
		resto = 32'b0;
		dividendo = 32'b0;
		divisor = 32'b0;
		negativo = 1'b0;
		divNegativo = 1'b0;
		counter = 0;
		aux = 1'b0;
	end
	
	// Inicio do algoritmo
	if(divControl == 1'b1) begin
		lo = 32'd0;
		hi = 32'd0;
		counter = 31;
		dividendo = a;
		divisor = b;
		divStop = 1'b0;
		if(divisor == 0) begin // Checa divByZero
			divZero = 1'b1;
			counter = -10;
		end else begin
			aux = 1'b1;
			divZero = 1'b0;
		end
				
		if(a[31] != b[31]) begin
			negativo = 1'b1;
		end else begin
			negativo = 1'b0;
		end
		if(dividendo[31] == 1'b1) begin
			dividendo = (~dividendo + 32'd1);
			divNegativo = 1'b1;
		end else begin
			divNegativo = 1'b0;
		end	
		if(divisor[31] == 1'b1) begin
			divisor = (~divisor + 32'd1);
		end
		quociente = 32'b0;
		resto = 32'b0;				
	end
	
	resto = (resto << 1);
	
	resto[0] = dividendo[counter];
	
	if(resto >= divisor) begin
		resto = resto - divisor;
		quociente[counter] = 1;
	end	
	

  // Fim do algoritmo
	if(counter == 0) begin
		if(divZero == 1'b0) begin
			lo = quociente;
			hi = resto;
			if(negativo == 1'b1 && lo != 0) begin
				lo = (~lo + 1);
			end
			if(divNegativo == 1'b1 && hi != 0) begin
				hi = (~hi + 1);
			end
		end
		if(aux == 1'b1) begin
			divStop = 1'b1;
			aux = 1'b0;
		end
		counter = -10;
	end
	

  // Mantém os campos limpos caso não esteja executando o algoritmo
	if(counter == -10) begin
		quociente = 32'b0;
		resto = 32'b0;
		dividendo = 32'b0;
		divisor = 32'b0;
		negativo = 1'b0;
		counter = 0;
	end

	counter = (counter - 1);
end

endmodule: div