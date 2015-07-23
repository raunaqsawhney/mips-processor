module decode(clock, pc, insn, rA, rB, br, jp, aluinb, aluop, dmwe, rwe, rdst, rwd, dm_byte, dm_half, rd, d, rwe_wb);

/****************OPCODES****************/
// R-Type FUNC Codes
parameter ADD           = 6'b100000; 
parameter ADDU          = 6'b100001; 
parameter SUB           = 6'b100010; 
parameter SUBU          = 6'b100011;    
parameter MULT          = 6'b011000;    
parameter MULTU         = 6'b011001;        
parameter DIV           = 6'b011010;        
parameter DIVU          = 6'b011011;        
parameter MFHI          = 6'b010000;        
parameter MFLO          = 6'b010010;        
parameter SLT           = 6'b101010; 
parameter SLTU          = 6'b101011; 
parameter SLL           = 6'b000000; 
parameter SLLV          = 6'b000100; 
parameter SRL           = 6'b000010; 
parameter SRLV          = 6'b000110; 
parameter SRA           = 6'b000011; 
parameter SRAV          = 6'b000111; 
parameter AND           = 6'b100100; 
parameter OR            = 6'b100101; 
parameter XOR           = 6'b100110; 
parameter NOR           = 6'b100111; 
parameter JALR          = 6'b001001;        
parameter JR            = 6'b001000;

// MUL R-TYPE Opcode
parameter MUL_OP        = 6'b011100;    //MUL OPCODE
parameter MUL_FUNC      = 6'b000010;    //MUL FUNCTION CODE

// I-Type Opcodes
parameter ADDI          = 6'b001000; 
parameter ADDIU         = 6'b001001; 
parameter SLTI          = 6'b001010; 
parameter SLTIU         = 6'b001011; 
parameter ANDI          = 6'b001100; 
parameter ORI           = 6'b001101; 
parameter XORI          = 6'b001110; 
parameter LW            = 6'b100011; 
parameter LH            = 6'b100001;
parameter LHU           = 6'b100101;
parameter SW            = 6'b101011; 
parameter SH            = 6'b101001;
parameter LB            = 6'b100000; 
parameter LUI           = 6'b001111; 
parameter SB            = 6'b101000; 
parameter LBU           = 6'b100100; 
parameter BEQ           = 6'b000100; 
parameter BNE           = 6'b000101; 
parameter BGTZ          = 6'b000111; 
parameter BLEZ          = 6'b000110; 

// REGIMM Opcodes
parameter BLTZ          = 6'b00000; 
parameter BGEZ          = 6'b00001; 

// J-Type Opcodes (not including JR, JALR)
parameter J             = 6'b000010;
parameter JAL           = 6'b000011;

// Other 
parameter NOP           = 6'b000000;
parameter RTYPE         = 6'b000000;
/****************************************/

/****************ALUOPS******************/
// These are used for the ALU inside
// Execute module
parameter ADD_OP        = 6'b000000;
parameter SUB_OP        = 6'b000001;
parameter MULT_OP       = 6'b000010;
parameter DIV_OP        = 6'b000011;
parameter MFHI_OP       = 6'b000100;
parameter MFLO_OP       = 6'b000101;
parameter SLT_OP        = 6'b000110;
parameter SLL_OP        = 6'b000111;
parameter SLLV_OP       = 6'b001000;
parameter SRL_OP        = 6'b001001;
parameter SRLV_OP       = 6'b001010;
parameter SRA_OP        = 6'b001011;
parameter SRAV_OP       = 6'b001100;
parameter AND_OP        = 6'b001101;
parameter OR_OP         = 6'b001110;
parameter XOR_OP        = 6'b001111;
parameter NOR_OP        = 6'b010000;
parameter JALR_OP       = 6'b010001;
parameter JR_OP         = 6'b010010;
parameter LW_OP         = 6'b010011;
parameter SW_OP         = 6'b010100;
parameter LB_OP         = 6'b010101;
parameter LUI_OP        = 6'b010110;
parameter SB_OP         = 6'b010111;
parameter LBU_OP        = 6'b011000;
parameter BEQ_OP        = 6'b011001;
parameter BNE_OP        = 6'b011010;
parameter BGTZ_OP       = 6'b011011;
parameter BLEZ_OP       = 6'b011100;
parameter BLTZ_OP       = 6'b011101;
parameter BGEZ_OP       = 6'b011110;
parameter J_OP          = 6'b011111;
parameter JAL_OP        = 6'b100000;
parameter NOP_OP        = 6'b100001;
parameter MUL_PSEUDO_OP = 6'b100010;
parameter LH_OP         = 6'b100011;
parameter SH_OP         = 6'b100100;
parameter LHU_OP        = 6'b100101;
/**************************************/

