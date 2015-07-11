module fetch (clock, pc_out, rw, stall, address, access_size, i_mem_enable);

input wire clock;
input wire stall;

output reg [31:0] pc_out;
output reg rw;
output reg [31:0] address;
output reg [1:0] access_size;
output reg i_mem_enable;

reg [31:0] pc;

parameter base_addr = 32'h80020000;
parameter word_size = 2'b00;

always @(stall, pc)
begin
	case(stall)
		1'b0: begin
			i_mem_enable 	<= 1;
		end
		1'b1: begin
			i_mem_enable 	<= 0;
		end
	endcase
	access_size	<= word_size;
	rw 		<= 1;
	address <= pc;
end

always @(posedge clock)
begin
	case(stall)
		1'b0: begin
			pc 	<= pc + 32'h4;
		end
		1'b1: begin
			pc	<= pc;
		end
	endcase
	pc_out <= pc;
end

endmodule