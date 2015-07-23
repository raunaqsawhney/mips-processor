module fetch (clock, pc_out, rw, stall, address, access_size, i_mem_enable, pc_effective, do_branch);

input wire clock;
input wire stall;

// Wires from EXECUTE for Branch/Jump PC and 
// Signal do_branch is used to detect if a branch 
// is done or not
input wire [31:0] pc_effective;
input wire do_branch;

// Outputs of FETCH Stage into DECODE
output reg [31:0] pc_out;
output reg rw;
output reg [31:0] address;
output reg [1:0] access_size;
output reg i_mem_enable;

reg [31:0] pc;

parameter base_addr = 32'h80020000;
parameter word_size = 2'b00;	// Default: 1 Word Access Size

// Fetch Module sensitive to a new PC or STALL Signal
// In the case of STALL, must not FETCH new PC and 
// must disable IMEM. Otherwise, always read FROM IMEM
always @(stall, pc)
begin
	case(stall)
		1'b0: i_mem_enable <= 1;
		1'b1: i_mem_enable <= 0;
	endcase
	access_size <= word_size;
	rw <= 1;
	address <= pc;
end

// Output the FETCHED PC on a clock edge
// If a branch was taken, then set PC to 
// Effective PC computed in EXECUTE Stage

always @(posedge clock)
begin
	case(stall)
		1'b0: begin
			case(do_branch)
				1'b0: begin
					pc <= pc + 32'h4;
					pc_out <= pc;
				end
				1'b1: begin
					pc <= pc_effective;
					pc_out <= 32'h0;
				end
				default: begin
					pc <= pc + 32'h4;
					pc_out <= pc;
				end
			endcase
		end
		1'b1: begin
			case(do_branch)
				1'b0: begin
					pc <= pc;
					pc_out <= pc;
				end
				1'b1: begin 
					pc <= pc_effective;
					pc_out <= 32'h0;
				end
			endcase
		end
	endcase
end

endmodule
