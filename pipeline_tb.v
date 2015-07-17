module pipeline_tb;

parameter base_addr = 32'h80020000;
parameter NOP_OP	= 6'b100001;

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

reg do_mx_bypass;
reg do_wx_bypass;
reg do_wm_bypass;

// Data Wires (From EXECUTE Stage)
wire [31:0] aluOut;
wire [31:0] rBOut;
wire dmwe_XM_inverted;
wire [31:0] pc_effective;
wire do_branch;

//Data Wires (From WRITEBACK Stage)
wire [4:0] insn_to_d;
wire [31:0] dataout;
wire rwe_wb;

//Data Wires (From MEMORY Stage)
wire [31:0] d_data_out;

integer stall_count;
reg [4:0] rd_XM, rd_MW, rd_MW_wm_bypass;

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
	.d(insn_to_d),
	.rwe_wb(rwe_wb)
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
	.do_branch(do_branch),
	.mx_bypass(aluOut_XM),
	.do_mx_bypass(do_mx_bypass),
	.wx_bypass(dataout),
	.do_wx_bypass(do_wx_bypass)
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
	.insn_to_d(insn_to_d),
	.rwe_wb(rwe_wb)
);

initial begin
	clock = 1;
	stall = 0;

	count = 0;
	words_read = 0;

	F0.pc = base_addr - 32'h4;

	stall_count = 0;
	
	// Read input file and fill IMEM
	file = $fopen("SimpleAddTest.x", "r");
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
	
	case (rwd_DX)
		1'b0: begin
			rd_XM = IR_DX[20:16]; //rt
			rd_MW = IR_XM[20:16]; //rt
		end
		1'b1: begin
			rd_XM = IR_DX[15:11]; //rd 
			rd_MW = IR_XM[15:11]; //rd
		end
	endcase

	if (IR_DX[25:21] == rd_XM) begin
		do_mx_bypass = 1;
	end else begin
		do_mx_bypass = 0;
	end

	if (IR_DX[25:21] == rd_MW) begin
		do_wx_bypass = 1;
	end else begin
		do_wx_bypass = 0;
	end

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

	// Debug Prints
	$display("\n\nF/D: PC = %x | IR = %x", pc_FD, i_data_out);
	$display("D/X: PC = %x | IR = %x", pc_DX, IR_DX);
	$display("X/M: PC = %x | IR = %x", pc_XM, IR_XM);
	$display("M/W: PC = %x | IR = %x", pc_MW, IR_MW);


end

always
	#5 clock = ! clock;

endmodule