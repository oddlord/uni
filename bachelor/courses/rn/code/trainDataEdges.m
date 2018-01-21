% [P, T] = trainDataEdges(sample1, sample2, minTN, maxTN, hN, terrain)
%
% Produces training data for the network that observes the arrival of
% tides and tidal edges.
%
% Input:
%   -sample1: tidal heights observed for training;
%   -sample2: observations for each forecast;
%   -tN: maximum (absolute) tidal noise;
%   -hN: maximum (absolute) hour noise;
%   -terrain: ground level (0 = sea level, 2 = maximum tidal edge);
%   -tStart: starting time for observations;
%   -tEnd: ending time for observations.
% Output:
%   -P: input matrix: each column represent an input vector;
%   -T: target matrix: each column represent a target vector.
%
% Author: Tommaso Papini,
% Last modified: 28th December 2012, 11:15 CET.

function [P, T] = trainDataEdges(sample1, sample2, tN, hN, terrain, tStart, tEnd, lin, lunar)

    if lin, P0 = linspace(tStart, tEnd, sample1);
    else P0 = sort(randR(1, sample1, tStart, tEnd)); end
    if lunar, P = zeros(1+3*sample2, sample1);
    else P = zeros(3*sample2, sample1); end
    for j=1:sample1
        while tide(P0(j))>terrain, P0(j)=P0(j)+hN; end
        if lunar, P(1, j)=mod(P0(j), 28*24); end
        for i=1:sample2
            if lunar, y=(i-1)*3+1;
            else y=(i-1)*3+1; end
            x = P0(j);
            while tide(x)>terrain, x=x+hN; end
            while tide(x)<=terrain, x = x+hN; end
            P(y+1, j) = x-P0(j);
            P0(j) = x;
            x = findNextEdge(x);
            P(y+2, j) = x-P0(j);
            P0(j) = x;
            P(y+3, j) = tide(P0(j))+randR(1, 1, -tN, tN)-terrain;
        end
    end
    T = zeros(4, sample1);
    for i=1:sample1
        x = P0(i);
        while tide(x)>terrain, x=x+hN; end
        while tide(x)<=terrain, x = x+hN; end
        T(1, i) = x-P0(i);
        P0(i) = x;
        x = findNextEdge(x);
        T(2, i) = x-P0(i);
        P0(i) = x;
        T(3, i) = tide(P0(i))-terrain;
        while tide(x)>terrain, x = x+hN; end
        T(4, i) = x-P0(i);
    end

end

