% x_max = findNextEdge(x)
%
% Finds the next tide edge, between the passed time (x) and the next 13 hours.
%
% Input:
%	-x: present time (in hours).
% Output:
%	-x_max: hour of the next tide edge.
%
% Author: Tommaso Papini,
% Last modified: 20th March 2013, 16:50 CET.
function x_max = findNextEdge(x)
   x_max = fminbnd(@tideNeg, x, x+13);
end