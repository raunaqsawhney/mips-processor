module pipeline_tb;

parameter base_addr = 32'h80020000;

//MEMORY REGS
reg clock;
wire [31:0] i_address;
wire [31:0] i_data_in;
wire [1:0] i_access_size;
wire i_rw;
wire i_mem_enable;

wire i_busy;
wire [31:0] i_data_out;

//F/D REGS
wire [31:0] pc_FD;

integer file;
integer count;
integer words_read;
integer scan_file;

reg[31:0] read_data;
reg[31:0] data_read;
reg stall;

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
reg rwd_DW;

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
	.i_mem_enable(i_mem_enable)
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
	.rwd(rwd)
);

initial begin
	clock = 1;
	stall = 0;

	count = 0;
	words_read = 0;

	F0.pc = base_addr - 32'h4;

	file = $fopen("SimpleAdd.x", "r");
	while($feof(file) == 0) begin
		scan_file = $fscanf(file, "%x", read_data);
		
		IM.mem[count + 0] = read_data[31:24];
		IM.mem[count + 1] = read_data[23:16];
		IM.mem[count + 2] = read_data[15:8];
		IM.mem[count + 3] = read_data[7:0];

		count = count + 4;
	end
end

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
	rwd_DW <= rwd;
end

always
	#5 clock = ! clock;

endmodule