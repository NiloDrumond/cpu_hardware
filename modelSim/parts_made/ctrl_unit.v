module ctrl_unit(
    input wire clk,
    input wire reset,
//flags
    input wire overflow,
    input wire NG,
    input wire zero,
    input wire EQ,
    input wire GT,
    input wire LT,

//Meaningful part of the instruction
    input wire [5:0]OPCODE,
    input wire [5:0]FUNCT,
//Control wires
    output reg PC_write,
    output reg MEM_write,
    output reg IR_write,
    output reg RB_write,
    output reg AB_write,
    output reg ALUOUT_write,

    output reg [2:0]seletor_ALU,

    //muxes
    output reg [2:0]seletor_RegDst,
    output reg [3:0]seletor_memToReg,
    output reg [1:0]seletor_aluScrA,
    output reg [1:0]seletor_aluScrB,
// Especial output for reset instruction
    output reg reset_out
);

//machine STATEs
parameter FETCH1 = 7'd0;
parameter FETCH2 = 7'd1;
parameter FETCH3 = 7'd2;
parameter DECODE1 = 7'd3;
parameter DECODE2 = 7'd4;
parameter EXECUTE = 7'd6;
parameter ST_ADD = 7'd7;
parameter ST_SUB = 7'd8;
parameter ST_AND = 7'd9;
parameter ST_ADDI = 7'd11;
parameter ST_ADDIU = 7'd12;
parameter ALUOUT_to_Reg = 7'd10;
parameter ST_RESET = 7'd126;


//instr R
parameter AND = 6'd36;
parameter ADD = 6'd32;
parameter SUB = 6'd34;

//instr I
parameter ADDI = 6'd8;
parameter ADDIU = 6'd9;


reg[6:0] STATE;

initial begin
    reset_out = 1'b1;
end

