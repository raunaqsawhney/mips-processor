module decode(clock, pc, insn, rA, rB, br, jp, aluinb, aluop, dmwe, rwe, rdst, rwd);

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

input clock;
input wire [31:0] pc;
input wire [31:0] insn;

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
reg [4:0] d;
reg [31:0] rd;

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
	if (insn[31:26] == RTYPE || insn[31:26] == MUL_OP) begin
		// Instruction R-Type

		case(insn[5:0])
			ADD: begin
				br = 0;
				jp = 0;
				aluinb = 0;
				aluop = ADD;
				dmwe = 0;
				rwe = 1;
				rdst = 1;
				rwd = 0;

				s1 = insn[25:21];
				s2 = insn[20:16];
			end
			ADDU: begin
				br = 0;
				jp = 0;
				aluinb = 0;
				aluop = ADD;
				dmwe = 0;
				rwe = 1;
				rdst = 1;
				rwd = 0;

				s1 = insn[25:21];
				s2 = insn[20:16];
			end
			SUB: begin
				br = 0;
				jp = 0;
				aluinb = 0;
				aluop = SUB;
				dmwe = 0;
				rwe = 1;
				rdst = 1;
				rwd = 0;

				s1 = insn[25:21];
				s2 = insn[20:16];
			end
			SUBU: begin
				br = 0;
				jp = 0;
				aluinb = 0;
				aluop = SUB;
				dmwe = 0;
				rwe = 1;
				rdst = 1;
				rwd = 0;

				s1 = insn[25:21];
				s2 = insn[20:16];
			end
			MUL_FUNC: begin
				br = 0;
				jp = 0;
				aluinb = 0;
				aluop = MULT;
				dmwe = 0;
				rwe = 1;
				rdst = 1;
				rwd = 0;

				s1 = insn[25:21];
				s2 = insn[20:16];
			end
			MULT: begin
				br = 0;
				jp = 0;
				aluinb = 0;
				aluop = MULT;
				dmwe = 0;
				rwe = 1;
				rdst = 1;
				rwd = 0;

				s1 = insn[25:21];
				s2 = insn[20:16];
			end
			MULTU: begin
				br = 0;
				jp = 0;
				aluinb = 0;
				aluop = MULT;
				dmwe = 0;
				rwe = 1;
				rdst = 1;
				rwd = 0;

				s1 = insn[25:21];
				s2 = insn[20:16];
			end
			DIV: begin
				br = 0;
				jp = 0;
				aluinb = 0;
				aluop = DIV;
				dmwe = 0;
				rwe = 1;
				rdst = 1;		// Pick s2, since no d
				rwd = 0;

				s1 = insn[25:21];
				s2 = insn[20:16];
			end
			DIVU: begin
				br = 0;
				jp = 0;
				aluinb = 0;
				aluop = DIV;
				dmwe = 0;
				rwe = 1;
				rdst = 0;		// Pick s2, since no d
				rwd = 0;

				s1 = insn[25:21];
				s2 = insn[20:16];
			end
			MFHI: begin
				br = 0;
				jp = 0;
				aluinb = 0;
				aluop = MFHI;
				dmwe = 0;
				rwd = 1;	// No need to writeback to regfile
			end
			MFLO: begin
				br = 0;
				jp = 0;
				aluinb = 0;
				aluop = MFLO;
				dmwe = 0;
				rwd = 1;	// No need to writeback to regfile
			end
			SLT: begin
				br = 0;
				jp = 0;
				aluinb = 0;
				aluop = SLT;
				dmwe = 0;
				rwe = 1;
				rdst = 1;
				rwd = 0;

				s1 = insn[25:21];
				s2 = insn[20:16];
			end
			SLTU: begin
				br = 0;
				jp = 0;
				aluinb = 0;
				aluop = SLT;
				dmwe = 0;
				rwe = 1;
				rdst = 1;
				rwd = 0;

				s1 = insn[25:21];
				s2 = insn[20:16];
			end
			SLL: begin
			end
			SLLV: begin
				br = 0;
				jp = 0;
				aluinb = 0;
				aluop = SLL;
				dmwe = 0;
				rwe = 1;
				rdst = 1;
				rwd = 0;

				s1 = insn[25:21];
				s2 = insn[20:16];
			end
			SRL: begin
			end
			SRLV: begin
				br = 0;
				jp = 0;
				aluinb = 0;
				aluop = SRL;
				dmwe = 0;
				rwe = 1;
				rdst = 1;
				rwd = 0;

				s1 = insn[25:21];
				s2 = insn[20:16];
			end
			SRA: begin
			end
			SRAV: begin
				br = 0;
				jp = 0;
				aluinb = 0;
				aluop = SRA;
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
				aluop = AND;
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
				aluop = OR;
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
				aluop = NOR;
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
				aluinb = 0;
				aluop = JALR;
				dmwe = 0;
				rwe = 1;
				rdst = 1;
				rwd = 0;

				s1 = insn[25:21];
				s2 = insn[20:16];
			end
			JR: begin
				br = 0;
				jp = 1;
				aluinb = 0;
				aluop = JR;
				dmwe = 0;
				rwe = 1;
				rwd = 0;

				s1 = insn[25:21];
			end
		endcase
	end else if (insn[31:26] != RTYPE && insn[31:27] != 5'b00001 && insn[31:26] != 6'b000001) begin
		// Instruction is I-TYPE

		case (insn[31:26])
			ADDI: begin
				br = 0;
				jp = 0;
				aluinb = 1;
				aluop = ADD;
				dmwe = 0;
				rwe = 1;
				rdst = 1;
				rwd = 0;

				s1 = insn[25:21];
				s2 = insn[20:16];
			end
			ADDIU: begin
				br = 0;
				jp = 0;
				aluinb = 1;
				aluop = ADD;
				dmwe = 0;
				rwe = 1;
				rdst = 1;
				rwd = 0;

				s1 = insn[25:21];
				s2 = insn[20:16];
			end
			SLTI: begin
				br = 0;
				jp = 0;
				aluinb = 1;
				aluop = SLT;
				dmwe = 0;
				rwe = 1;
				rdst = 1;
				rwd = 0;

				s1 = insn[25:21];
				s2 = insn[20:16];
			end
			SLTIU: begin
				br = 0;
				jp = 0;
				aluinb = 1;
				aluop = SLT;
				dmwe = 0;
				rwe = 1;
				rdst = 1;
				rwd = 0;

				s1 = insn[25:21];
				s2 = insn[20:16];
			end
			ORI: begin
				br = 0;
				jp = 0;
				aluinb = 1;
				aluop = OR;
				dmwe = 0;
				rwe = 1;
				rdst = 1;
				rwd = 0;

				s1 = insn[25:21];
				s2 = insn[20:16];
			end
			XORI: begin
				br = 0;
				jp = 0;
				aluinb = 1;
				aluop = XOR;
				dmwe = 0;
				rwe = 1;
				rdst = 1;
				rwd = 0;

				s1 = insn[25:21];
				s2 = insn[20:16];
			end
			LW: begin
				br = 0;
				jp = 0;
				aluinb = 1;
				aluop = LW;
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
				aluop = SW;
				dmwe = 1;
				rwe = 0;

				s1 = insn[25:21];
				s2 = insn[20:16];
			end
			LB: begin
				br = 0;
				jp = 0;
				aluinb = 1;
				aluop = LB;
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
				aluinb = 1;
				aluop = LUI;
				dmwe = 0;
				rwe = 1;
				rdst = 0;
				rwd = 1;

				s1 = 5'b0;
				s2 = insn[20:16];
			end
			SB: begin
				br = 0;
				jp = 0;
				aluinb = 1;
				aluop = SB;
				dmwe = 1;
				rwe = 0;

				s1 = insn[25:21];
				s2 = insn[20:16];
			end
			LBU: begin
				br = 0;
				jp = 0;
				aluinb = 1;
				aluop = LB;
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
				aluop = BEQ;
				dmwe = 0;
				rwe = 0;
				rdst = 0;
				rwd = 0;

				s1 = insn[25:21];
				s2 = insn[20:16];
			end
			BNE: begin
				br = 1;
				jp = 0;
				aluinb = 0;
				aluop = BNE;
				dmwe = 0;
				rwe = 0;
				rdst = 0;
				rwd = 0;

				s1 = insn[25:21];
				s2 = insn[20:16];
			end
			BGTZ: begin
				br = 1;
				jp = 0;
				aluinb = 0;
				aluop = BGTZ;
				dmwe = 0;
				rwe = 0;
				rdst = 0;
				rwd = 0;

				s1 = insn[25:21];
				s2 = insn[20:16];
			end
			BLEZ: begin
				br = 1;
				jp = 0;
				aluinb = 0;
				aluop = BLEZ;
				dmwe = 0;
				rwe = 0;
				rdst = 0;
				rwd = 0;

				s1 = insn[25:21];
				s2 = insn[20:16];
			end
		endcase
	end else if (insn[31:6] == 6'b000001) begin
		// REGIMM

		case (insn[20:16])
			BLTZ: begin
				br = 1;
				jp = 0;
				aluinb = 0;
				aluop = BLTZ;
				dmwe = 0;
				rwe = 0;
				rdst = 0;
				rwd = 0;

				s1 = insn[25:21];
				s2 = insn[20:16];
			end
			BGEZ: begin
				br = 1;
				jp = 0;
				aluinb = 0;
				aluop = BGEZ;
				dmwe = 0;
				rwe = 0;
				rdst = 0;
				rwd = 0;

				s1 = insn[25:21];
				s2 = insn[20:16];
			end
		endcase
	end else if (insn[31:27] == 5'b00001) begin

		// Instruction is J-Type
		case (insn[31:26])
			J: begin
				br = 0;
				jp = 1;
				aluinb = 0;
				aluop = J;
				dmwe = 0;
				rwe = 0;
				rdst = 0;
				rwd = 0;
			end
			JAL: begin
				br = 0;
				jp = 1;
				aluinb = 0;
				aluop = J;
				dmwe = 0;
				rwe = 0;
				rdst = 0;
				rwd = 0;

				//TODO: WORK ON THIS
			end
		endcase
	end else if (insn[31:0] == 32'h00000000) begin
		aluop = NOP;
	end
end
endmodule

