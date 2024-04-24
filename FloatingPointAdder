`timescale 1ns/1ps
module floating_point_addition(fnum1,fnum2,fout);
input [31:0] fnum1;
input [31:0] fnum2;
output [31:0] fout;

reg comp;// to compare both the input and find the larger one
reg S1,S2;
reg[7:0] E1,E2;
reg[22:0] M1,M2;
reg [23:0] N1,N2;
reg [7:0]E_Difference;

reg S_out;
reg [7:0] E_out;
reg [22:0] M_out;

reg [24:0]Sum; //the result of {1,M1} and {1,M2} will be a 25 bit value
reg [22:0] temp;
integer i =0;  // to use in always block.

always@(*)
begin
comp =  (fnum1[30:23] >= fnum2[30:23])? 1'b1 : 1'b0;
 
S1 = comp ? fnum1[31] : fnum2[31];
E1 = comp ? fnum1[30:23] : fnum2[30:23];
M1 = comp ? {fnum1[22:0]} : {fnum2[22:0]};

S2 = comp ? fnum2[31] : fnum1[31];
E2 = comp ? fnum2[30:23] : fnum1[30:23];
M2 = comp ? {fnum2[22:0]} : {fnum1[22:0]};


N1={1'b1, M1};
N2={1'b1, M2};
E_Difference = E1 - E2; //E1 has larger exponent vale as A is larger 

N2 = N2 >> E_Difference;

Sum =  (S1 ~^ S2)? N1 + N2 : N1 - N2 ; //for fast implementation, use carry lock ahead adder which is also known as recursive doubling adder.
//for difference 	use Difference= (S1 ^ S2)? N1 + N2 : N1 - N2 ;
if(Sum[24]==1)
	begin
	M_out = Sum[23:1];
	E_out = E1 + 1'b1;
	end

	else if(Sum[23]==0)
	begin
	i = 1;
		while(Sum[23-i] == 1'b0)
		begin
		i = i+1;
		end 
	E_out = E1 - i;
	temp = Sum[22:0];
	M_out = temp<<i;
	end
	
	else
	begin
	M_out = Sum[22:0];
	E_out = E1;
	end

S_out=S1;
end

assign fout = {S_out,E_out,M_out};//sign of result will be same as the sign of the larger number.
endmodule
