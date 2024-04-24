`timescale 1ns / 1ps
module floating_point_addition_tb;
reg [31:0] A,B;
wire [31:0] result;
floating_point_addition A1 (.fnum1(A),.fnum2(B),.fout(result));

/////////////////Function to convert 32 bits ieee format to shortreal////////////  
function real bits_to_shortreal;
input [31:0] ieee_input;  
  
reg [23:0] mantissa;
reg [7:0] exponent;
reg sign;

real fraction;
real temp;
int exponent_real;
real real_output;

sign = ieee_input[31];
exponent = ieee_input[30:23];
mantissa = {1'b1, ieee_input[22:0]};

exponent_real = exponent - 127;
fraction = 1.0;
for (integer i = 22; i >= 0; i = i - 1)
begin
temp=1.0 / (2**( 23-i));
fraction =  fraction+ (mantissa[i] * temp);
end

if (exponent_real >= 0) begin
real_output = fraction * (2 ** exponent_real);
end
else begin
real_output = fraction* (1.0/ (2 ** (- exponent_real)));
end

if (sign) begin
real_output = -real_output;
end

return real_output;
endfunction
////////////////////////////////////////////////////////
   
initial  
begin
A = 32'b0_10000000_10011001100110011001100;  // 3.2
B = 32'b0_10000001_00001100110011001100110;  // 4.2
#20
A = 32'b0_01111110_01010001111010111000010;  // 0.66
B = 32'b0_01111110_00000101000111101011100;  // 0.51
#20
A = 32'b1_01111110_00000000000000000000000;  // -0.5
B = 32'b1_10000001_10011001100110011001100;  // -6.4
#20
A = 32'b1_01111110_00000000000000000000000;  // -0.5
B = 32'b0_10000001_10011001100110011001100;  //  6.4
#20
A = 32'h4034b4b5;
B = 32'hbf70f0f1;
end

initial
begin

#5
$display("fnum1=%0f, fnum2=%0f, Expected Value : %0f Result : %0f", $bitstoshortreal(A), 4.2, 3.2+4.2, $bitstoshortreal(result));
#20
$display("fnum1=%0f, fnum2=%0f, Expected Value : %f Result : %f", 0.66, 0.51, 0.66+0.51, bits_to_shortreal(result));
#20
$display("fnum1=%0f, fnum2=%0f, Expected Value : %f Result : %f", -0.5, -6.4, -0.5-6.4, bits_to_shortreal(result));
#20
$display("fnum1=%0f, fnum2=%0f, Expected Value : %f Result : %f", -0.5, 6.4, -0.5+6.4, bits_to_shortreal(result));
#20
$display("fnum1=%0f, fnum2=%0f, Expected Value : %f Result : %f", 2.82, -0.94, 2.82-0.94, bits_to_shortreal(result));
end

initial
begin
#500
$finish;
end
endmodule
