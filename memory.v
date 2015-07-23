module memory (clock, address, data_in, access_size, dm_byte, dm_half, rw, enable, busy, data_out, wm_bypass, do_wm_bypass, do_branch);

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
input wire dm_byte;
input wire dm_half;

output reg busy;
output reg [31:0] data_out;

reg [31:0] data_to_write;
reg [7:0] mem[0:memory_depth];

always @(posedge clock)
begin : WRITE
	if (!rw && enable) begin

		if (do_wm_bypass == 1) begin
			data_to_write = wm_bypass;
		end else begin
			data_to_write = data_in;
		end

		if (access_size == 2'b00) begin			
			busy = 1;
			if (dm_byte === 1 & dm_half === 0) begin
				mem[address - base_addr + 0] <= data_to_write[7:0];
			end else if (dm_byte === 0 & dm_half === 1) begin
				mem[address - base_addr + 0] <= data_to_write[7:0];
				mem[address - base_addr + 1] <= data_to_write[15:8];
			end else if (dm_byte === 0 & dm_half === 0) begin
				mem[address - base_addr + 3] <= data_to_write[7:0];
				mem[address - base_addr + 2] <= data_to_write[15:8];
				mem[address - base_addr + 1] <= data_to_write[23:16];
				mem[address - base_addr + 0] <= data_to_write[31:24];
			end
		end
	end
end

always @(posedge clock)
begin : READ
	if (rw && enable) begin
		if (access_size == 2'b00) begin
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
