module execute (pc, rA, rB, insn, aluOut, rBOut, br, jp, aluinb, aluop, dmwe, rwe, rdst, rwd);

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

// Input Data
input wire [31:0] pc;
input wire [31:0] insn;
input wire [31:0] rA;
input wire [31:0] rB;

// Input Controls
input wire br;
input wire jp;
input wire aluinb;
input wire [5:0] aluop;
input wire dmwe;
input wire rwe;
input wire rdst;
input wire rwd;

// Output Data
output reg [31:0] aluOut;
output reg [31:0] rBOut;

reg branch_taken;

// Interal Registers
reg [31:0] hi;
reg [31:0] lo;

always @(aluop, rA, rB)
begin : EXECUTE
	case (aluop)
		ADD: begin
			case (aluinb)
				1'b0: aluOut = rA + rB;
				1'b1: aluOut = rA + { { 16{ insn[15] } }, insn[15:0] };
			endcase
		end
		SUB: begin
			case (aluinb)
				1'b0: aluOut = rA - rB;
				1'b1: aluOut = rA - { { 16{ insn[15] } }, insn[15:0] };
			endcase
		end
		MULT: begin
			lo = rA * rB;
		end
		DIV: begin
			lo = rA / rB;
			hi = rA % rB;
		end
		MFHI: begin
			aluOut = hi;
		end
		MFLO: begin
			aluOut = lo;
		end
		SLT: begin
			if (rA < rB) begin
				aluOut = 32'h1;
			end else begin
				aluOut = 32'h0;
			end
		end
		SLL: begin
			//aluOut = rB << insn[15:6]
			// TODO, need reg sa
			// SLLV also implemented here
		end
		SRL: begin
			// TODO, need reg sa
			// SRLV also implemented here
		end
		SRA: begin
			// TODO, need reg sa
			// SRAV also implmented here
		end
		AND: begin
			case (aluinb)
				1'b0: aluOut = rA & rB;
				1'b1: aluOut = rA & { { 16{ insn[15] } }, insn[15:0] };
			endcase
		end
		OR: begin
			case (aluinb)
				1'b0: aluOut = rA | rB;
				1'b1: aluOut = rA | { { 16{ insn[15] } }, insn[15:0] };
			endcase
		end
		XOR: begin
			case (aluinb)
				1'b0: aluOut = rA ^ rB;
				1'b1: aluOut = rA ^ { { 16{ insn[15] } }, insn[15:0] };
			endcase
		end
		NOR: begin
				aluOut = ~(rA | rB);
		end
		J: begin
			//TODO
		end
		JR: begin
			aluOut = rA;
			//TODO
		end
		JALR: begin
			aluOut = pc + 8;
			//TODO
		end
		LW: begin
			// Computes address of data to load from DMEM
			aluOut = rA + { { 16{ insn[15] } }, insn[15:0] };
		end
		LB: begin
			// Computes address of data BYTE to load from DMEM
			aluOut = rA + { { 16{ insn[15] } }, insn[15:0] };
			//TODO: modify DM Access Size to allow BYTE access instead of WORD
		end
		LUI: begin
			aluOut = insn[15:0] << 16;
		end
		SW: begin
			// Computes address to store data in DMEM
			aluOut = rA + { { 16{ insn[15] } }, insn[15:0] };
		end
		SB: begin
			// Computes address to store BYTE of data in DMEM
			aluOut = rA + { { 16{ insn[15] } }, insn[15:0] };
			//TODO: modify DM access size to allow BYTE access instead of WORD
		end
		//TODO: Branches
	endcase
end
endmodule
