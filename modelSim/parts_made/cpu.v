module cpu(
    input wire clk,
    input wire reset
);

//flags
    wire overflow;
    wire NG;
    wire zero;
    wire EQ;
    wire GT;
    wire LT;

//Control wires
    wire PC_write;
    wire MEM_write;
    wire IR_write;
    wire RB_write;
    wire AB_write;

    wire [2:0]seletor_ALU;

    //muxes
    wire [2:0]seletor_RegDst;
    wire [3:0]seletor_memToReg;
    wire [1:0]seletor_aluScrA;
    wire [1:0]seletor_aluScrB;


//parts of the instruction
    wire [5:0]OPCODE;
    wire [4:0]RS;
    wire [4:0]RT;
    wire [15:0]IMMEDIATE;
//Data wires
    wire [4:0]regDst_out; // regDst -> memoria
    wire [31:0]memToReg_out; // memToReg -> memoria

    wire [31:0]ALU_result;
    wire [31:0]PC_out;
    wire [31:0]MEM_to_IR;
    wire [31:0]RB_to_A;
    wire [31:0]RB_to_B;
    wire [31:0]A_out;
    wire [31:0]B_out;
    wire [31:0]EXT16_32_out;
    wire [31:0]aluScrA_out;
    wire [31:0]aluScrB_out;
    

    Registrador PC_(
        clk,
        reset,
        PC_write,
        ALU_result,//botar mux_pcSource
        PC_out
    );

    Memoria MEM_(
        PC_out, // botar mux_iord
        clk,
        MEM_write,
        ALU_result, //botar data_in
        MEM_to_IR
    );
    Instr_Reg IR_(
        clk,
        reset,
        IR_write,
        MEM_to_IR,
        OPCODE,
        RS,
        RT,
        IMMEDIATE
    );
    mux_regDst M_regDst_(
        seletor_RegDst,
        RT,
        RD,
        IMMEDIATE,
        regDst_out
    );
    mux_memToReg M_memToReg_(
        seletor_memToReg,
        ALU_result,
        ALU_result,
        ALU_result,
        ALU_result,
        ALU_result,
        ALU_result,
        ALU_result,
        ALU_result,
        ALU_result,
        ALU_result,
        memToReg_out
    );
    Banco_reg REG_BASE_(
        clk,
        reset,
        RB_write,
        RS,
        RT,
        regDst_out,
        memToReg_out,
        RB_to_A,
        RB_to_B
    );
    Registrador A_(
        clk,
        reset,
        AB_write,
        RB_to_A,
        A_out
    );
    Registrador B_(
        clk,
        reset,
        AB_write,
        RB_to_B,
        B_out
    );

    sign_xtend_16_to_32 EXT16_32_(
        IMMEDIATE,
        EXT16_32_out
    );
    mux_ulaA M_ULAA_(
        seletor_aluScrA,
        PC_out,
        A_out,
        A_out, // botar mdr_out
        aluScrA_out
    );
    mux_ulaB M_ULAB_(
        seletor_aluScrB,
        B_out,
        EXT16_32_out,
        aluScrB_out
    );
    ula32 ULA_(
        aluScrA_out,
        aluScrB_out,
        seletor_ALU,
        ALU_result,
        overflow,
        NG,
        zero,
        EQ,
        GT,
        LT
    );

    ctrl_unit CTRL_(
        clk,
        reset,
        overflow,
        NG,
        zero,
        EQ,
        GT,
        LT,
        OPCODE,
        PC_write,
        MEM_write,
        IR_write,
        RB_write,
        AB_write,
        seletor_ALU,
        seletor_RegDst,
        seletor_memToReg,
        seletor_aluScrA,
        seletor_aluScrB,
        reset
    );
endmodule