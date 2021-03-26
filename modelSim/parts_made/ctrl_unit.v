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
    input wire divZero,

//Instruções
    input wire [5:0]OPCODE,
    input wire [5:0]FUNCT,

//Fios de controle
    // Registradores
    output reg MEM_write,
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
parameter WAIT = 7'd5;
parameter EXECUTE = 7'd6;
parameter ADDI_ADDIU = 7'd7;
parameter ALUOUT_TO_RD = 7'd8;
parameter ALUOUT_TO_RT = 7'd22;
parameter OVERFLOWEX1 = 7'd9;
parameter OVERFLOWEX2 = 7'd10;
parameter DIVYBZEROEX1 = 7'd11;
parameter DIVYBZEROEX2 = 7'd12;
parameter OPCODEEX1 = 7'd13;
parameter OPCODEEX2 = 7'd14;
parameter END_EXCEPTION1 = 7'd15;
parameter END_EXCEPTION2 = 7'd16;
parameter END_EXCEPTION3 = 7'd17;
parameter END = 7'd21;
parameter MULT2 = 7'd23;
parameter MULT3 = 7'd24;
parameter SLLV2 = 7'd25;
parameter SRAV2 = 7'd26;
parameter SHIFT_END = 7'd27;
parameter SLL2 = 7'd30;
parameter SRL2 = 7'd31;
parameter SRA2 = 7'd32;
parameter XCGH2 = 7'd33;
parameter SW2 = 7'd34;
parameter SH2 = 7'd35;
parameter SB2 = 7'd36;
parameter LW2 = 7'd37;
parameter LH2 = 7'd38;
parameter LB2 = 7'd39;
parameter LW3 = 7'd40;
parameter LH3 = 7'd41;
parameter LB3 = 7'd42;
parameter JAL_END = 7'd43;
parameter SW3 = 7'd44;
parameter SW4 = 7'd45;
parameter BLM2 = 7'd46;
parameter BLM3 = 7'd47;
parameter BLM4 = 7'd48;
parameter SH3 = 7'd49;
parameter SH4 = 7'd50;
parameter SB3 = 7'd51;
parameter SB4 = 7'd52;
parameter SW5 = 7'd53;
parameter SB5 = 7'd54;
parameter SH5 = 7'd55;
parameter LW4 = 7'd56;
parameter LB4 = 7'd57;
parameter LH4 = 7'd58;
parameter BEQ2 = 7'd59;
parameter BNE2 = 7'd60;
parameter BGT2 = 7'd61;
parameter BLE2 = 7'd62;
parameter BLM5 = 7'd63;
parameter JAL2 = 7'D64;
parameter DIV2 = 7'd65;
parameter DIV3 = 7'd66;

//instr R
parameter R_FORMAT = 6'd0;
parameter ADD = 6'h20;
parameter AND = 6'h24;
parameter SUB = 6'h22;
parameter DIV = 6'h1a;
parameter MULT = 6'h18;
parameter JR = 6'h8;
parameter MFHI = 6'h10;
parameter MFLO = 6'h12;
parameter BREAK = 6'hD;
parameter RTE = 6'h13;
parameter XCGH = 6'h5;
parameter SLT = 6'h2a;
parameter SLL = 6'h0;
parameter SRL = 6'h2;
parameter SRA = 6'h3;
parameter SLLV = 6'h4;
parameter SRAV = 6'h7;

