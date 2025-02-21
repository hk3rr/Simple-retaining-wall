clear;clc;

%This code is to optimise the trapezoid wall shape design

%Begin of values found in soil lab

%Ultimate values on following arrays were the ones gathered through analysis
%and may be changed, changing the rest of the data
rho = [ 1.52 , 1.57 , 1.6 , 1.55 , 1.57 , 1.41 ]';     %Values for Density
sigma = [ 41 , 79 , 119 , 159 , 197 , 120 ]';          %Values for normal stress
taoMax = [ 34 , 73 , 97 , 138 , 173 , 129 ]';          %Values for maximum shear stress
taoUlt = [ 25 , 53 , 73 , 96 , 123 , 98.5 ]';          %Values for ultimate shear stress

%End of values found in soil lab
%Begin of phi calculations

x=sigma;
y=taoMax;
c = x\y;              

phiPeak = atand (c/1);

x=sigma;
y=taoUlt;
c = x\y;     

phiCrit = atand (c/1);

%End of phi claculations
%Begin of soil property calculations

DSoil = prctile(rho,95);           %Soil density averaged to 95th percentile
UWSoil = DSoil * 9.81;             %Unit weight of soil
phiDesign = atand (tand (phiPeak) / 1.25);   

%End of soil property calculations
%Begin of basic wall values

%These values may be changed, changing the rest of the data
h = 6;             %Height of trapezoid wall
UWConc = 24;       %Unit weight of concrete used in wall
a = 0.5;           %Top edge of trapezoid wall

%End of basic wall values
%Begin of P and Ws calculations

alpha = [45 : 0.01 : 85];
Ws = 0.5 * UWSoil * (h^2) * cotd (alpha);   %Weight of soil
P = Ws .* tand (alpha - phiDesign);         %Force acting on wall
Pmax = max (P);                             %Maximum amount of force that may act on wall

%End of P and Ws calculations
%Begin of sliding check calculations

b = 0.001;
Ww = ( ((a + b) / 2) * h) * UWConc;
delta = atand (Pmax / Ww);

while delta > phiDesign
    b = b + 0.001;
    Ww = ( ((a + b) / 2) * h) * UWConc;
    delta = atand (Pmax / Ww);
end
b1 = b;

disp 'This is the minimum wall base width that will pass the sliding check'
disp (b1)

%End of sliding check calculations
%Begin of overturning check calculations

b2 = 0.01;
x1 =  ((2 .* b2^2) + (2 .* a .* b2) - (a^2)) ./ (3 .* (b2 + a)); 
x2 = x1 - (Pmax * h) ./ (Ww * 3); 

while x2 <= b2/3
    b2 = b2 + 0.001;
    x1 =  ((2 * b2^2) + (2 * a * b2) - a^2) / (3 * (b2 + a)) ; 
    x2 = x1 - (Pmax * h) ./ (Ww * 3); 
end

disp 'This is the minimum wall base width that will pass the overturning check'
disp(b2)



