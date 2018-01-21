% tideFFEdge
%
% Prediction of the next tidal edge using a Multilayer Perceptron.
%
% Author: Tommaso Papini,
% Last modified: 20th March 2013, 17:04 CET.

%PARAMETERS
cycle = 28*24;  % tidal cycle duration (28 days) in hours
int = 1;    % tide observation intervals in hours
sample1 = 10000;    % tidal heights observed for training
sample2 = 5;    % observations for each forecast
minTN = -0.6;   % minimum tide noise
maxTN = +0.6;   % maximum tide noise
minHN = -10/60; % minimum hour noise
maxHN = +10/60; % maximum hour noise

%TRAINING DATA
P0 = ones(sample2, 1)*randR(1, sample1, 0, cycle) + (1 : sample2)'*ones(1, sample1)*int + randR(sample2, sample1, minHN, maxHN);
P = tide(P0) + ones(sample2, 1)*randR(1, sample1, minTN, maxTN);
T1 = zeros(1, sample1);
i = 1;
while i<=sample1
   T1(i) = findNextEdge(P0(sample2, i));
   i = i+1;
end
T2 = tide(T1);
T1 = T1 - P0(sample2, :);
T = [T1; T2];

%TRAINING
net = newff(P, T, 6, {'logsig', 'purelin'}, 'trainlm');
net.trainParam.epochs = 200;
net.trainParam.goal = 0.0001;
net = init(net);
net = train(net, P, T);

%TEST
start = input('Insert the starting point (-1 to terminate): ');
while start~=-1
    h = start + (1 : sample2)'*int + randR(sample2, 1, minHN, maxHN);
    t = tide(h) + ones(sample2, 1)*randR(1, 1, minTN, maxTN);
    eX = findNextEdge(h(sample2, 1));
    eY = tide(eX);
    p = sim(net, t);
    p1 = p(1, 1)+h(sample2, 1);
    p2 = p(2, 1);
    graphicS = start -5;
    graphicE = max(eX, p1) +10;
    hold off
    fplot(@tide, [graphicS graphicE], 'b')
    hold on
    axis ([graphicS graphicE -2 2]);
    plot(h', t', 'bo')
    plot(eX, eY, 'ro')
    plot(p1, p2, 'r+')
    legend({'tide', 'observed', 'expected', 'predicted'})
    pause
    start = input('Insert the starting point (-1 to terminate): ');
end