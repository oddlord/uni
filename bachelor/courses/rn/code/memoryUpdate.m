% [Pmem, Tmem] = memoryUpdate(dataPerDay, memoryLength, Pmem, Tmem, P, T)
%
% Updates the snail's memory with the information of the last training
% day.
%
% Input:
%   -dataPerDay: number of training data (observations & forecast) per
%   day;
%   -memoryLength: memory length (in days);
%   -Pmem: input vector stored in memory;
%   -Tmem: target vector stored in memory;
%   -P: input vector of the last training day;
%   -T: target vector of the last training day.
% Output:
%   -Pmem: updated input vector;
%   -Tmem: updated target vector.
%
% Author: Tommaso Papini,
% Last modified: 28th December 2012, 11:09 CET.

function [Pmem, Tmem] = memoryUpdate(dataPerDay, memoryLength, Pmem, Tmem, P, T)
    Pmem = [Pmem(:, dataPerDay+1:dataPerDay*memoryLength), P];
    Tmem = [Tmem(:, dataPerDay+1:dataPerDay*memoryLength), T];
end