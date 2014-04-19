% test_adapt(net, samples, tN, hN, terrain)
%
% Test script for the adapting model: draws observation and prevision
% starting from points selected by the user.
%
% Input:
%   -net: the neural network to be tested;
%   -samples: observations for each forecast;
%   -tN: maximum (absolute) tidal noise;
%   -hN: maximum (absolute) hour noise;
%   -terrain: ground level.
%
% Author: Tommaso Papini,
% Last modified: 28th December 2012, 11:13 CET.

function [] = test_adapt(net, samples, tN, hN, terrain)

    start = input('Insert the starting point (-1 to terminate): ');
    while start~=-1
        [I, ~] = trainDataEdges(1, samples, tN, hN, terrain, start, start, true, true);
        x = I(1);
        i=0;
        figure(1);
        hold off;
        for i=1:samples
            y=(i-1)*3+1;
            x = x + I(y +1);
            plot(x, terrain, 'bo');
            hold on;
            x = x + I(y +2);
            plot(x, I(y +3)+terrain, 'bo');
            plot(x, I(y +3)+terrain, 'bx');
        end
        O = net(I);
        x = x + O(1);
        plot(x, terrain, 'ro');
        x = x + O(2);
        plot(x, O(3)+terrain, 'ro');
        plot(x, O(3)+terrain, 'rx');
        x = x + O(4);
        plot(x, terrain, 'ro');

        graphicS = start -5;
        graphicE = x+5;
        fplot(@tide, [graphicS graphicE], 'b')
        fplot(@(x) terrain, [graphicS graphicE], 'black')
        axis ([graphicS graphicE -2 2]);
        
        pause
        start = input('Insert the starting point (-1 to terminate): ');
    end
    
end

