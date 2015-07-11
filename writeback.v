module writeback(o, d, dataout, insn, br, jp, aluinb, aluop, dmwe, rwe, rdst, rwd, insn_to_d);

// Input Data
input wire [31:0] o; //Data Out of ALU (not a mem operation)
input wire [31:0] d; //Data Out of DMEM 
input wire [31:0] insn;

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
output reg [31:0] dataout;
output reg [4:0] insn_to_d; // input d to regfile based on insn in writeback stage

always @(rwd, o, d)
begin : WRITEBACK
	case (rwd)
		1'b0: dataout <= o; // ALU operation (output data from ALU to REGFILE)
		1'b1: dataout <= d; // DMEM operation (output data from DMEM to REGFILE)
	endcase
	
	case (rdst)
		1'b0: insn_to_d <= insn[15:7]; //rd
		1'b1: insn_to_d <= insn[20:16]; //rt
	endcase
end
endmodule
