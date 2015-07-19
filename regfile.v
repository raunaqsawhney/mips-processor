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

//Combinationally output rs and rt from Register File
assign rs = (s1 != 0) ? REGFILE[s1] : 0;
assign rt = (s2 != 0) ? REGFILE[s2] : 0;

// Write on the negative clock edge to the Register File
always @(negedge clock)
begin
	if (rwe == 1) begin
		REGFILE[d] <= rd;
	end
end
 
endmodule