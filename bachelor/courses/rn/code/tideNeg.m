% height = tideNeg(t)
%
% Calculates the negation of the tide function.
%
% Input:
%	-t: time, in hours.
% Output:
%	-height: the negation of the corresponding tidal height.
%
% Author: Tommaso Papini,
% Last modified: 20th March 2013, 17:11 CET.

function height = tideNeg(t)
    Aa = 1.06;
    Ab = 0.65;
    D = 0.15;
    Ta = 12.42;
    Tb = 12;
    Tm = 12.21;
    height = - (Aa*cos((2*pi*t)/Ta) + Ab*cos((2*pi*t)/Tb) - D*sin((pi*t)/Tm - pi/4));
end