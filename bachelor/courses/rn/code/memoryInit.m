% [Pmem, Tmem] = memoryInit(dataPerDay, samples, tN, hN, terrain, cycle, memoryLength, lunar)
%
% Initializes the snail's memory after the training at the first
% altitude.
%
% Input:
%   -dataPerDay: number of training data (observations & forecast) per
%   day;
%   -samples: observations for each forecast;
%   -tN: maximum (absolute) tidal noise;
%   -hN: maximum (absolute) hour noise;
%   -terrain: ground level;
%   -cycle: tidal cycle in hours;
%   -memoryLength: memory length (in days);
%   -lunar: true if the lunar clock has to be used, false otherwise.
% Output:
%   -Pmem: input vector to be stored in memory;
%   -Tmem: target vector to be stored in memory.
%
% Author: Tommaso Papini,
% Last modified: 28th December 2012, 11:06 CET.

function [Pmem, Tmem] = memoryInit(dataPerDay, samples, tN, hN, terrain, cycle, memoryLength, lunar)
    [Pmem, Tmem] = trainDataEdges(dataPerDay*memoryLength, samples, tN, hN, terrain, cycle-memoryLength*24, cycle, true, lunar);
end