
module PACKAGESORTERTB();

reg clk, reset;
reg [11:0] weight;
reg [11:0] weightarr [1:12];

wire [7:0] Grp1, Grp2, Grp3, Grp4, Grp5, Grp6;
wire [2:0] currentGrp;
integer n;
// 	reset	->	250	->	0	->	300	->	0	->	501	->	1013

initial
begin
	weightarr[1] = 	100;
	weightarr[2] =	0;
	weightarr[3] =	250;
	weightarr[4] =	0;
	weightarr[5] = 	550;
	weightarr[6] =	0;
	weightarr[7] =	801;
	weightarr[8] =	0;
	weightarr[9] =	1001;
	weightarr[10] =	0;
	weightarr[11] =	2001;
	weightarr[12] =	0;
	weightarr[13] = 150;
	weightarr[14] = 300;
	
	clk=0;
	
	#5 reset = 0;
	
	n = 1;
	
	#90 weight = weightarr[n];
	n = n + 1;
	
	while(n < 14)
	begin
		#100 weight = weightarr[n];
		n = n + 1;
	end
	
	#1000 $stop;
end 

always #50 clk=~clk;

PACKAGESORTER pstr(clk, weight, reset, Grp1, Grp2, Grp3, Grp4, Grp5, Grp6, currentGrp);

endmodule