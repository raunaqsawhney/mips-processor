module writeback(o, d, dataout, insn, br, jp, aluinb, aluop, dmwe, rwe, rdst, rwd, dm_byte, insn_to_d, rwe_wb);

parameter JAL_OP    	= 6'b100000;
parameter JALR_OP	= 6'b010001;
parameter LB_OP		= 6'b010101;
parameter LBU_OP	= 6'b011000;

// Input Ports
input wire [31:0] o; //Data Out of ALU (not a mem operation)
input wire [31:0] d; //Data Out of DMEM 
input wire [31:0] insn;

// Input Control Signal Ports
input wire br;
input wire jp;
input wire aluinb;
input wire [5:0] aluop;
input wire dmwe;
input wire rwe;
input wire rdst;
input wire rwd;
input wire dm_byte;

// Output Data Ports
output reg [31:0] dataout;
output reg [4:0] insn_to_d; // input d to regfile based on insn in writeback stage
output reg rwe_wb;

always @(insn, rwd, rdst, aluop)
begin : WRITEBACK

	// Determine if the data to be written back is from DMEM or ALU
	case (rwd)
		1'b0: dataout <= o; // ALU operation (output data from ALU to REGFILE)
		1'b1: dataout <= d;
	endcase
	
	// Determine if the destination register is Rt or Rd
	case (rdst)
		1'b0: insn_to_d <= insn[20:16]; //rt
		1'b1: insn_to_d <= insn[15:11]; //rd
	endcase

	if (aluop == LB_OP) begin
		dataout <= { { 24{ d[31] } }, d[31:24] };
	end
	//if (aluop == LBU_OP) begin
//		dataout <= { { 24{ 1'b0 } }, d[31:24] };
//	end
	if (aluop == JAL_OP || aluop == JALR_OP) begin
		// In the SPECIAL case of JAL and JALR insns, the return address register rA (r31)
		// should be written be value PC + 8
		insn_to_d <= 5'h1F;	//rA (r31 in REGFILE), dataout should be PC + 8 from E-Stage
		dataout <= o;
	end

	// Output control signal to control the rwe port of Register File inside DECODE module
	rwe_wb <= rwe;

end

endmodule