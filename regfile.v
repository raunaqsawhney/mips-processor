module regfile(clock, s1, s2, d, rs, rt, rd, rwe);

input wire clock;
input wire [4:0] s1;
input wire [4:0] s2;
input wire [4:0] d;
input wire [31:0] rd;
input wire rwe;

output [31:0] rs;
output [31:0] rt;

reg [31:0] REGFILE [31:0];


integer i;
initial begin
	for (i = 0; i < 32; i = i + 1) begin
		REGFILE[i] = i;
	end
end

//Combinationally write to rs and rt
assign rs = (s1 != 0) ? REGFILE[s1] : 0;
assign rt = (s2 != 0) ? REGFILE[s2] : 0;

always @(negedge clock)
	if (rwe == 1) begin
		REGFILE[d] <= rd;
	end

endmodule