always @(posedge clk) begin
    if(reset == 1'b1) begin
        if(STATE != ST_RESET) begin
            STATE = ST_RESET;
            PC_write = 1'b0;
            MEM_write = 1'b0;
            IR_write = 1'b0;
            RB_write = 1'b0;
            AB_write = 1'b0;
            ALUOUT_write = 1'b0;
            seletor_ALU = 3'b000;
            seletor_RegDst = 2'b00;
            seletor_memToReg = 3'b000;
            seletor_aluScrA = 2'b00;
            seletor_aluScrB = 2'b00;
            reset_out = 1'b1;
        end
        else begin
            STATE = FETCH1;
            PC_write = 1'b0;
            MEM_write = 1'b0;
            IR_write = 1'b0;
            RB_write = 1'b0;
            AB_write = 1'b0;
            ALUOUT_write = 1'b0;
            seletor_ALU = 3'b000;
            seletor_RegDst = 2'b00;
            seletor_memToReg = 3'b000;
            seletor_aluScrA = 2'b00;
            seletor_aluScrB = 2'b00;
            reset_out = 1'b0; ////
        end
    end
    else begin
        case(STATE)
            FETCH1:begin
                STATE = FETCH2;
                PC_write = 1'b0;
                MEM_write = 1'b0;
                IR_write = 1'b0; //
                RB_write = 1'b0;
                AB_write = 1'b0;
                ALUOUT_write = 1'b0;
                seletor_ALU = 3'b001;//
                seletor_RegDst = 2'b00;
                seletor_memToReg = 3'b000;
                seletor_aluScrA = 2'b00;//
                seletor_aluScrB = 2'b01;//
                reset_out = 1'b0;
            end
            FETCH2:begin
                STATE = FETCH3;
                PC_write = 1'b1;//
                MEM_write = 1'b0;
                IR_write = 1'b0;
                RB_write = 1'b0;
                AB_write = 1'b0;
                ALUOUT_write = 1'b0;
                seletor_ALU = 3'b001;
                seletor_RegDst = 2'b00;
                seletor_memToReg = 3'b000;
                seletor_aluScrA = 2'b00;
                seletor_aluScrB = 2'b01;
                reset_out = 1'b0;
            end
            FETCH3:begin
                STATE = DECODE1;
                PC_write = 1'b0;//
                MEM_write = 1'b0;
                IR_write = 1'b1;//
                RB_write = 1'b0;
                AB_write = 1'b0;
                ALUOUT_write = 1'b0;
                seletor_ALU = 3'b001;
                seletor_RegDst = 2'b00;
                seletor_memToReg = 3'b000;
                seletor_aluScrA = 2'b00;
                seletor_aluScrB = 2'b01;
                reset_out = 1'b0;
            end
            DECODE1:begin
                STATE = DECODE2;
                PC_write = 1'b0;
                MEM_write = 1'b0;
                IR_write = 1'b1;
                RB_write = 1'b0;
                AB_write = 1'b0;
                ALUOUT_write = 1'b1;//
                seletor_ALU = 3'b001;//
                seletor_RegDst = 2'b00;
                seletor_memToReg = 3'b000;
                seletor_aluScrA = 2'b00;//
                seletor_aluScrB = 2'b11;//
                reset_out = 1'b0;
            end
            DECODE2:begin
                STATE = EXECUTE;
                PC_write = 1'b0;
                MEM_write = 1'b0;
                IR_write = 1'b1;
                RB_write = 1'b0;
                AB_write = 1'b1;//
                ALUOUT_write = 1'b0;//
                seletor_ALU = 3'b001;
                seletor_RegDst = 2'b00;
                seletor_memToReg = 3'b000;
                seletor_aluScrA = 2'b00;
                seletor_aluScrB = 2'b11;
                reset_out = 1'b0;
            end
            EXECUTE:begin
                case(OPCODE)
                    5'b0000: begin
                        case(FUNCT)
                            ADD: STATE = ST_ADD;
                            SUB: STATE = ST_SUB;
                            AND: STATE = ST_AND;
                        endcase
                    end
                    ADDI: STATE = ST_ADDI;
                    ADDIU: STATE = ST_ADDIU;
                endcase
                PC_write = 1'b0;
                MEM_write = 1'b0;
                IR_write = 1'b0;
                RB_write = 1'b0;
                AB_write = 1'b0;
                ALUOUT_write = 1'b0;
                reset_out = 1'b0;
            end
            ST_ADD:begin
                STATE = ALUOUT_to_Reg;
                PC_write = 1'b0;
                MEM_write = 1'b0;
                IR_write = 1'b0;
                RB_write = 1'b0;
                AB_write = 1'b0;
                ALUOUT_write = 1'b1;//
                seletor_ALU = 3'b001;//
                seletor_RegDst = 2'b00;
                seletor_memToReg = 3'b000;
                seletor_aluScrA = 2'b01;//
                seletor_aluScrB = 2'b00;//
                reset_out = 1'b0;
            end
            ST_SUB:begin
                STATE = ALUOUT_to_Reg;
                PC_write = 1'b0;
                MEM_write = 1'b0;
                IR_write = 1'b0;
                RB_write = 1'b0;
                AB_write = 1'b0;
                ALUOUT_write = 1'b1;//
                seletor_ALU = 3'b010;//
                seletor_RegDst = 2'b00;
                seletor_memToReg = 3'b000;
                seletor_aluScrA = 2'b01;//
                seletor_aluScrB = 2'b00;//
                reset_out = 1'b0;    
            end
            ST_AND:begin
                STATE = ALUOUT_to_Reg;
                PC_write = 1'b0;
                MEM_write = 1'b0;
                IR_write = 1'b0;
                RB_write = 1'b0;
                AB_write = 1'b0;
                ALUOUT_write = 1'b1;//
                seletor_ALU = 3'b011;//
                seletor_RegDst = 2'b00;
                seletor_memToReg = 3'b000;
                seletor_aluScrA = 2'b01;//
                seletor_aluScrB = 2'b00;//
                reset_out = 1'b0;
            end
            ST_ADDI:begin
                STATE = ALUOUT_to_Reg;
                PC_write = 1'b0;
                MEM_write = 1'b0;
                IR_write = 1'b0;
                RB_write = 1'b0;
                AB_write = 1'b0;
                ALUOUT_write = 1'b1;//
                seletor_ALU = 3'b001;//
                seletor_RegDst = 2'b00;
                seletor_memToReg = 3'b000;
                seletor_aluScrA = 2'b01;//
                seletor_aluScrB = 2'b10;//
                reset_out = 1'b0;
            end
            ST_ADDIU:begin
                STATE = ALUOUT_to_Reg;
                PC_write = 1'b0;
                MEM_write = 1'b0;
                IR_write = 1'b0;
                RB_write = 1'b0;
                AB_write = 1'b0;
                ALUOUT_write = 1'b1;//
                seletor_ALU = 3'b001;//
                seletor_RegDst = 2'b00;
                seletor_memToReg = 3'b000;
                seletor_aluScrA = 2'b01;//
                seletor_aluScrB = 2'b10;//
                reset_out = 1'b0;
            end
            ALUOUT_to_Reg:begin
                STATE = FETCH1;
                PC_write = 1'b0;
                MEM_write = 1'b0;
                IR_write = 1'b0;
                RB_write = 1'b1;//
                AB_write = 1'b0;
                ALUOUT_write = 1'b1;
                seletor_ALU = 3'b001;
                seletor_RegDst = 2'b01;//
                seletor_memToReg = 3'b000;//
                seletor_aluScrA = 2'b01;
                seletor_aluScrB = 2'b10;
                reset_out = 1'b0;
            end
            ST_RESET: begin
                STATE = ST_RESET;
                PC_write = 1'b0;
                MEM_write = 1'b0;
                IR_write = 1'b0;
                RB_write = 1'b0;
                AB_write = 1'b0;
                ALUOUT_write = 1'b0;
                seletor_ALU = 3'b000;
                seletor_RegDst = 2'b00;
                seletor_memToReg = 3'b000;
                seletor_aluScrA = 2'b00;
                seletor_aluScrB = 2'b00;
                reset_out = 1'b1; //
            end
        endcase
    end
end

endmodule