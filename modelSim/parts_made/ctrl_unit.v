module ctrl_unit(
    input wire clk,
    input wire reset,

//flags
    input wire overflow,
    input wire NG,
    input wire zero,
    input wire ET,
    input wire GT,
    input wire LT,
    input wire multStop,
    input wire divStop,

//Instruções
    input wire [5:0]OPCODE,
    input wire [5:0]FUNCT,

//Fios de controle
    // Registradores
    output reg MEM_write,
    output reg MEM_read,
    output reg PC_write,
    output reg IR_write,
    output reg REG_write,
    output reg AB_write,
    output reg HILO_write,
    output reg ALUOUT_write,
    output reg EPC_write,

    // Operações
    output reg [2:0]ALU_control,
    output reg [2:0]SHIFT_control,
    output reg MULT_control,
    output reg DIV_control,
    output reg [1:0]SS_control,
    output reg [1:0]LS_control,


    // Muxes
    output reg [2:0]REGDST_select,
    output reg [3:0]MEMTOREG_select,
    output reg [2:0]PCSOURCE_select,
    output reg [1:0]ALUSRCA_select,
    output reg [1:0]ALUSRCB_select,
    output reg HILO_select,
    output reg SHIFTSRCA_select,
    output reg SHIFTSRCB_select,
    output reg [2:0]IORD_select
);

//States
parameter FETCH1 = 7'd0;
parameter FETCH2 = 7'd1;
parameter FETCH3 = 7'd2;
parameter DECODE1 = 7'd3;
parameter DECODE2 = 7'd4;
parameter WAIT = 6'd5;
parameter EXECUTE = 7'd6;
parameter ADDI_ADDIU = 6'd7;
parameter ALUOUT_TO_RD = 6'd8;
parameter ALUOUT_TO_RT = 6'd22;
parameter OVERFLOWEX = 7'd9;
parameter OVERFLOWEX2 = 7'd10;
parameter OVERFLOWEX3 = 7'd11;
parameter OVERFLOWEX4 = 7'd12;
parameter DIVYBZERO = 7'd13;
parameter DIVYBZERO2 = 7'd14;
parameter DIVYBZERO3 = 7'd15;
parameter DIVYBZERO4 = 7'd16;
parameter OPCODEEX = 7'd17;
parameter OPCODEEX2 = 7'd18;
parameter OPCODEEX3 = 7'd19;
parameter OPCODEEX4 = 7'd20;
parameter END = 7'd21;

//instr R
parameter R_FORMAT = 6'd0;
parameter AND = 6'd36;
parameter ADD = 6'd32;
parameter SUB = 6'd34;
parameter DIV = 6'd26;
parameter MULT = 6'd24;
parameter JR = 6'd8;
parameter MFHI = 6'd16;
parameter MFLO = 6'd18;
parameter BREAK = 6'd13;
parameter RTE = 6'd19;
parameter XCGH = 6'd5;
parameter SLT = 6'd42;
parameter SLL = 6'd0;
parameter SRL = 6'd2;
parameter SRA = 6'd3;
parameter SLLV = 6'd4;
parameter SRAV = 6'd7;

//instr I
parameter ADDI = 6'd8;
parameter ADDIU = 6'd9;
parameter BEQ = 6'd4;
parameter BNE = 6'd5;
parameter BLE = 6'd6;
parameter BGT = 6'd7;
parameter BLM = 6'd1;
parameter LB = 6'h20;
parameter LH = 6'h21;
parameter LW = 6'hF;
parameter SB = 6'h28;
parameter SH = 6'h29;
parameter SW = 6'h2B;
parameter LUI = 6'h23;
parameter SLTI = 6'hA;

// instr J
parameter J = 6'h2;
parameter JAL = 6'h3;



reg[6:0] STATE;

initial begin
    STATE = FETCH1;
end

