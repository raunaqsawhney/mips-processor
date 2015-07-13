module decode(clock, pc, insn, rA, rB, br, jp, aluinb, aluop, dmwe, rwe, rdst, rwd, rd, d);

/****************OPCODES******************/
// R-Type FUNC Codes
parameter ADD 	= 6'b100000; //ADD;
parameter ADDU 	= 6'b100001; //ADDU;
parameter SUB	= 6'b100010; //SUB;
parameter SUBU	= 6'b100011; //SUBU;	
parameter MULT	= 6'b011000; //MULT;	
parameter MULTU = 6'b011001; //MULTU;		
parameter DIV	= 6'b011010; //DIV;		
parameter DIVU 	= 6'b011011; //DIVU;		
parameter MFHI	= 6'b010000; //MFHI;		
parameter MFLO 	= 6'b010010; //MFLO;		
parameter SLT	= 6'b101010; //SLT;
parameter SLTU	= 6'b101011; //SLTU;
parameter SLL	= 6'b000000; //SLL;
parameter SLLV	= 6'b000100; //SLLV;
parameter SRL	= 6'b000010; //SRL;
parameter SRLV	= 6'b000110; //SRLV;
parameter SRA	= 6'b000011; //SRA;
parameter SRAV	= 6'b000111; //SRAV;
parameter AND	= 6'b100100; //AND;
parameter OR	= 6'b100101; //OR;
parameter XOR	= 6'b100110; //XOR;
parameter NOR	= 6'b100111; //NOR
parameter JALR	= 6'b001001; //JALR;		
parameter JR	= 6'b001000; //JR;		

// MUL R-TYPE Opcode
parameter MUL_OP = 6'b011100; 	//MUL OPCODE
parameter MUL_FUNC = 6'b000010; //MUL FUNCTION CODE

// I-Type Opcodes
parameter ADDI  = 6'b001000; //ADDI (LI)
parameter ADDIU = 6'b001001; //ADDIU
parameter SLTI  = 6'b001010; //SLTI
parameter SLTIU = 6'b001011; //SLTIU
parameter ANDI  = 6'b001100; //ANDI
parameter ORI	= 6'b001101; //ORI
parameter XORI  = 6'b001110; //XORI
parameter LW	= 6'b100011; //LW
parameter SW	= 6'b101011; //SW
parameter LB	= 6'b100000; //LB
parameter LUI   = 6'b001111; //LUI
parameter SB	= 6'b101000; //SB
parameter LBU	= 6'b100100; //LBU
parameter BEQ	= 6'b000100; //BEQ
parameter BNE	= 6'b000101; //BNE
parameter BGTZ	= 6'b000111; //BGTZ
parameter BLEZ	= 6'b000110; //BLEZ

// REGIMM Opcodes
parameter BLTZ = 5'b00000; // BLTZ
parameter BGEZ = 5'b00001; // BGEZ 

// J-Type Opcodes
parameter J     = 6'b000010;
parameter JAL	= 6'b000011;

// Other 
parameter NOP   = 6'b000000;
parameter RTYPE = 6'b000000;
/******************************************/

/****************ALUOPS******************/
parameter ADD_OP 	= 6'b000000;
parameter SUB_OP	= 6'b000001;
parameter MULT_OP	= 6'b000010;		
parameter DIV_OP	= 6'b000011;		
parameter MFHI_OP	= 6'b000100;
parameter MFLO_OP 	= 6'b000101;	
parameter SLT_OP	= 6'b000110;
parameter SLL_OP	= 6'b000111;
parameter SLLV_OP	= 6'b001000;
parameter SRL_OP	= 6'b001001;
parameter SRLV_OP	= 6'b001010;
parameter SRA_OP	= 6'b001011;
parameter SRAV_OP	= 6'b001100;
parameter AND_OP	= 6'b001101;
parameter OR_OP		= 6'b001110;
parameter XOR_OP	= 6'b001111;
parameter NOR_OP	= 6'b010000;
parameter JALR_OP	= 6'b010001;	
parameter JR_OP		= 6'b010010;
parameter LW_OP		= 6'b010011;
parameter SW_OP		= 6'b010100;
parameter LB_OP		= 6'b010101;
parameter LUI_OP   	= 6'b010110;
parameter SB_OP		= 6'b010111;
parameter LBU_OP	= 6'b011000;
parameter BEQ_OP	= 6'b011001;
parameter BNE_OP	= 6'b011010;
parameter BGTZ_OP	= 6'b011011;
parameter BLEZ_OP	= 6'b011100;
parameter BLTZ_OP 	= 6'b011101;
parameter BGEZ_OP  	= 6'b011110;
parameter J_OP 		= 6'b011111;
parameter JAL_OP    	= 6'b100000;
parameter NOP_OP	= 6'b100001;
/**************************************/

input clock;
input wire [31:0] pc;
input wire [31:0] insn;
input wire [31:0] rd;
input wire [4:0] d;

output [31:0] rA;
output [31:0] rB;

output reg br;
output reg jp;
output reg aluinb;
output reg [5:0] aluop;
output reg dmwe;
output reg rwe;
output reg rdst;
output reg rwd;

reg [4:0] s1;
reg [4:0] s2;

regfile R0 (
	.clock(clock),
	.s1(s1),
	.s2(s2),
	.d(d),
	.rs(rA),
	.rt(rB),
	.rd(rd),
	.rwe(rwe)
);

