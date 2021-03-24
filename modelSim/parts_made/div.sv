module div(
	input logic [31:0]a,
	input logic [31:0]b,
	input logic clk,
	input logic reset,
	input logic divControl,
	output logic divStop, // sinal informando que o algoritmo encerrou
	output logic divZero,
	output logic [31:0]hiDiv,
	output logic [31:0]loDiv
);


integer counter = 31;
logic [31:0] quociente;
logic [31:0] resto;
logic [31:0] dividendo;
logic [31:0] divisor;
logic g;
logic j;
logic aux;

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
		g = 1'b0;
		j = 1'b0;
		counter = 0;
		aux = 1'b0;
	end
	
	if(divControl == 1'b1) begin
		
		loDiv = 32'd0;
		hiDiv = 32'd0;
		counter = 31;
		dividendo = a;
		divisor = b;
		divStop = 1'b0;
		if(divisor == 0) begin // checando uma possivel excecao de divBy0
			divZero = 1'b1;
			counter = 1;
		end else begin
			aux = 1'b1;
			divZero = 1'b0;
		end
				
		if(a[31] != b[31]) begin
			g = 1'b1;
		end else begin
			g = 1'b0;
		end
		if(dividendo[31] == 1'b1) begin
			dividendo = (~dividendo + 32'd1);
			j = 1'b1;
		end else begin
			j = 1'b0;
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
	
	if(counter == 0) begin
		if(divZero == 1'b0) begin
			loDiv = quociente;
			hiDiv = resto;
			if(g == 1'b1 && loDiv != 0) begin
				loDiv = (~loDiv + 1);
			end
			if(j == 1'b1 && hiDiv != 0) begin
				hiDiv = (~hiDiv + 1);
			end
		end
		if(aux == 1'b1) begin
			divStop = 1'b1;
			aux = 1'b0;
		end
		counter = -10;
	end
	
	if(counter == -10) begin
		quociente = 32'b0;
		resto = 32'b0;
		dividendo = 32'b0;
		divisor = 32'b0;
		g = 1'b0;
		counter = 0;
	end
	counter = (counter - 1);// checando os casos onde o resto pode ser 0
		
end

endmodule: div