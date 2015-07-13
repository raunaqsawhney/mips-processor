module memory (clock, address, data_in, access_size, rw, enable, busy, data_out);

parameter memory_depth = 1048576;
parameter base_addr = 32'h80020000;

input wire clock;
input wire[31:0] address;
input wire[31:0] data_in;
input wire[1:0] access_size;
input wire rw;
input wire enable;

output reg busy;
output reg [31:0] data_out;

integer write_total_words = 0;
integer read_total_words = 0;

integer words_written = 0;
integer words_read = 0;

reg [7:0] mem[0:memory_depth];

// TODO: Add BURST Mode ability

always @(posedge clock)
begin : WRITE
	if (!rw && enable) begin
		
		if (write_total_words > 1) begin
			busy = 1;
		end else begin
			busy = 0;
		end

		if (access_size == 2'b00) begin
			//write_total_words = 1;
			
			busy = 1;
			mem[address - base_addr + 3] <= data_in[7:0];
			mem[address - base_addr + 2] <= data_in[15:8];
			mem[address - base_addr + 1] <= data_in[23:16];
			mem[address - base_addr + 0] <= data_in[31:24];

		end else if (access_size == 2'b01) begin
			write_total_words = 4;
		end else if (access_size == 2'b10) begin
			write_total_words = 8;
		end else if (access_size == 2'b11) begin
			write_total_words = 16;
		end

		// if (words_written < write_total_words) begin
		// 	busy = 1;
			
		// 	mem[address - base_addr + 3] <= data_in[7:0];
		// 	mem[address - base_addr + 2] <= data_in[15:8];
		// 	mem[address - base_addr + 1] <= data_in[23:16];
		// 	mem[address - base_addr + 0] <= data_in[31:24];
			
		// 	words_written <= words_written + 1;
		// end else begin
		// 	busy = 0;
		// 	words_written = 0;
		// end
	end
end

always @(posedge clock)
begin : READ
	if (rw && enable) begin
		
		if (read_total_words > 1) begin
			busy = 1;
		end else begin
			busy = 0;
		end

		if (access_size == 2'b00) begin
			//read_total_words = 1;

			busy = 1;
			data_out[7:0] 	<= mem[address - base_addr + 3];
			data_out[15:8] 	<= mem[address - base_addr + 2];
			data_out[23:16] <= mem[address - base_addr + 1];
			data_out[31:24] <= mem[address - base_addr + 0];

		end else if (access_size == 2'b01) begin
			read_total_words = 4;
		end else if (access_size == 2'b10) begin
			read_total_words = 8;
		end else if (access_size == 2'b11) begin
			read_total_words = 16;
		end

		// if (words_read < read_total_words) begin
		// 	busy = 1;
			
		// 	data_out[7:0] 	<= mem[address - base_addr + 3];
		// 	data_out[15:8] 	<= mem[address - base_addr + 2];
		// 	data_out[23:16] <= mem[address - base_addr + 1];
		// 	data_out[31:24] <= mem[address - base_addr + 0];
			
		// 	words_read <= words_read + 1;
		// end else begin
		// 	busy = 0;
		// 	words_read = 0;
		// end
	end
end

endmodule
