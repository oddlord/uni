% tideLin
%
% Function used for simple forecasting and the forecast with errors.
%
% Author: Tommaso Papini,
% Last modified: 20th March 2013, 17:12 CET.

%PARAMETERS
cycle = 28*24;  % tidal cycle duration (28 days) in hours
int = 0.5;    % tide observation intervals in hours
forecast = 2;   % hours away from the prediction
sample1 = 20000;    % tidal heights observed for training
sample2 = 5;    % observations for each forecast
minTN = -0.6;   % minimum tide noise
maxTN = +0.6;   % maximum tide noise
minHN = -5/60; % minimum hour noise
maxHN = +5/60; % maximum hour noise

%TRAINING DATA
P0 = ones(sample2, 1)*randR(1, sample1, 0, cycle) + (1 : sample2)'*ones(1, sample1)*int + randR(sample2, sample1, minHN, maxHN);
P = tide(P0) + ones(sample2, 1)*randR(1, sample1, minTN, maxTN);
T = tide(P0(sample2, :) + forecast) + randR(1, sample1, minTN, maxTN);

%TRAINING
net = newlin(P, T, 0, 0.01);
net.trainFcn = 'trainlm';
net.trainParam.epochs = 200;
net.trainParam.goal = 0.04;
net = init(net);
net = train(net, P, T);

%TEST
start = input('Insert the starting point (-1 to terminate): ');
while start~=-1
    graphicS = start-sample2*int-1;
    graphicE = start+2*sample2*int+forecast+1;
    h = start + (1 : sample2)'*int + randR(sample2, 1, minHN, maxHN);
    start = start + int*sample2 + forecast;
    t = tide(h) + ones(sample2, 1)*randR(1, 1, minTN, maxTN);
    e = tide(start);
    p = sim(net, t);
    hold off
    fplot(@tide, [graphicS graphicE], 'b')
    hold on
    axis ([graphicS graphicE -2 2]);
    plot(h', t', 'bo')
    plot(start, e, 'ro')
    plot(start, p, 'r+')
    legend({'tide', 'observed', 'expected', 'predicted'})
    pause
    start = input('Insert the starting point (-1 to terminate): ');
end