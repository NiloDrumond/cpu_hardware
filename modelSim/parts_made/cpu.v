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
    wire EPC_write;
    wire MEM_read;
    wire IR_write;
    wire REG_write;
    wire AB_write;
    wire ALUOUT_write;

    wire HILO_write;

    wire multStop,
    wire divStop;
    wire MULT_control,
    wire DIV_control;

    wire [1:0]SS_control,
    wire [1:0]LS_control,

    wire [2:0]REGDST_select,
    wire [3:0]MEMTOREG_select,
    wire [2:0]PCSOURCE_select,
    wire [1:0]ALUSRCA_select,
    wire [1:0]ALUSRCB_select,
    wire HILO_select,
    wire SHIFTSRCA_select,
    wire SHIFTSRCB_select,
    wire [2:0]IORD_select,


    wire [2:0]ALU_control;
    wire [2:0]SHIFT_control;

    //muxes
    wire [2:0]REGDST_select;
    wire [3:0]MEMTOREG_select;
    wire [1:0]ALUSRCA_select;
    wire [1:0]ALUSRCB_select;


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
    wire [31:0]ALUOUT_out;

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
        REGDST_select,
        RT,
        IMMEDIATE,
        RS,
        regDst_out
    );
    mux_memToReg M_memToReg_(
        MEMTOREG_select,
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
        REG_write,
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
    mux_aluSrcA M_ULAA_(
        ALUSRCA_select,
        PC_out,
        A_out,
        A_out, // botar mdr_out
        aluScrA_out
    );
    mux_aluSrcB M_ULAB_(
        ALUSRCB_select,
        B_out,
        EXT16_32_out,
        EXT16_32_out, // botar siftleft2_out
        aluScrB_out
    );
    ula32 ULA_(
        aluScrA_out,
        aluScrB_out,
        ALU_control,
        ALU_result,
        overflow,
        NG,
        zero,
        EQ,
        GT,
        LT
    );

    Registrador ALUOUT(
        clk,
        reset,
        ALUOUT_write,
        ALU_result,
        ALUOUT_out
    );
    ctrl_unit CTRL_(
        clk,
        reset,
        overflow,
        NG,
        zero,
        ET,
        GT,
        LT,
        multStop,
        divStop,
        OPCODE,
        IMMEDIATE[5:0],
        MEM_write,
        MEM_read,
        PC_write,
        IR_write,
        REG_write,
        AB_write,
        HILO_write,
        ALUOUT_write,
        EPC_write,
        ALU_control,
        SHIFT_control,
        MULT_control,
        DIV_control,
        SS_control,
        LS_control,
        REGDST_select,
        MEMTOREG_select,
        PCSOURCE_select,
        ALUSRCA_select,
        ALUSRCB_select,
        HILO_select,
        SHIFTSRCA_select,
        SHIFTSRCB_select,
        IORD_select
    );
endmodule