always @(posedge clk) begin
    if(reset == 1'b1) begin
        STATE = FETCH1;
        MEM_write = 0;
        MEM_read = 0;
        PC_write = 0;
        IR_write = 0;
        REG_write = 0;
        AB_write = 0;
        HILO_write = 0;
        ALUOUT_write = 0;
        EPC_write = 0;
        ALU_control = 3'd0;
        SHIFT_control = 3'd0;
        MULT_control = 0;
        DIV_control = 0;
        SS_control = 2'd0;
        LS_control = 2'd0;
        REGDST_select = 3'd0;
        MEMTOREG_select = 4'd0;
        PCSOURCE_select = 3'd0;
        ALUSRCA_select = 2'd0;
        ALUSRCB_select = 2'd0;
        HILO_select = 0;
        SHIFTSRCA_select = 0;
        SHIFTSRCB_select = 0;
        IORD_select = 3'd0;
    end
    else begin
        case(STATE)
            FETCH1:begin
                STATE = FETCH2;
                IORD_select = 3'd0;
                ALUSRCA_select = 2'd0;
                ALUSRCB_select = 2'd1;
                REG_write = 0;
                ALU_control = 3'd1;
                MEM_write = 0;
            end
            FETCH2:begin
                STATE = FETCH3;
                PCSOURCE_select = 3'd1;
                PC_write = 1;
            end
            FETCH3:begin
                STATE = DECODE1;
                PC_write = 0;
                MEM_read = 0;
                LS_control = 2'd0;  
                SS_control = 2'd0;
                IR_write = 1;
            end
            DECODE1:begin
                STATE = DECODE2;
                IR_write = 0;
                ALUSRCA_select = 2'd0;
                ALUSRCA_select = 2'd3;
                ALU_control = 3'd1;
                ALUOUT_write = 1;
            end
            DECODE2:begin
                STATE = EXECUTE;
                AB_write = 1;
                ALUOUT_write = 0;
            end
            EXECUTE:begin
                case(OPCODE)
                    R_FORMAT: begin
                        case(FUNCT)
                            ADD: STATE = ADD;
                            SUB: STATE = SUB;
                            AND: STATE = AND;
                            DIV: STATE = DIV;
                            MULT: STATE = MULT;
                            JR: STATE = JR;
                            MFHI: STATE = MFHI;
                            MFLO: STATE = MFLO;
                            BREAK: STATE = BREAK;  
                            RTE: STATE = RTE;
                            XCGH: STATE = XCGH;
                            SLT: STATE = SLT;
                            SLL: STATE = SLL;
                            SRL: STATE = SRL;
                            SRA: STATE = SRA;
                            SLLV: STATE = SLLV;
                            SRAV: STATE = SRAV;
                        endcase
                    end
                    ADDI: STATE = ADDI;
                    ADDIU: STATE = ADDIU;
                    BEQ: STATE = BEQ;
                    BNE: STATE = BNE;
                    BLE: STATE = BLE;
                    BGT: STATE = BGT;
                    BLM: STATE = BLM;
                    LB: STATE = LB;
                    LH: STATE = LH;
                    LW: STATE = LW;
                    SB: STATE = SB;
                    SH: STATE = SH;
                    SW: STATE = SW;
                    LUI: STATE = LUI;
                    SLTI: STATE = SLTI;
                    J: STATE = J;
                    JAL: STATE = JAL;
                endcase
                AB_write = 0;
                case(STATE)
                    ADD:begin
                        STATE = ALUOUT_TO_RD;
                        ALUSRCA_select = 2'd1;
                        ALUSRCB_select = 2'd0;
                        ALU_control = 3'd1;
                        ALUOUT_write = 1;
                    end
                    SUB:begin
                        STATE = ALUOUT_TO_RD;
                        ALUSRCA_select = 2'd1;
                        ALUSRCB_select = 2'd0;
                        ALU_control = 3'd2;
                        ALUOUT_write = 1;
                    end
                    AND:begin
                        STATE = ALUOUT_TO_RD;
                        ALUSRCA_select = 2'd1;
                        ALUSRCB_select = 2'd0;
                        ALU_control = 3'd3;
                        ALUOUT_write = 1;
                    end
                    ADDI:begin
                        STATE = ADDI_ADDIU;
                        ALUSRCA_select = 2'd1;
                        ALUSRCB_select = 2'd2;
                        ALU_control = 3'd1;
                        ALUOUT_write = 1;
                    end
                    ADDIU:begin
                        STATE = ADDI_ADDIU;
                        ALUSRCA_select = 2'd1;
                        ALUSRCB_select = 2'd2;
                        ALU_control = 3'd3;
                        ALUOUT_write = 1;
                    end
                endcase
            end
            ADDI_ADDIU:begin
                if (overflow == 1 && OPCODE == ADDI) begin // overflow apenas no addi
                    STATE = OVERFLOWEX;
                end
                else begin
                    STATE = ALUOUT_TO_RT;
                end
            end
            ALUOUT_TO_RD:begin
                STATE = END;
                ALUOUT_write = 0;
                REGDST_select = 3'd1;
                MEMTOREG_select = 4'd0;
                REG_write = 1;
            end
            ALUOUT_TO_RT:begin
                STATE = END;
                ALUOUT_write = 0;
                REGDST_select = 3'd0;
                MEMTOREG_select = 4'd0;
                REG_write = 1;
            end
            END: begin
                STATE = FETCH1;
                MEM_write = 0;
                MEM_read = 0;
                PC_write = 0;
                IR_write = 0;
                REG_write = 0;
                AB_write = 0;
                HILO_write = 0;
                ALUOUT_write = 0;
                EPC_write = 0;
                ALU_control = 3'd0;
                SHIFT_control = 3'd0;
                MULT_control = 0;
                DIV_control = 0;
                SS_control = 2'd0;
                LS_control = 2'd0;
                REGDST_select = 3'd0;
                MEMTOREG_select = 4'd0;
                PCSOURCE_select = 3'd0;
                ALUSRCA_select = 2'd0;
                ALUSRCB_select = 2'd0;
                HILO_select = 0;
                SHIFTSRCA_select = 0;
                SHIFTSRCB_select = 0;
                IORD_select = 3'd0;
            end
        endcase
    end
end

endmodule