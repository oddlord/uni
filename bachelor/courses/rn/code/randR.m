% random = randR(M, N, A, B)
%
% Creates a matrix of random values in a given range.
%
% Input:
%	-M: matrix rows;
%	-N: matrix columns;
%	-A: lower limit;
%	-B: upper limit.
% Output:
%	-random: final random matrix.
%
% Author: Tommaso Papini,
% Last modified: 20th March 2013, 17:08 CET.

function random = randR(M, N, A, B)
    random = rand(M, N)*(B-A) +A;
end