
module trafficLight(clk, rst, lightA, lightB, pedestrian);

output [2:0]	lightA, lightB;
output [1:0]	pedestrian;
reg [2:0] lightA, lightB;
reg [1:0] pedestrian;
input clk, rst;

// Holds state value (1-6)
reg [3:0] state;

parameter [3:0] S1	=	4'b0000;
parameter [3:0] S2	=	4'b0001;
parameter [3:0] S3	=	4'b0010;
parameter [3:0] S4	=	4'b0011;
parameter [3:0] S5	=	4'b0100;
parameter [3:0] S6	=	4'b0101;

// Maintenance
parameter [3:0] S7	= 	4'b0110;
parameter [3:0] S8	= 	4'b0111;

// S6 Flash 
parameter [3:0] S9	= 	4'b1000;

// Track which state we are on.
/*
	0-4s: 	1 
	4-6s: 	2 
	6-9s: 	3 
	9-10s: 	4 
	10-12s:	5 
	12-16s:	6 
	
	4'b0000 = FLOOR
	4'b1000 = CEILING
*/
reg [3:0] count;
reg flag;

initial
begin 
	count <= 4'b0000;
	state <= 4'b0000;
	flag <= 1'b0;
end 

always @(negedge clk, posedge clk, posedge rst, negedge rst)
begin
	if (rst)
		begin
		flag <= 1'b1;
		/* Keep flashing until rst is low */
		if (clk == 1'd1)
			begin
			state <= 4'b0110;
			end 
		
		else if (clk == 1'd0)
			begin
			state <= 4'b0111;
			end 
		end
	else if (rst == 1'd0 && flag == 1'b1)
		begin 
			state <= 4'b0000;
			count <= 4'b0000;
			flag <= 1'b0;
		end 
	else
	
	begin
	// Posedge clk 
	if(clk == 1'd1)
		begin 
		case (state)
			S1 :
			begin
				if (count == 4'd4)
				begin
					count <= count + 4'b0001;
					state <= 4'b0001;
				end
				else
				begin
					count <= count + 4'b0001;
					state <= state;
				end
			end

			S2 :
			begin
				if (count == 4'd6)
				begin
					count <= count + 4'b0001;
					state <= 4'b0010;
				end
				else
				begin
					count <= count + 4'b0001;
					state <= state;
				end
			end
			
			S3 :
			begin
				if (count == 4'd9)
				begin
					count <= count + 4'b0001;
					state <= 4'b0011;
				end
				else
				begin
					count <= count + 4'b0001;
					state <= state;
				end
			end

			S4 :
			begin
				if (count == 4'd10)
				begin
					count <= count + 4'b0001;
					state <= 4'b0100;
				end
				else
				begin
					count <= count + 4'b0001;
					state <= state;
				end
			end

			S5 :
			begin
				if (count == 4'd12)
				begin
					count <= count + 4'b0001;
					state <= 4'b0101;
				end
				else
				begin
					count <= count + 4'b0001;
					state <= state;
				end
			end

			S6 :
			begin
				if (count == 4'd16)
				begin
					count <= 4'b0000;
					state <= 4'b0000;
				end
				else
				begin
					count <= count + 4'b0001;
					state <= 4'b1000;
				end
			end
			
			S7 :
			begin
			end 
			
			S8 :
			begin
			end
			
			S9 :
			begin
				if (count == 4'd16)
				begin
					count <= 4'b0000;
					state <= 4'b0000;
				end
				else
				begin
					state <= 4'b0101;
					count <= count + 4'b0001;
				end
			end
			
		endcase
		end 
		
	   // Flash state 6
        else if(clk == 1'd0)
            begin 
            if (state == 4'b0101)
                begin
                    count <= count;
                    state <= 4'b1000;
                end 
           else if (state == 4'b1000)
                begin
                    count <= count;
                    state <= 4'b0101;
                end 
            end 
	end 
end 

/*
States		Traffic A		Traffic B		Pedestrian
	
1)	4s:		Green			Red				Red
2)	2s:		Yellow			Red 			Red 
3)	3s:		Red 			Green 			Red 
4)	1s:		Red 			Yellow 			Red 
5) 	2s:		Red 			Red 			Green 
6) 	4s:		Red 			Red 			Red (Flashing @ 1Hz)
*/

always @(state)
	begin
	case (state)
		S1 :
		begin
			lightA <= 3'b001;
			lightB <= 3'b100;
			pedestrian <= 2'b10;
		end 	

		S2 :
		begin
			lightA <= 3'b010;
			lightB <= 3'b100;
			pedestrian <= 2'b10;
		end 
		
		S3 :
		begin
			lightA <= 3'b100;
			lightB <= 3'b001;
			pedestrian <= 2'b10;
		end 

		S4 :
		begin
			lightA <= 3'b100;
			lightB <= 3'b010;
			pedestrian <= 2'b10;
		end 

		S5 :
		begin
			lightA <= 3'b100;
			lightB <= 3'b100;
			pedestrian <= 2'b01;
		end 

		S6 :
		begin
			lightA <= 3'b100;
			lightB <= 3'b100;
			pedestrian <= 2'b10;
		end 
		
		S7 :
		begin
			lightA <= 3'b100;
			lightB <= 3'b100;
			pedestrian <= 2'b10;
		end 

		S8 :
		begin
			lightA <= 3'b000;
			lightB <= 3'b000;
			pedestrian <= 2'b00;
		end 
		
		S9 :
		begin 
			lightA <= 3'b100;
			lightB <= 3'b100;
			pedestrian <= 2'b00;
		end 
		
	endcase 	
	end 	
endmodule

/* Ensures one second per clock cycle */
module complexDivider(clk100Mhz, slowClk);
  input clk100Mhz; //fast clock
  output reg slowClk; //slow clock

  reg[27:0] counter;

  initial begin
    counter = 0;
    slowClk = 0;
  end

  always @ (posedge clk100Mhz)
  begin
    if(counter == 50000000) begin
      counter <= 1;
      slowClk <= ~slowClk;
    end
    else begin
      counter <= counter + 1;
    end
  end
endmodule

module TOP(clk, rst, lightA, lightB, pedestrian);
output [2:0] lightA, lightB;
output [1:0] pedestrian;

input clk, rst;
wire clk2;

complexDivider delay(clk,clk2);
trafficLight tlight(clk2, rst, lightA, lightB, pedestrian);

endmodule