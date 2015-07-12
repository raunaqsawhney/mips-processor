module pipeline_tb;

parameter base_addr = 32'h80020000;

// File IO 
integer file;
integer count;
integer words_read;
integer scan_file;

reg[31:0] read_data;
reg[31:0] data_read;
reg stall;
integer i;

reg clock;

//IMEM REGS
wire [31:0] i_address;
wire [31:0] i_data_in;
wire [1:0] i_access_size;
wire i_rw;
wire i_mem_enable;
wire i_busy;

//DMEM REGS
wire [31:0] d_address;
wire [31:0] d_data_in;
reg [1:0] d_access_size;
wire d_rw;
reg d_mem_enable;
wire d_busy;

//FD Registers
wire [31:0] pc_FD;
wire [31:0] i_data_out;

//DX Registers
reg [31:0] pc_DX;
reg [31:0] IR_DX;
reg [31:0] rA_DX;
reg [31:0] rB_DX;
reg br_DX;
reg jp_DX;
reg aluinb_DX;
reg [5:0] aluop_DX;
reg dmwe_DX;
reg rwe_DX;
reg rdst_DX;
reg rwd_DX;

//XM Registers
reg [31:0] pc_XM;
reg [31:0] IR_XM;
reg [31:0] aluOut_XM;
reg [31:0] rBOut_XM;
reg br_XM;
reg jp_XM;
reg aluinb_XM;
reg [5:0] aluop_XM;
reg dmwe_XM;
reg rwe_XM;
reg rdst_XM;
reg rwd_XM;

//MW Registers
reg [31:0] pc_MW;
reg [31:0] IR_MW;
reg [31:0] o_MW;
reg [31:0] d_MW; 
reg br_MW;
reg jp_MW;
reg aluinb_MW;
reg [5:0] aluop_MW;
reg dmwe_MW;
reg rwe_MW;
reg rdst_MW;
reg rwd_MW;

// Control Wires (From the DECODE Stage)
wire [31:0] rA;
wire [31:0] rB;
wire br;
wire jp;
wire aluinb;
wire [5:0] aluop;
wire dmwe;
wire rwe;
wire rdst;
wire rwd;

// Data Wires (From EXECUTE Stage)
wire [31:0] aluOut;
wire [31:0] rBOut;
wire dmwe_XM_inverted;
wire [31:0] pc_effective;
wire do_branch;

//Data Wires (From WRITEBACK Stage)
wire [4:0] insn_to_d;
wire [31:0] dataout;

//Data Wires (From MEMORY Stage)
wire [31:0] d_data_out;

memory IM (
	.clock(clock),
	.address(i_address),
	.data_in(i_data_in),
	.access_size(i_access_size),
	.rw(i_rw),
	.enable(i_mem_enable),
	.busy(i_busy),
	.data_out(i_data_out)
);

fetch #(.base_addr(base_addr)) F0 (
	.clock(clock),
	.pc_out(pc_FD),
	.rw(i_rw),
	.stall(stall),
	.address(i_address),
	.access_size(i_access_size),
	.i_mem_enable(i_mem_enable),
	.pc_effective(pc_effective),
	.do_branch(do_branch)
);

decode D0 (
	.clock(clock),
	.pc(pc_FD),
	.insn(i_data_out),
	.rA(rA),
	.rB(rB),
	.br(br),
	.jp(jp),
	.aluinb(aluinb),
	.aluop(aluop),
	.dmwe(dmwe),
	.rwe(rwe),
	.rdst(rdst),
	.rwd(rwd),
	.rd(dataout),
	.d(insn_to_d)
);

execute E0 (
	.pc(pc_DX),
	.rA(rA_DX),
	.rB(rB_DX),
	.insn(IR_DX),
	.br(br_DX),
	.jp(jp_DX),
	.aluinb(aluinb_DX),
	.aluop(aluop_DX),
	.dmwe(dmwe_DX),
	.rwe(rwe_DX),
	.rdst(rdst_DX),
	.rwd(rwd_DX),
	.aluOut(aluOut),
	.rBOut(rBOut),
	.pc_effective(pc_effective),
	.do_branch(do_branch)
);

