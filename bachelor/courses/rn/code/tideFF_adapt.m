% tideFF_adapt
%
% Neural Network model for the Cerithidea Decollata snail adapting to
% new altitudes.
%
% Author: Tommaso Papini,
% Last modified: 28th December 2012, 11:14 CET.

%PARAMETERS
samples = 3;    % observations for each forecast
dataPerDay = 4; % sets of observations for each day
tN = 0.0;   % maximum (absolute) tidal noise
hN = 5/60; % maximum (absolute) hour noise
errPerc = 5;    % desider error in percentage
cycle = 28*24;  % tidal cycle (28 days) in hours
memoryLength = 28;  % memory length
n = 8;  % neurons
lunar = true;   % lunar clock usage
maxDays = 100;
validationDays = 27;
terrainOld = 1.5;
terrainNew = 0.5;

%TRAINING DATA
err = (errPerc*mean([13, 13, 4]))/100;
[Pold, Told] = trainDataEdges(500, samples, tN, hN, terrainOld, 0, cycle, true, lunar);

% FEED-FORWARD NET
net = newff(Pold, Told, n, {'logsig', 'purelin'}, 'trainlm');
net.trainParam.epochs = 500;
net.trainParam.goal = err;
net = init(net);
net = train(net, Pold, Told);

[Pmem, Tmem] = memoryInit(dataPerDay, samples, tN, hN, terrainOld, cycle, memoryLength, lunar);

test_adapt(net, samples, tN, hN, terrainOld);

%---------------------------------------------------------------------

i=0;
net.trainParam.showWindow = false;
[Pnew, Tnew] = trainDataEdges(dataPerDay*28, samples, tN, hN, terrainNew, 0, cycle, true, lunar);
score = getScore(net, validationDays, Pnew, Tnew, i);
figure;
while score>err && i<=maxDays
    [P, T] = trainDataEdges(dataPerDay, samples, tN, hN, terrainNew, 24*i, 24*(i+1), false, lunar);
    [Pmem, Tmem] = memoryUpdate(dataPerDay, memoryLength, Pmem, Tmem, P, T);
    net = train(net, Pmem, Tmem);
    score = getScore(net, validationDays, Pnew, Tnew, i);
    scoreOld = getScore(net, validationDays, Pold, Told, i);
    i=i+1;
    str=sprintf('\nDay %d:\n\tgoal: %5.4f\n\tmse new (%d days): %5.12f\n\tmse old (%d days): %5.12f\n', i, err, validationDays, score, validationDays, scoreOld); disp(str);
end
if score<=err
    if i==1, str=sprintf('\nThe network adapted to the new altituded in %d day with an error on the prediction of less than %d%%', i, errPerc);
    else str=sprintf('\nThe network adapted to the new altituded in %d days with an error on the prediction of less than %d%%', i, errPerc); end
else
    str=sprintf('\nThe network couldn''t adapt to the new altitude in %d days with an error on the prediction of less than %d%%', maxDays, errPerc);
end
disp(str);

net = train(net, Pnew, Tnew);
test_adapt(net, samples, tN, hN, terrainNew);