// Input Ports
input clock;
input wire [31:0] pc;       // Input pc from DECODE
input wire [31:0] insn;     // Input insn from DECODE
input wire [31:0] rd;       // Input rd of REGFILE (wired to R0 module)
input wire [4:0] d;         // Input d of REGFILE (wired to R0 module)
input wire rwe_wb;

// Output Ports
output [31:0] rA;           // Output rA of DECODE
output [31:0] rB;           // Output rB of DECODE

// Output Control Signals
output reg br;              // branch
output reg jp;              // Jump
output reg aluinb;          // ALU B Input bridged straight across E-Stage to DMEM
output reg [5:0] aluop;     // ALU OP Code (a subset of DECODE Opcodes)
output reg dmwe;            // DM Write Enable
output reg rwe;             // REGFILE Write Enable
output reg rdst;            // d input to REGFILE (either rt or rd)
output reg rwd;             // Write data from ALU or DMEM
output reg dm_byte;         // Set on a data byte instruction
output reg dm_half;         // Set on a data half word instruction

// Registers for holding s1 s2 inputs to REGFILE
reg [4:0] s1;
reg [4:0] s2;

// Include REGFILE Module
regfile R0 (
    .clock(clock),
    .s1(s1),
    .s2(s2),
    .d(d),
    .rs(rA),
    .rt(rB),
    .rd(rd),
    .rwe(rwe_wb)
);

