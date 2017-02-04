// i) between	1	and	200	grams
// ii) between	201	and	500	grams
// iii) between	501	and	800	grams
// iv) between	801	and	1000	grams
// v) between	1001 and	2000	grams
// vi) greater	than	2000

// Also	assume that reset does NOT affect the value	of currentGrp[2:0]

// currentGrp will be purely combinational

//  Grp1-Grp6	will	be	sequential (Falling Edge)

// 1. Ensure that the	count is only updated once for a given input weight
// 2. Only the	first weight after value '0' updates a group	count

module
PACKAGESORTER(clk, weight, reset, Grp1, Grp2, Grp3, Grp4, Grp5, Grp6, currentGrp);

input clk, reset;
input [11:0] weight;

output reg [7:0] Grp1, Grp2, Grp3, Grp4, Grp5, Grp6;
// reg	[7:0] Grp1, Grp2, Grp3, Grp4, Grp5, Grp6;
reg flag;

// Outputs integer 1-6
output reg [2:0] currentGrp;
// reg [2:0] currentGrp;

// currentGrp is	initially	3’b000. 
initial
begin
	currentGrp = 3'b000;
	flag = 1'b1;
	Grp1 <= 8'b00000000;
	Grp2 <= 8'b00000000;
	Grp3 <= 8'b00000000;
	Grp4 <= 8'b00000000;
	Grp5 <= 8'b00000000;
	Grp6 <= 8'b00000000;
end

always@(posedge reset)
begin
	Grp1 <= 8'b00000000;
	Grp2 <= 8'b00000000;
	Grp3 <= 8'b00000000;
	Grp4 <= 8'b00000000;
	Grp5 <= 8'b00000000;
	Grp6 <= 8'b00000000;
end 

always@(weight)
begin
	if(weight == 12'd0)
		begin 
			currentGrp <= 3'd0;
		end 
	else if((weight >= 12'd1) && (weight <= 12'd200))
		begin
			currentGrp <= 3'd1;
		end 
	else if((weight >= 12'd201) && (weight <= 12'd500))
		begin
			currentGrp <= 3'd2;
		end 
	else if((weight >= 12'd501) && (weight <= 12'd800))
		begin
			currentGrp <= 3'd3;
		end 
	else if((weight >= 12'd801) && (weight <= 12'd1000))
		begin
			currentGrp <= 3'd4;
		end 
	else if((weight >= 12'd1001) && (weight <= 12'd2000))
		begin
			currentGrp <= 3'd5;
		end 
	else if(weight > 12'd2000)
		begin
			currentGrp <= 3'd6;
		end 
end

always@(negedge clk)
begin 
	if(weight == 12'd0)
		begin 
			flag <= 1'b1;
		end 
	else if((weight >= 12'd1) && (weight <= 12'd200))
		begin
			if (flag == 1'b1)
			begin
				Grp1 <= Grp1 + 1;
				flag <= 1'b0;
			end 
		end 
	else if((weight >= 12'd201) && (weight <= 12'd500))
		begin
			if (flag == 1'b1)
			begin
				Grp2 <= Grp2 + 1;
				flag <= 1'b0;
			end 
		end 
	else if((weight >= 12'd501) && (weight <= 12'd800))
		begin
			if (flag == 1'b1)
			begin
				Grp3 <= Grp3 + 1;
				flag <= 1'b0;
			end 
		end 
	else if((weight >= 12'd801) && (weight <= 12'd1000))
		begin
			if (flag == 1'b1)
			begin
				Grp4 <= Grp4 + 1;
				flag <= 1'b0;
			end 
		end 
	else if((weight >= 12'd1001) && (weight <= 12'd2000))
		begin
			if (flag == 1'b1)
			begin
				Grp5 <= Grp5 + 1;
				flag <= 1'b0;
			end 
		end 
	else if(weight > 12'd2000)
		begin
			if (flag == 1'b1)
			begin
				Grp6 <= Grp6 + 1;
				flag <= 1'b0;
			end 
		end 
end  

endmodule