always @(insn)
begin : DECODE
	if (insn == 32'h0) begin
		// NOP
		aluop = NOP_OP;
		br = 0;
		jp = 0;
	end else if (insn[31:26] == RTYPE || insn[31:26] == MUL_OP) begin
		// Instruction R-Type
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

				s1 = insn[25:21];	//rs
				s2 = insn[20:16];	//rt
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

				s1 = insn[25:21];	//rs
				s2 = insn[20:16];	//rt
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

				s1 = insn[25:21];	//rs
				s2 = insn[20:16];	//rt
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

				s1 = insn[25:21];	//rs
				s2 = insn[20:16];	//rt
			end
			MUL_FUNC: begin
				br = 0;
				jp = 0;
				aluinb = 0;
				aluop = MULT_OP;
				dmwe = 0;
				rwe = 0;
				rdst = 1'hx;
				rwd = 1'hx;

				s1 = insn[25:21];	//rs
				s2 = insn[20:16];	//rt
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

				s1 = insn[25:21];	//rs
				s2 = insn[20:16];	//rt
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

				s1 = insn[25:21];	//rs
				s2 = insn[20:16];	//rt
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

				s1 = insn[25:21];	//rs
				s2 = insn[20:16];	//rt
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

				s1 = insn[25:21];	//rs
				s2 = insn[20:16];	//rt
			end
			MFHI: begin
				br = 0;
				jp = 0;
				aluinb = 1'hx;
				aluop = MFHI_OP;
				dmwe = 0;
				rwe = 0;
				rdst = 1;		
				rwd = 0;

				s1 = 5'h0;	//rs is not needed
				s2 = 5'h0;	//rt is not needed
			end
			MFLO: begin
				br = 0;
				jp = 0;
				aluinb = 1'hx;
				aluop = MFLO_OP;
				dmwe = 0;
				rwe = 0;
				rdst = 1;		
				rwd = 0;

				s1 = 5'h0;	//rs is not needed
				s2 = 5'h0;	//rt is not needed
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

				s1 = insn[25:21];	//rs
				s2 = insn[20:16];	//rt
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

				s1 = insn[25:21];	//rs
				s2 = insn[20:16];	//rt
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

				s1 = 5'h0;		//rs
				s2 = insn[20:16];	//rt
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

				s1 = insn[25:21];	//rs
				s2 = insn[20:16];	//rt
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

				s1 = 5'h0;			//rs
				s2 = insn[20:16];	//rt
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

				s1 = insn[25:21];	//rs
				s2 = insn[20:16];	//rt
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

				s1 = 5'h0;			//rt
				s2 = insn[20:16];	//rt
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

				s1 = insn[25:21];
				s2 = insn[20:16];
			end
			JALR: begin
				br = 0;
				jp = 1;
				aluinb = 1'hx;
				aluop = JALR_OP;
				dmwe = 0;
				rwe = 1;
				rdst = 1;
				rwd = 0;

				s1 = insn[25:21];
				s2 = 5'h0;
			end
			JR: begin
				br = 0;
				jp = 1;
				aluinb = 1'hx;
				aluop = JR_OP;
				dmwe = 0;
				rwe = 0;
				rdst = 1'hx;
				rwd = 1'hx;

				s1 = insn[25:21];
				s2 = 5'h0;
			end
		endcase
	end else if (insn[31:26] != RTYPE && insn[31:27] != 5'b00001 && insn[31:26] != 6'b000001) begin
		// Instruction is I-TYPE

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
				rdst = 1'hx;
				rwd = 1'hx;

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

				s1 = insn[25:21];
				s2 = insn[20:16];
			end
			LUI: begin
				br = 0;
				jp = 0;
				aluinb = 1'hx;
				aluop = LUI_OP;
				dmwe = 0;
				rwe = 1;
				rdst = 0;
				rwd = 1;

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
				rdst = 1'hx;
				rwd = 1'hx;

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
				rdst = 1'hx;
				rwd = 1'hx;

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
				rdst = 1'hx;
				rwd = 1'hx;

				s1 = insn[25:21];
				s2 = insn[20:16];
			end
			BGTZ: begin
				br = 1;
				jp = 0;
				aluinb = 1'hx;
				aluop = BGTZ_OP;
				dmwe = 0;
				rwe = 0;
				rdst = 1'hx;
				rwd = 1'hx;

				s1 = insn[25:21];
				s2 = 5'h0;
			end
			BLEZ: begin
				br = 1;
				jp = 0;
				aluinb = 1'hx;
				aluop = BLEZ_OP;
				dmwe = 0;
				rwe = 0;
				rdst = 1'hx;
				rwd = 1'hx;

				s1 = insn[25:21];
				s2 = 5'h0;
			end
		endcase
	end else if (insn[31:6] == 6'b000001) begin
		// REGIMM

		case (insn[20:16])
			BLTZ: begin
				br = 1;
				jp = 0;
				aluinb = 1'hx;
				aluop = BLTZ_OP;
				dmwe = 0;
				rwe = 0;
				rdst = 1'hx;
				rwd = 1'hx;

				s1 = insn[25:21];
				s2 = 5'h0;
			end
			BGEZ: begin
				br = 1;
				jp = 0;
				aluinb = 1'hx;
				aluop = BGEZ_OP;
				dmwe = 0;
				rwe = 0;
				rdst = 1'hx;
				rwd = 1'hx;

				s1 = insn[25:21];
				s2 = 5'h0;
			end
		endcase
	end else if (insn[31:27] == 5'b00001) begin

		// Instruction is J-Type
		case (insn[31:26])
			J: begin
				br = 0;
				jp = 1;
				aluinb = 1'hx;
				aluop = J_OP;
				dmwe = 0;
				rwe = 0;
				rdst = 1'hx;
				rwd = 1'hx;
			end
			JAL: begin
				br = 0;
				jp = 1;
				aluinb = 1'hx;
				aluop = JAL_OP;
				dmwe = 0;
				rwe = 0;
				rdst = 1'hx;
				rwd = 1'hx;
			end
		endcase
	end
end
endmodule