// Decode Module is sensitive to an incoming insn
// Decode only when a new instruction is fetched
always @(insn)
begin : DECODE
    if (insn == 32'h0) begin
        // Handle the NOP case by de-asserting the branch and jump
        // Signals, so that there is no infinite branch or jump conditions
        br = 0;
        jp = 0;
        aluinb = 0;
        aluop = NOP_OP;
        rwe = 0;
        rdst = 1;
        rwd = 0;
        dmwe = 0;
        dm_byte = 0;
        dm_half = 0;

        s1 = 5'h0;
        s2 = 5'h0;
        
    end else if (insn[31:26] == RTYPE || insn[31:26] == MUL_OP) begin
        // The instruction is RTPYE
        case(insn[5:0])
            ADD: begin
                br = 0;
                jp = 0;
                aluinb = 0;
                aluop = ADD_OP;
                dmwe = 0;
                rwe = 1;
                rdst = 1;
                rwd = 0;
                dm_byte = 0;
                dm_half = 0;

                s1 = insn[25:21];   
                s2 = insn[20:16];
            end
            ADDU: begin
                br = 0;
                jp = 0;
                aluinb = 0;
                aluop = ADD_OP;
                dmwe = 0;
                rwe = 1;
                rdst = 1;
                rwd = 0;
                dm_byte = 0;
                dm_half = 0;

                s1 = insn[25:21];   
                s2 = insn[20:16];   
            end
            SUB: begin
                br = 0;
                jp = 0;
                aluinb = 0;
                aluop = SUB_OP;
                dmwe = 0;
                rwe = 1;
                rdst = 1;
                rwd = 0;
                dm_byte = 0;
                dm_half = 0;

                s1 = insn[25:21];   
                s2 = insn[20:16];   
            end
            SUBU: begin
                br = 0;
                jp = 0;
                aluinb = 0;
                aluop = SUB_OP;
                dmwe = 0;
                rwe = 1;
                rdst = 1;
                rwd = 0;
                dm_byte = 0;
                dm_half = 0;

                s1 = insn[25:21];   
                s2 = insn[20:16];   
            end
            MUL_FUNC: begin
                br = 0;
                jp = 0;
                aluinb = 0;
                aluop = MUL_PSEUDO_OP;
                dmwe = 0;
                rwe = 1;
                rdst = 1;
                rwd = 0;
                dm_byte = 0;
                dm_half = 0;

                s1 = insn[25:21];   
                s2 = insn[20:16];   
            end
            MULT: begin
                br = 0;
                jp = 0;
                aluinb = 0;
                aluop = MULT_OP;
                dmwe = 0;
                rwe = 0;
                rdst = 1'hx;
                rwd = 1'hx;
                dm_byte = 0;
                dm_half = 0;

                s1 = insn[25:21];   
                s2 = insn[20:16];   
            end
            MULTU: begin
                br = 0;
                jp = 0;
                aluinb = 0;
                aluop = MULT_OP;
                dmwe = 0;
                rwe = 0;
                rdst = 1'hx;
                rwd = 1'hx;
                dm_byte = 0;
                dm_half = 0;

                s1 = insn[25:21];   
                s2 = insn[20:16];   
            end
            DIV: begin
                br = 0;
                jp = 0;
                aluinb = 0;
                aluop = DIV_OP;
                dmwe = 0;
                rwe = 0;
                rdst = 1'hx;
                rwd = 1'hx;
                dm_byte = 0;
                dm_half = 0;

                s1 = insn[25:21];   
                s2 = insn[20:16];   
            end
            DIVU: begin
                br = 0;
                jp = 0;
                aluinb = 0;
                aluop = DIV_OP;
                dmwe = 0;
                rwe = 0;
                rdst = 1'hx;
                rwd = 1'hx;
                dm_byte = 0;
                dm_half = 0;

                s1 = insn[25:21];   
                s2 = insn[20:16];   
            end
            MFHI: begin
                br = 0;
                jp = 0;
                aluinb = 0;
                aluop = MFHI_OP;
                dmwe = 0;
                rwe = 1;
                rdst = 1;
                rwd = 0;        
                dm_byte = 0;
                dm_half = 0;

                s1 = 5'h0;  //rs is not needed
                s2 = 5'h0;  //rt is not needed
            end
            MFLO: begin
                br = 0;
                jp = 0;
                aluinb = 0;
                aluop = MFLO_OP;
                dmwe = 0;
                rwe = 1;
                rdst = 1;
                rwd = 0;        
                dm_byte = 0;
                dm_half = 0;

                s1 = 5'h0;  //rs is not needed
                s2 = 5'h0;  //rt is not needed
            end
            SLT: begin
                br = 0;
                jp = 0;
                aluinb = 0;
                aluop = SLT_OP;
                dmwe = 0;
                rwe = 1;
                rdst = 1;
                rwd = 0;
                dm_byte = 0;
                dm_half = 0;

                s1 = insn[25:21];   
                s2 = insn[20:16];   
            end
            SLTU: begin
                br = 0;
                jp = 0;
                aluinb = 0;
                aluop = SLT_OP;
                dmwe = 0;
                rwe = 1;
                rdst = 1;
                rwd = 0;
                dm_byte = 0;
                dm_half = 0;

                s1 = insn[25:21];   
                s2 = insn[20:16];   
            end
            SLL: begin
                br = 0;
                jp = 0;
                aluinb = 0;
                aluop = SLL_OP;
                dmwe = 0;
                rwe = 1;
                rdst = 1;
                rwd = 0;
                dm_byte = 0;
                dm_half = 0;

                s1 = 5'h0;      
                s2 = insn[20:16];   
            end
            SLLV: begin
                br = 0;
                jp = 0;
                aluinb = 0;
                aluop = SLLV_OP;
                dmwe = 0;
                rwe = 1;
                rdst = 1;
                rwd = 0;
                dm_byte = 0;
                dm_half = 0;

                s1 = insn[25:21];   
                s2 = insn[20:16];   
            end
            SRL: begin
                br = 0;
                jp = 0;
                aluinb = 0;
                aluop = SRL_OP;
                dmwe = 0;
                rwe = 1;
                rdst = 1;
                rwd = 0;
                dm_byte = 0;
                dm_half = 0;

                s1 = 5'h0;          
                s2 = insn[20:16];   
            end
            SRLV: begin
                br = 0;
                jp = 0;
                aluinb = 0;
                aluop = SRLV_OP;
                dmwe = 0;
                rwe = 1;
                rdst = 1;
                rwd = 0;
                dm_byte = 0;
                dm_half = 0;

                s1 = insn[25:21];   
                s2 = insn[20:16];   
            end
            SRA: begin
                br = 0;
                jp = 0;
                aluinb = 0;
                aluop = SRA_OP;
                dmwe = 0;
                rwe = 1;
                rdst = 1;
                rwd = 0;
                dm_byte = 0;
                dm_half = 0;

                s1 = 5'h0;          
                s2 = insn[20:16];   
            end
            SRAV: begin
                br = 0;
                jp = 0;
                aluinb = 0;
                aluop = SRAV_OP;
                dmwe = 0;
                rwe = 1;
                rdst = 1;
                rwd = 0;
                dm_byte = 0;
                dm_half = 0;

                s1 = insn[25:21];
                s2 = insn[20:16];
            end
            AND: begin
                br = 0;
                jp = 0;
                aluinb = 0;
                aluop = AND_OP;
                dmwe = 0;
                rwe = 1;
                rdst = 1;
                rwd = 0;
                dm_byte = 0;
                dm_half = 0;

                s1 = insn[25:21];
                s2 = insn[20:16];
            end
            OR: begin
                br = 0;
                jp = 0;
                aluinb = 0;
                aluop = OR_OP;
                dmwe = 0;
                rwe = 1;
                rdst = 1;
                rwd = 0;
                dm_byte = 0;
                dm_half = 0;

                s1 = insn[25:21];
                s2 = insn[20:16];
            end
            NOR: begin
                br = 0;
                jp = 0;
                aluinb = 0;
                aluop = NOR_OP;
                dmwe = 0;
                rwe = 1;
                rdst = 1;
                rwd = 0;
                dm_byte = 0;
                dm_half = 0;
                
                s1 = insn[25:21];
                s2 = insn[20:16];
            end
            JALR: begin
                br = 0;
                jp = 1;
                aluinb = 0;
                aluop = JALR_OP;
                dmwe = 0;
                rwe = 1;
                rdst = 1;
                rwd = 0;
                dm_byte = 0;
                dm_half = 0;

                s1 = insn[25:21];
                s2 = 5'h0;
            end
            JR: begin
                br = 0;
                jp = 1;
                aluinb = 0;
                aluop = JR_OP;  
                dmwe = 0;
                rwe = 0;
                rdst = 1;
                rwd = 0;
                dm_byte = 0;
                dm_half = 0;

                s1 = insn[25:21];
                s2 = 5'h0;
            end
        endcase
    end else if (insn[31:26] != RTYPE && insn[31:27] != 5'b00001 && insn[31:26] != 6'b000001) begin
        // Instruction is ITYPE
        case (insn[31:26])
            ADDI: begin
                br = 0;
                jp = 0;
                aluinb = 1;
                aluop = ADD_OP;
                dmwe = 0;
                rwe = 1;
                rdst = 0;
                rwd = 0;
                dm_byte = 0;
                dm_half = 0;

                s1 = insn[25:21];
                s2 = insn[20:16];
            end
            ADDIU: begin
                br = 0;
                jp = 0;
                aluinb = 1;
                aluop = ADD_OP;
                dmwe = 0;
                rwe = 1;
                rdst = 0;
                rwd = 0;
                dm_byte = 0;
                dm_half = 0;

                s1 = insn[25:21];
                s2 = insn[20:16];
            end
            SLTI: begin
                br = 0;
                jp = 0;
                aluinb = 1;
                aluop = SLT_OP;
                dmwe = 0;
                rwe = 1;
                rdst = 0;
                rwd = 0;
                dm_byte = 0;
                dm_half = 0;

                s1 = insn[25:21];
                s2 = insn[20:16];
            end
            SLTIU: begin
                br = 0;
                jp = 0;
                aluinb = 1;
                aluop = SLT_OP;
                dmwe = 0;
                rwe = 1;
                rdst = 0;
                rwd = 0;
                dm_byte = 0;
                dm_half = 0;

                s1 = insn[25:21];
                s2 = insn[20:16];
            end
            ANDI: begin
                br = 0;
                jp = 0;
                aluinb = 1;
                aluop = AND_OP;
                dmwe = 0;
                rwe = 1;
                rdst = 0;
                rwd = 0;
                dm_byte = 0;
                dm_half = 0;

                s1 = insn[25:21];
                s2 = insn[20:16];
            end
            ORI: begin
                br = 0;
                jp = 0;
                aluinb = 1;
                aluop = OR_OP;
                dmwe = 0;
                rwe = 1;
                rdst = 0;
                rwd = 0;
                dm_byte = 0;
                dm_half = 0;

                s1 = insn[25:21];
                s2 = insn[20:16];
            end
            XORI: begin
                br = 0;
                jp = 0;
                aluinb = 1;
                aluop = XOR_OP;
                dmwe = 0;
                rwe = 1;
                rdst = 0;
                rwd = 0;
                dm_byte = 0;
                dm_half = 0;

                s1 = insn[25:21];
                s2 = insn[20:16];
            end
            LW: begin
                br = 0;
                jp = 0;
                aluinb = 1;
                aluop = LW_OP;
                dmwe = 0;
                rwe = 1;
                rdst = 0;
                rwd = 1;
                dm_byte = 0;
                dm_half = 0;

                s1 = insn[25:21];
                s2 = insn[20:16];
            end
            LH: begin
                br = 0;
                jp = 0;
                aluinb = 1;
                aluop = LH_OP;
                dmwe = 0;
                rwe = 1;
                rdst = 0;
                rwd = 1;
                dm_byte = 0;
                dm_half = 1;

                s1 = insn[25:21];
                s2 = insn[20:16];
            end
            LHU: begin
                br = 0;
                jp = 0;
                aluinb = 1;
                aluop = LH_OP;
                dmwe = 0;
                rwe = 1;
                rdst = 0;
                rwd = 1;
                dm_byte = 0;
                dm_half = 1;

                s1 = insn[25:21];
                s2 = insn[20:16];
            end
            SW: begin
                br = 0;
                jp = 0;
                aluinb = 1;
                aluop = SW_OP;
                dmwe = 1;
                rwe = 0;
                dm_byte = 0;
                dm_half = 0;

                s1 = insn[25:21];
                s2 = insn[20:16];
            end
            SH: begin
                br = 0;
                jp = 0;
                aluinb = 1;
                aluop = SH_OP;
                dmwe = 1;
                rwe = 0;
                dm_byte = 0;
                dm_half = 1;

                s1 = insn[25:21];
                s2 = insn[20:16];
            end
            LB: begin
                br = 0;
                jp = 0;
                aluinb = 1;
                aluop = LB_OP;
                dmwe = 0;
                rwe = 1;
                rdst = 0;
                rwd = 1;
                dm_byte = 1;
                dm_half = 0;

                s1 = insn[25:21];
                s2 = insn[20:16];
            end
            LUI: begin
                br = 0;
                jp = 0;
                aluinb = 1;
                aluop = LUI_OP;
                dmwe = 0;
                rwe = 1;
                rdst = 0;
                rwd = 0;
                dm_byte = 0;
                dm_half = 0;

                s1 = 5'h0;
                s2 = insn[20:16];
            end
            SB: begin
                br = 0;
                jp = 0;
                aluinb = 1;
                aluop = SB_OP;
                dmwe = 1;
                rwe = 0;
                dm_byte = 1;
                dm_half = 0;

                s1 = insn[25:21];
                s2 = insn[20:16];
            end
            LBU: begin
                br = 0;
                jp = 0;
                aluinb = 1;
                aluop = LBU_OP;
                dmwe = 0;
                rwe = 1;
                rdst = 0;
                rwd = 1;
                dm_byte = 1;
                dm_half = 0;

                s1 = insn[25:21];
                s2 = insn[20:16];
            end
            BEQ: begin
                br = 1;
                jp = 0;
                aluinb = 0;
                aluop = BEQ_OP;
                dmwe = 0;
                rwe = 0;
                dm_byte = 0;
                dm_half = 0;

                s1 = insn[25:21];
                s2 = insn[20:16];
            end
            BNE: begin
                br = 1;
                jp = 0;
                aluinb = 0;
                aluop = BNE_OP;
                dmwe = 0;
                rwe = 0;
                dm_byte = 0;
                dm_half = 0;

                s1 = insn[25:21];
                s2 = insn[20:16];
            end
            BGTZ: begin
                br = 1;
                jp = 0;
                aluinb = 0;
                aluop = BGTZ_OP;
                dmwe = 0;
                rwe = 0;
                dm_byte = 0;
                dm_half = 0;

                s1 = insn[25:21];
                s2 = 5'h0;
            end
            BLEZ: begin
                br = 1;
                jp = 0;
                aluinb = 0;
                aluop = BLEZ_OP;
                dmwe = 0;
                rwe = 0;
                dm_byte = 0;
                dm_half = 0;

                s1 = insn[25:21];
                s2 = 5'h0;
            end
        endcase
    end else if (insn[31:6] == 6'b000001) begin
        // REGIMM Special Instructions (Only BLTZ and BGEZ)
        case (insn[20:16])
            BLTZ: begin
                br = 1;
                jp = 0;
                aluinb = 0;
                aluop = BLTZ_OP;
                dmwe = 0;
                rwe = 0;
                dm_byte = 0;
                dm_half = 0;

                s1 = insn[25:21];
                s2 = 5'h0;
            end
            BGEZ: begin
                br = 1;
                jp = 0;
                aluinb = 0;
                aluop = BGEZ_OP;
                dmwe = 0;
                rwe = 0;
                dm_byte = 0;
                dm_half = 0;

                s1 = insn[25:21];
                s2 = 5'h0;
            end
        endcase
    end else if (insn[31:27] == 5'b00001) begin
        // Instruction is J Type (Without Registers)
        case (insn[31:26])
            J: begin
                br = 0;
                jp = 1;
                aluinb = 0;
                aluop = J_OP;
                dmwe = 0;
                rwe = 0;
                dm_byte = 0;
                dm_half = 0;
            end
            JAL: begin
                br = 0;
                jp = 1;
                aluinb = 0;
                aluop = JAL_OP;
                dmwe = 0;
                rwe = 1;
                rwd = 0;
                dm_byte = 0;
                dm_half = 0;
            end
        endcase
    end
end

endmodule
