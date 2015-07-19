module memory (clock, address, data_in, access_size, rw, enable, busy, data_out, wm_bypass, do_wm_bypass, do_branch);

parameter memory_depth = 1048576;
parameter base_addr = 32'h80020000;

input wire clock;
input wire[31:0] address;
input wire[31:0] data_in;
input wire[1:0] access_size;
input wire rw;
input wire enable;

input wire do_branch;

input wire [31:0] wm_bypass;
input wire do_wm_bypass;

output reg busy;
output reg [31:0] data_out;

integer write_total_words = 0;
integer read_total_words = 0;

integer words_written = 0;
integer words_read = 0;

reg [7:0] mem[0:memory_depth];

// TODO: Add BURST Mode ability
reg [31:0] data_to_write;

always @(posedge clock)
begin : WRITE
	if (!rw && enable) begin
		
		if (do_wm_bypass == 1) begin
			data_to_write = wm_bypass;
		end else begin
			data_to_write = data_in;
		end

		if (access_size == 2'b00) begin
			//write_total_words = 1;
			
			busy = 1;
			mem[address - base_addr + 3] <= data_to_write[7:0];
			mem[address - base_addr + 2] <= data_to_write[15:8];
			mem[address - base_addr + 1] <= data_to_write[23:16];
			mem[address - base_addr + 0] <= data_to_write[31:24];
		end
	end
end

always @(posedge clock)
begin : READ
	if (rw && enable) begin
		if (access_size == 2'b00) begin
			//read_total_words = 1;
			busy = 1;
			data_out[7:0] 	<= mem[address - base_addr + 3];
			data_out[15:8] 	<= mem[address - base_addr + 2];
			data_out[23:16] <= mem[address - base_addr + 1];
			data_out[31:24] <= mem[address - base_addr + 0];
		end
		if (do_branch === 1) begin
			busy = 1;
			data_out <= 32'h0;
		end
	end
end

endmodule
