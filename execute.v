module execute (pc, rA, rB, insn, aluOut, rBOut, br, jp, aluinb, aluop, dmwe, rwe, rdst, rwd, pc_effective, do_branch);

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

output [31:0] pc_effective;
output do_branch;

reg branch_output;
wire branch_taken;
wire [31:0] branch_or_pc;

reg [31:0] branch_effective_address;
reg [31:0] jump_effective_address;

// Interal Registers
reg [31:0] hi;
reg [31:0] lo;

assign pc_effective = (jp) ? jump_effective_address : branch_effective_address;
assign do_branch = (branch_output & br) | jp;

always @(aluop, rA, rB)
begin : EXECUTE
	case (aluop)
		ADD_OP: begin
			case (aluinb)
				1'b0: aluOut = rA + rB;
				1'b1: aluOut = rA + { { 16{ insn[15] } }, insn[15:0] };
			endcase
		end
		SUB_OP: begin
			case (aluinb)
				1'b0: aluOut = rA - rB;
				1'b1: aluOut = rA - { { 16{ insn[15] } }, insn[15:0] };
			endcase
		end
		MULT_OP: begin
			lo = rA * rB;
			aluOut = 32'hx;
		end
		DIV_OP: begin
			lo = rA / rB;
			hi = rA % rB;
			aluOut = 32'hx;
		end
		MFHI_OP: begin
			aluOut = hi;
		end
		MFLO_OP: begin
			aluOut = lo;
		end
		SLT_OP: begin
			case (aluinb)
				1'b0: begin
					if (rA < rB) begin
						aluOut = 32'h1;
					end else begin
						aluOut = 32'h0;
					end
				end
				1'b1: begin
					if (rA < insn[15:0]) begin
						aluOut = 32'h1;
					end else begin
						aluOut = 32'h0;
					end
				end
			endcase
		end
		SLL_OP: begin
			aluOut = rB << insn[10:6];
		end
		SLLV_OP: begin
			aluOut = rB << rA;
		end
		SRL_OP: begin
			aluOut = rB >> insn[10:6];
		end
		SRLV_OP: begin
			aluOut = rB >> rA;
		end
		SRA_OP: begin	
			aluOut = rB >>> insn[10:6];
		end
		AND_OP: begin
			case (aluinb)
				1'b0: aluOut = rA & rB;
				1'b1: aluOut = rA & { { 16{ insn[15] } }, insn[15:0] };
			endcase
		end
		OR_OP: begin
			case (aluinb)
				1'b0: aluOut = rA | rB;
				1'b1: aluOut = rA | { { 16{ insn[15] } }, insn[15:0] };
			endcase
		end
		XOR_OP: begin
			case (aluinb)
				1'b0: aluOut = rA ^ rB;
				1'b1: aluOut = rA ^ { { 16{ insn[15] } }, insn[15:0] };
			endcase
		end
		NOR_OP: begin
				aluOut = ~(rA | rB);
		end
		J_OP: begin
			jump_effective_address = {pc[31:28], insn[25:0], 2'b00};
		end
		JAL_OP: begin
			//TODO
			jump_effective_address = {pc[31:28], insn[25:0], 2'b00};
			aluOut = pc + 8;
		end
		JALR_OP: begin
			//TODO
			jump_effective_address = rA;
			aluOut = pc + 8;
		end
		JR_OP: begin
			jump_effective_address = rA;
		end
		LW_OP: begin
			aluOut = rA + { { 16{ insn[15] } }, insn[15:0] };
		end
		LB_OP: begin
			aluOut = rA + { { 16{ insn[15] } }, insn[15:0] };
			//TODO: modify DM Access Size to allow BYTE access instead of WORD
		end
		LUI_OP: begin
			aluOut = insn[15:0] << 16;
		end
		SW_OP: begin
			aluOut = rA + { { 16{ insn[15] } }, insn[15:0] };
		end
		SB_OP: begin
			// Computes address to store BYTE of data in DMEM
			aluOut = rA + { { 16{ insn[15] } }, insn[15:0] };
			//TODO: modify DM access size to allow BYTE access instead of WORD
		end
		LBU_OP: begin
			//TODO
		end
		BEQ_OP: begin
			if (rA == rB) begin
				branch_effective_address = pc + {{14{insn[15]}}, insn[15:0], 2'b00};
				branch_output = 1;           	
			end else begin
				branch_output = 0;
			end
		end
		BNE_OP: begin
			if (rA != rB) begin
				branch_effective_address = pc + {{14{insn[15]}}, insn[15:0], 2'b00};
				branch_output = 1;
			end else begin
				branch_output = 0;
			end
		end
		BGTZ_OP: begin
			if (rA > 32'h0) begin
				branch_effective_address = pc + {{14{insn[15]}}, insn[15:0], 2'b00};
				branch_output = 1;
			end else begin
				branch_output = 0;
			end
		end
		BLEZ_OP: begin
			if (rA <= 32'h0) begin
				branch_effective_address = pc + {{14{insn[15]}}, insn[15:0], 2'b00};
				branch_output = 1;
			end else begin
				branch_output = 0;
			end
		end
		BLTZ_OP: begin
			if (rA < 32'h0) begin
				branch_effective_address = pc + {{14{insn[15]}}, insn[15:0], 2'b00};
				branch_output = 1;
			end else begin
				branch_output = 0;
			end
		end
		BGEZ_OP: begin
			if (rA >= 32'h0) begin
				branch_effective_address = pc + {{14{insn[15]}}, insn[15:0], 2'b00};
				branch_output = 1;
			end else begin
				branch_output = 0;
			end
		end
	endcase
end
endmodule