memory DM (
	.clock(clock),
	.address(aluOut_XM),
	.data_in(rBOut_XM),
	.access_size(d_access_size),
	.rw(dmwe_XM_inverted),	// Set DMEM RW (DMWE) to the dmwe control signal in XM Registers
	.enable(d_mem_enable),
	.busy(d_busy),
	.data_out(d_data_out)
);

writeback W0 (
	.o(o_MW),
	.d(d_data_out),
	.dataout(dataout),
	.insn(IR_MW),
	.br(br_MW),
	.jp(jp_MW),
	.aluinb(aluinb_MW),
	.aluop(aluop_MW),
	.dmwe(dmwe_MW),
	.rwe(rwe_MW),
	.rdst(rdst_MW),
	.rwd(rwd_MW),
	.insn_to_d(insn_to_d)
);

initial begin
	clock = 1;
	stall = 0;

	count = 0;
	words_read = 0;

	F0.pc = base_addr - 32'h4;

	// Read input file and fill IMEM
	file = $fopen("SimpleAdd.x", "r");
	while($feof(file) == 0) begin
		scan_file = $fscanf(file, "%x", read_data);
		
		IM.mem[count + 0] = read_data[31:24];
		IM.mem[count + 1] = read_data[23:16];
		IM.mem[count + 2] = read_data[15:8];
		IM.mem[count + 3] = read_data[7:0];

		DM.mem[count + 0] = read_data[31:24];
		DM.mem[count + 1] = read_data[23:16];
		DM.mem[count + 2] = read_data[15:8];
		DM.mem[count + 3] = read_data[7:0];

		count = count + 4;
	end
	
	// Initialize REGFILE
	for (i = 0; i < 32; i = i + 1) begin
		D0.R0.REGFILE[i] = 32'b0;
	end

	// Set SP (r29) to last valid address in Memory region
    	D0.R0.REGFILE[29] = base_addr + IM.memory_depth;

    	// Set RA return address (r31) to a known value
    	D0.R0.REGFILE[31] = 32'hdeadbeef; 

	d_access_size = 2'b00;
	d_mem_enable = 1;
	
end

assign dmwe_XM_inverted = ~dmwe_XM;

always @(posedge clock) begin
	
	pc_DX <= pc_FD;
	IR_DX <= i_data_out;
	rA_DX <= rA;
	rB_DX <= rB;
	br_DX <= br;
	jp_DX <= jp;
	aluinb_DX <= aluinb;
	aluop_DX <= aluop;
	dmwe_DX <= dmwe;
	rwe_DX <= rwe;
	rdst_DX <= rdst;
	rwd_DX <= rwd;

	pc_XM <= pc_DX;
	IR_XM <= IR_DX;
	aluOut_XM <= aluOut;
	rBOut_XM <= rB_DX;
	br_XM <= br_DX;
	jp_XM <= jp_DX;
	aluinb_XM <= aluinb_DX;
	aluop_XM <= aluop_DX;
	dmwe_XM <= dmwe_DX;
	rwe_XM <= rwe_DX;
	rdst_XM <= rdst_DX;
	rwd_XM <= rwd_DX;

	pc_MW <= pc_XM;
	IR_MW <= IR_XM;
	o_MW <= aluOut_XM;
	d_MW <= d_data_out;
	br_MW <= br_XM;
	jp_MW <= jp_XM;
	aluinb_MW <= aluinb_XM;
	aluop_MW <= aluop_XM;
	dmwe_MW <= dmwe_XM;
	rwe_MW <= rwe_XM;
	rdst_MW <= rdst_XM;
	rwd_MW <= rwd_XM;
end

always
	#5 clock = ! clock;

endmodule