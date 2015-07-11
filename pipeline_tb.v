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

	// Finished writing to IMEM, now READ
	//i_rw = 1;
	//i_address = base_addr;
end
/*
always @(posedge clock) begin
	// if (rw == 0) begin
	// 	scan_file = $fscanf(file, "%x", data_in);
	// 	if ($feof(file) == 0) begin
	// 		$display("data_in = %x", data_in);
	// 		address = address + 32'h4;

	// 		count = count + 4;
	// 	end
	// end

	/
	if (i_rw == 1 && words_read <= count) begin
		data_read = i_data_out;
		i_address = i_address + 32'h4;
		words_read = words_read + 4;
	end
	
end
*/

/*
always @(negedge clock) begin
	if (i_rw == 1 && words_read <= count) begin
		$display("data_out = %x", i_data_out);
	end
end
*/

always
	#5 clock = ! clock;

endmodule