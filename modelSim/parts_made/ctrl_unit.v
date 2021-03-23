module ctrl_unit(
    input wire clk,
    input wire reset
//flags
    input wire overflow;
    input wire NG;
    input wire zero;
    input wire EQ;
    input wire GT;
    input wire LT;

//Meaningful part of the instruction
    input wire [5:0]OPCODE;
//Control wires
    output reg PC_write;
    output reg MEM_write;
    output reg IR_write;
    output reg RB_write;
    output reg AB_write;

    output reg [2:0]seletor_ALU;

    //muxes
    output reg [2:0]seletor_RegDst;
    output reg [3:0]seletor_memToReg;
    output reg [1:0]seletor_aluScrA;
    output reg [1:0]seletor_aluScrB;
// Especial output for reset instruction
    output reg reset_out
);

//machine states
parameter fetch1 = 7'd0;
parameter fetch2 = 7'd1;
parameter fetch3 = 7'd2;
parameter decode = 7'd3;
parameter decode2 = 7'd4;
parameter wait_= 7'd5;
parameter execute = 7'd6;
parameter add_sub_and = 7'd7;
parameter addi_addiu = 7'd8;


//instr R
parameter andR = 6'd36;
parameter addR = 6'd32;
parameter subR = 6'd34;

//instr I
parameter addi = 6'd8;
parameter addiu = 6'd9;


reg[6:0] state;

initial begin
    reset_out = 1'b1;
end

always @(posedge clk) begin
    if(reset == 1'b1) begin
        
    end
end

endmodule