//instr I
parameter ADDI = 6'h8;
parameter ADDIU = 6'h9;
parameter BEQ = 6'h4;
parameter BNE = 6'h5;
parameter BLE = 6'h6;
parameter BGT = 6'h7;
parameter BLM = 6'h1;
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
    if(reset == 1'b1) begin // Tratar heap
        STATE = FETCH1;
        MEM_write = 0;
        PC_write = 0;
        IR_write = 0;
        REG_write = 1;
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
        REGDST_select = 3'd2;
        MEMTOREG_select = 4'd8;
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
                MEMTOREG_select = 4'd0;
                REG_write = 0;
                REGDST_select = 3'd0;

                STATE = FETCH2;
                IORD_select = 3'd0;
                ALUSRCA_select = 2'd0;
                ALUSRCB_select = 2'd1;
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
                AB_write = 0;   
                case(OPCODE)
                    R_FORMAT: begin
                        case(FUNCT)
                            ADD: begin
                                STATE = ALUOUT_TO_RD;
                                ALUSRCA_select = 2'd1;
                                ALUSRCB_select = 2'd0;
                                ALU_control = 3'd1;
                                ALUOUT_write = 1;
                            end
                            SUB: begin
                                STATE = ALUOUT_TO_RD;
                                ALUSRCA_select = 2'd1;
                                ALUSRCB_select = 2'd0;
                                ALU_control = 3'd2;
                                ALUOUT_write = 1;
                            end
                            AND: begin
                                STATE = ALUOUT_TO_RD;
                                ALUSRCA_select = 2'd1;
                                ALUSRCB_select = 2'd0;
                                ALU_control = 3'd3;
                                ALUOUT_write = 1;
                            end
                            DIV: begin
                                STATE = DIV2;
                                DIV_control = 1;
                            end     
                            MULT: begin
                                STATE = MULT2;
                                MULT_control = 1;
                            end
                            JR: begin
                                STATE = END;
                                ALUSRCA_select = 2'd1;
                                ALU_control = 3'd0;
                                PCSOURCE_select = 3'd1;
                                PC_write = 1;
                            end
                            MFHI: begin
                                STATE = END;
                                MEMTOREG_select = 4'd02;
                                REGDST_select = 3'd1;
                            end
                            MFLO: begin
                                STATE = END;
                                MEMTOREG_select = 4'd03;
                                REGDST_select = 3'd1;
                            end
                            BREAK: begin
                                STATE = END;
                                ALUSRCA_select = 2'd0;
                                ALUSRCB_select = 2'd1;
                                ALU_control = 3'd2;
                                PCSOURCE_select = 3'd1;
                                PC_write = 1;
                            end
                            SLT: begin
                                STATE = END;
                                ALUSRCA_select = 2'd1;
                                ALUSRCB_select = 2'd0;
                                ALU_control = 3'd7;
                                REGDST_select = 3'd1;
                                MEMTOREG_select = 4'd1;
                                REG_write = 1;
                            end
                            RTE: begin
                                STATE = END;
                                PCSOURCE_select = 3'd4;
                                PC_write = 1;
                            end
                            XCGH: begin
                                STATE = XCGH2;
                                MEMTOREG_select = 4'd09;
                                REGDST_select = 3'd0;
                                REG_write = 1;
                            end
                            SLL: begin
                                SHIFTSRCA_select = 1;
                                SHIFTSRCB_select = 1;
                                SHIFT_control = 3'd1;
                                STATE = SLL2;
                            end
                            SRL: begin
                                SHIFTSRCA_select = 1;
                                SHIFTSRCB_select = 1;
                                SHIFT_control = 3'd1;
                                STATE = SRL2;
                            end 
                            SRA: begin
                                SHIFTSRCA_select = 1;
                                SHIFTSRCB_select = 1;
                                SHIFT_control = 3'd1;
                                STATE = SRA2;
                            end 
                            SLLV: begin
                                SHIFTSRCA_select = 0;
                                SHIFTSRCB_select = 0;
                                SHIFT_control = 3'd1;
                                STATE = SLLV2;
                            end
                            SRAV: begin
                                SHIFTSRCA_select = 0;
                                SHIFTSRCB_select = 0;
                                SHIFT_control = 3'd1;
                                STATE = SRAV2;
                            end
                        endcase
                    end
                    ADDI: begin
                        STATE = ALUOUT_TO_RT;
                        ALUSRCA_select = 2'd1;
                        ALUSRCB_select = 2'd2;
                        ALU_control = 3'd1;
                        ALUOUT_write = 1;
                    end
                    ADDIU: begin
                        STATE = ALUOUT_TO_RT;
                        ALUSRCA_select = 2'd1;
                        ALUSRCB_select = 2'd2;
                        ALU_control = 3'd3;
                        ALUOUT_write = 1;
                    end
                    BEQ: begin
                       ALUSRCA_select = 1; 
                       ALUSRCB_select = 1; 
                       ALU_control = 3'b111;
                       STATE = BEQ2;
                    end 
                    BNE: begin
                       ALUSRCA_select = 1; 
                       ALUSRCB_select = 1; 
                       ALU_control = 3'b111;
                       STATE = BNE2;
                    end 
                   BLE: begin
                       ALUSRCA_select = 1; 
                       ALUSRCB_select = 1; 
                       ALU_control = 3'b111;
                       STATE = BLE2;
                    end 
                    BGT: begin
                       ALUSRCA_select = 1; 
                       ALUSRCB_select = 1; 
                       ALU_control = 3'b111;
                       STATE = BGT2;
                    end 
                    BLM: begin
                        ALUSRCA_select = 1; 
                        ALUSRCB_select = 1; 
                        ALU_control = 3'b000;
                        IORD_select = 3'd1;
                        STATE = BLM2;
                    end
                    SW: begin
                        ALUSRCA_select = 2'd1;
                        ALUSRCB_select = 2'd2;
                        ALU_control = 3'd1;
                        ALUOUT_write = 1;
                        STATE = SW2;
                    end
                    SH: begin
                        ALUSRCA_select = 2'd1;
                        ALUSRCB_select = 2'd2;
                        ALU_control = 3'd1;
                        ALUOUT_write = 1;
                        STATE = SH2;
                    end
                    SB: begin
                        ALUSRCA_select = 2'd1;
                        ALUSRCB_select = 2'd2;
                        ALU_control = 3'd1;
                        ALUOUT_write = 1;
                        STATE = SB2;
                    end
                    LW: begin
                        ALUSRCA_select = 2'd1;
                        ALUSRCB_select = 2'd2;
                        ALU_control = 3'd1;
                        IORD_select = 1;
                        MEM_write = 0;
                        STATE = LW2;
                    end  
                    LH: begin
                        ALUSRCA_select = 2'd1;
                        ALUSRCB_select = 2'd2;
                        ALU_control = 3'd1;
                        IORD_select = 1;
                        MEM_write = 0;
                        STATE = LH2;
                    end  
                    LB: begin
                        ALUSRCA_select = 2'd1;
                        ALUSRCB_select = 2'd2;
                        ALU_control = 3'd1;
                        IORD_select = 1;
                        MEM_write = 0;
                        STATE = LB2;
                    end  
                    SLTI: begin
                        STATE = END;
                        ALUSRCA_select = 2'd1;
                        ALUSRCB_select = 2'd2;
                        ALU_control = 3'd7;
                        REGDST_select = 3'd0;
                        MEMTOREG_select = 4'd4;
                        REG_write = 1;
                    end
                    LUI: begin
                        STATE = END;
                        MEMTOREG_select = 4'd6;
                        REGDST_select = 3'd0;
                        REG_write = 1;
                    end
                    J: begin
                        STATE = END;
                        PCSOURCE_select = 3'd3;
                        PC_write = 1;
                    end 
                    JAL: begin
                        ALUSRCA_select = 2'd0;
                        ALU_control = 3'd0;
                        ALUOUT_write = 1;
                        STATE = JAL2;
                    end
                    default: begin// OPCODE Inexistente
                        STATE = OPCODEEX1;
                    end
                endcase 
            end 
            SW2: begin
                STATE = SW3;
                IORD_select = 2'd2;
                MEM_write = 0;
            end
            SW3: begin
                STATE = SW4;
            end
            SW4: begin
                STATE = SW5;
            end
            SW5: begin
                STATE = END;
                SS_control = 2'd1;
                MEM_write = 1;
            end
            SH2: begin
                STATE = SH3;
                IORD_select = 2'd2;
                MEM_write = 0;
            end
            SH3: begin
                STATE = SH4;
            end
            SH4: begin
                STATE = SH5;
            end
            SH5: begin
                STATE = END;
                SS_control = 2'd2;
                MEM_write = 1;
            end
            SB: begin
                STATE = SB3;
                IORD_select = 2'd2;
                MEM_write = 0;
            end
            SB3: begin
                STATE = SB4;
            end
            SB4: begin
                STATE = SB5;
            end
            SB5: begin
                STATE = END;
                SS_control = 2'd3;
                MEM_write = 1;
            end
            LW2: begin
                STATE = LW3;
            end
            LW3: begin
                STATE = LW4;
            end
            LW4: begin
                STATE = END;
                LS_control = 2'd1;
                REG_write = 1;
                MEMTOREG_select = 1;
                REGDST_select = 0;
            end
            LH2: begin
                STATE = LH3;
            end
            LH3: begin
                STATE = LH4;
            end
            LH4: begin
                STATE = END;
                LS_control = 2'd2;
                REG_write = 1;
                MEMTOREG_select = 1;
                REGDST_select = 0;
            end
            LB2: begin
                STATE = LB3;
            end
            LB3: begin
                STATE = LB4;
            end
            LB4: begin
                STATE = END;
                LS_control = 2'd3;
                REG_write = 1;
                MEMTOREG_select = 1;
                REGDST_select = 0;
            end
            XCGH2: begin
                STATE = END;
                MEMTOREG_select = 4'd10;
                REGDST_select = 3'd4;
            end
            MULT2: begin
                if(multStop == 1) begin
                    STATE = MULT3;
                end
            end
            MULT3: begin
                HILO_select = 0;
                HILO_write = 1;
                STATE = END;
            end
            DIV2: begin
                if (divZero) begin
					STATE = DIVYBZEROEX1;
                end else begin
                    if(divStop == 1) begin
                        STATE = DIV3;
                    end 
                end
            end
            DIV3: begin
                HILO_select = 1;
                HILO_write = 1;
                STATE = END;
            end
            SLLV2: begin
                SHIFT_control = 3'b010;
                STATE = SHIFT_END;
            end
            SRAV2: begin
                SHIFT_control = 3'b100;
                STATE = SHIFT_END;
            end
            SLL2: begin
                SHIFT_control = 3'b010;
                STATE = SHIFT_END;
            end
            SRL2: begin
                SHIFT_control = 3'b011;
                STATE = SHIFT_END;
            end
            SRA2: begin
                SHIFT_control = 3'b100;
                STATE = SHIFT_END;
            end
            SHIFT_END: begin
                REG_write = 1;
                MEMTOREG_select = 4'd7;
                REGDST_select = 3'd1; 
                STATE = END;
            end
            JAL2: begin
                PCSOURCE_select = 3'd3;
                PC_write = 1;
                STATE = JAL_END;
            end
            BEQ2: begin
                if(ET == 1) begin
                    PCSOURCE_select = 3'd2;
                    PC_write = 1;
                end
                STATE = END;
            end
            BNE2: begin
                if(ET == 0) begin
                    PCSOURCE_select = 3'd2;
                    PC_write = 1;
                end
                STATE = END;
            end
            BLE2: begin
                if(GT == 0) begin
                    PCSOURCE_select = 3'd2;
                    PC_write = 1;
                end
                STATE = END;
            end
            BGT2: begin
                if(GT == 1) begin
                    PCSOURCE_select = 3'd2;
                    PC_write = 1;
                end
                STATE = END;
            end
            BLM2: begin
                STATE = BLM3;
            end
            BLM3: begin
                STATE = BLM4;
            end
            BLM4: begin
                ALUSRCA_select = 2'd2;
                ALUSRCB_select = 2'd0;
                ALU_control = 3'b111;
                STATE = BLM5;
            end
            BLM5: begin
                if(LT == 1) begin
                    PCSOURCE_select = 3'd2;
                    PC_write = 1; 
                end
                STATE = END;                
            end
            ALUOUT_TO_RD:begin
                if (overflow == 1 && (OPCODE == ADD || OPCODE == SUB)) begin // overflow apenas no addi
                    STATE = OVERFLOWEX1;
                end 
                STATE = END;
                ALUOUT_write = 0;
                REGDST_select = 3'd1;
                MEMTOREG_select = 4'd0;
                REG_write = 1;
            end
            ALUOUT_TO_RT:begin
                if (overflow == 1 && OPCODE == ADDI) begin // overflow apenas no addi
                    STATE = OVERFLOWEX1;
                end 
                else begin
                    STATE = END;
                    ALUOUT_write = 0;
                    REGDST_select = 3'd0;
                    MEMTOREG_select = 4'd0;
                    REG_write = 1;  
                end 
            end
            END: begin
                STATE = FETCH1;
                MEM_write = 0;
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
            OPCODEEX1: begin
                STATE = OPCODEEX2;
                ALUSRCA_select = 2'd0;
                ALUSRCB_select = 2'd1;
                ALU_control = 3'd2;
                EPC_write = 1;
            end
            OPCODEEX2: begin
                STATE = END_EXCEPTION1;
                IORD_select=3'd3;
                MEM_write = 0;
            end
            OVERFLOWEX1: begin
                STATE = OVERFLOWEX2;
                ALUSRCA_select = 2'd0;
                ALUSRCB_select = 2'd1;
                ALU_control = 3'd2;
                EPC_write = 1;
            end
            OVERFLOWEX2: begin
                STATE = END_EXCEPTION1;
                IORD_select=3'd4;
                MEM_write = 0;
            end
            DIVYBZEROEX1: begin
                STATE = DIVYBZEROEX2;
                ALUSRCA_select = 2'd0;
                ALUSRCB_select = 2'd1;
                ALU_control = 3'd2;
                EPC_write = 1;
            end
            DIVYBZEROEX2: begin
                STATE = END_EXCEPTION1;
                IORD_select=3'd5;
                MEM_write = 0;
            end
            END_EXCEPTION1: begin
                STATE = END_EXCEPTION2;//wait
            end
            END_EXCEPTION2: begin
                STATE = END_EXCEPTION3;//wait
            end
            END_EXCEPTION3: begin
                STATE = END;
                PC_write = 1;
                PCSOURCE_select = 3'd0;
                PCSOURCE_select = 3'd0;
                LS_control = 2'd3;
            end
            
        endcase
    end
end

endmodule