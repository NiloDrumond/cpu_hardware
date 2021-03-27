module cpu(
    input wire clk,
    input wire reset
);

//flags
    wire overflow;
    wire NG;
    wire zero;
    wire ET;
    wire GT;
    wire LT;

//Control wires
    wire PC_write;
    wire MEM_write;
    wire EPC_write;
    wire IR_write;
    wire REG_write;
    wire AB_write;
    wire ALUOUT_write;

    wire HILO_write;

    wire MDR_write;
    assign MDR_write = 1;

    wire multStop;
    wire divStop;
    wire divZero;
    wire MULT_control;
    wire DIV_control;

    wire [1:0]SS_control;
    wire [1:0]LS_control;

    wire [2:0]REGDST_select;
    wire [3:0]MEMTOREG_select;
    wire [2:0]PCSOURCE_select;
    wire [1:0]ALUSRCA_select;
    wire [1:0]ALUSRCB_select;
    wire HILO_select;
    wire SHIFTSRCA_select;
    wire SHIFTSRCB_select;
    wire [2:0]IORD_select;


    wire [2:0]ALU_control;
    wire [2:0]SHIFT_control;

//parts of the instruction
    wire [5:0]OPCODE;
    wire [4:0]RS;
    wire [4:0]RT;
    wire [15:0]IMMEDIATE;
//Data wires
    wire [4:0]REGDST_out;
    wire [31:0]MEMTOREG_out;

    wire [31:0]ALU_result;
    wire [31:0]PC_out;
    wire [31:0]MEM_to_IR;
    wire [31:0]RB_to_A;
    wire [31:0]RB_to_B;
    wire [31:0]A_out;
    wire [31:0]B_out;
    wire [31:0]EXT16_32_out;
    wire [31:0]EXT1_32_out;
    wire [31:0]SLEFT_2_out;
    wire [31:0]ALUSCRA_out;
    wire [31:0]ALUSCRB_out;
    wire [31:0]ALUOUT_out;
    wire [31:0]PCSOURCE_out;
    wire [31:0]EPC_out;
    wire [31:0]CONCAT_out;
    wire [31:0]SLEFT_16_out;
    wire [31:0]SHIFTSRCA_out;
    wire [4:0]SHIFTSRCB_out;
    wire [31:0]SHIFT_REG_out;
    wire [31:0]MDR_out;
    wire [31:0]SS_out;
    wire [31:0]LS_out;
    wire [31:0]IORD_out;

    wire [31:0]MULTHI_out;
    wire [31:0]MULTLO_out;
    wire [31:0]DIVHI_out;
    wire [31:0]DIVLO_out;
    wire [31:0]MHI_out;
    wire [31:0]MLO_out;
    wire [31:0]HI_out;
    wire [31:0]LO_out;

    Registrador PC_(
        clk,
        reset,
        PC_write,
        PCSOURCE_out,
        PC_out
    );

    mux_iord M_IORD_(
        IORD_select,
        PC_out,
        ALU_result,
        ALUOUT_out,
        IORD_out
    );

    Memoria MEM_(
        IORD_out,
        clk,
        MEM_write,
        SS_out,
        MEM_to_IR
    );
    Registrador MDR_(
        clk,
        reset,
        MDR_write,
        MEM_to_IR,
        MDR_out
    );
    setSize SS_(
        SS_control,
        B_out,
        MDR_out,
        SS_out
    );
    loadSize LS_(
        LS_control,
        MDR_out,
        LS_out
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
    mux_regDst M_REGDST_(
        REGDST_select,
        RT,
        IMMEDIATE,
        RS,
        REGDST_out
    );
    mult MULT_(
        clk,
        reset,
        A_out,
        B_out,
        MULT_control,
        multStop,
        MULTHI_out,
        MULTLO_out
    );
    div DIV_(
        clk,
        reset,
        A_out,
        B_out,
        DIV_control,
        divStop,
        divZero,
        DIVHI_out,
        DIVLO_out
    );
    mux_hi M_HI_(
        HILO_select,
        MULTHI_out,
        DIVHI_out,
        MHI_out
    );
    mux_lo M_LO_(
        HILO_select,
        MULTLO_out,
        DIVLO_out,
        MLO_out
    );
    Registrador HI_(
        clk,
        reset,
        HILO_write,
        MHI_out,
        HI_out
    );
    Registrador LO_(
        clk,
        reset,
        HILO_write,
        MLO_out,
        LO_out
    );
    mux_memToReg M_MEMTOREG_(
        MEMTOREG_select,
        ALU_result,
        LS_out,
        HI_out,
        LO_out,
        EXT1_32_out,
        EXT16_32_out,
        SLEFT_16_out,
        SHIFT_REG_out,
        A_out,
        B_out,
        MEMTOREG_out
    );
    mux_shiftSrcA M_SHIFTA_(
        SHIFTSRCA_select,
        A_out,
        B_out,
        SHIFTSRCA_out
    );
    mux_shiftSrcB M_SHIFTB_(
        SHIFTSRCB_select,
        B_out,
        IMMEDIATE,
        SHIFTSRCB_out
    );
    RegDesloc SHIFT_REG_(
        clk,
        reset,
        SHIFT_control,
        SHIFTSRCB_out,
        SHIFTSRCA_out,
        SHIFT_REG_out
    );
    Banco_reg REG_BASE_(
        clk,
        reset,
        REG_write,
        RS,
        RT,
        REGDST_out,
        MEMTOREG_out,
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
    shiftLeft2 SLEFT_2_(
        EXT16_32_out,
        SLEFT_2_out
    );
    sign_xtend_1_to_32 EXT1_32_(
        LT,
        EXT1_32_out
    );
    shiftLeft16 SLEFT_16_(
        IMMEDIATE,
        SLEFT_16_out
    );
    mux_aluSrcA M_ULAA_(
        ALUSRCA_select,
        PC_out,
        A_out,
        MDR_out,
        ALUSCRA_out
    );
    mux_aluSrcB M_ULAB_(
        ALUSRCB_select,
        B_out,
        EXT16_32_out,
        SLEFT_2_out,
        ALUSCRB_out
    );
    
    concat CONCAT_( // instrucoes jump
        PC_out,
        RS,
        RT,
        IMMEDIATE,
        CONCAT_out
    );

    mux_pcSource M_PCSOURCE_(
        PCSOURCE_select,
        LS_out,
        ALU_result,
        ALUOUT_out, 
        CONCAT_out,
        EPC_out,
        PCSOURCE_out
    );

    ula32 ULA_(
        ALUSCRA_out,
        ALUSCRB_out,
        ALU_control,
        ALU_result,
        overflow,
        NG,
        zero,
        ET,
        GT,
        LT
    );

    Registrador ALUOUT_(
        clk,
        reset,
        ALUOUT_write,
        ALU_result,
        ALUOUT_out
    );

     Registrador EPC_(
        clk,
        reset,
        EPC_write,
        ALU_result,
        EPC_out
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
        divZero,
        OPCODE,
        IMMEDIATE[5:0],
        MEM_write,
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