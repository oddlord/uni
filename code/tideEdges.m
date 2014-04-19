% tideEdges
%
% Trains a Multylayer Perceptron to forecast the incoming tide
% observing tidal edges.
%
% Author: Tommaso Papini,
% Last modified: 20th March 2013, 16:42 CET.

%PARAMETERS
cycle = 28*24;  % tidal cycle duration (28 days) in hours
sample1 = 500;    % tidal heights observed for training
sample2 = 3;    % observations for each forecast
minTN = -0.4;   % minimum tide noise
maxTN = +0.4;   % maximum tide noise
hN = 5/60; % maximum (absolute) hour noise
terrain = 0.5;  % altitude of the ground (0 = sea level, 2 = maximum tidal edge)
errPerc = 5;    % desired error (in percentage)

%TRAINING DATA
P0 = randR(1, sample1, 0, cycle);
P1 = zeros(3, sample1);
for i=1:sample1
   x = findNextEdge(P0(i));
   while tide(x)<terrain, x=x+1; x=findNextEdge(x); end
   while tide(x)>terrain, x=x-hN; end
   P0(i)=x;
   P0(i) = findNextEdge(P0(i));
   P1(1, i) = P0(i) - x;
   P1(2, i) = tide(P0(i))+randR(1, 1, minTN, maxTN);
   x = P0(i);
   while tide(x)>terrain, x = x+hN; end
   P1(3, i) = x-P0(i);
   P0(i) = x;
end
P = [P1 ; zeros(4*(sample2-1), sample1)];
for i=2:sample2
    y=3+(i-2)*4;
    for j=1:sample1
        x = P0(j);
        while tide(x)<terrain, x = x+hN; end
        P(y+1, j) = x-P0(j);
        P0(j) = x;
        x = findNextEdge(x);
        P(y+2, j) = x-P0(j);
        P0(j) = x;
        P(y+3, j) = tide(P0(j))+randR(1, 1, minTN, maxTN);
        while tide(x)>terrain, x = x+hN; end
        P(y+4, j) = x-P0(j);
        P0(j) = x;
    end
end
T = zeros(4, sample1);
for i=1:sample1
    x = P0(i);
    while tide(x)<terrain, x = x+hN; end
    T(1, i) = x-P0(i);
    P0(i) = x;
    x = findNextEdge(x);
    T(2, i) = x-P0(i);
    P0(i) = x;
    T(3, i) = tide(P0(i))+randR(1, 1, minTN, maxTN);
    while tide(x)>terrain, x = x+hN; end
    T(4, i) = x-P0(i);
end

%TRAINING
net = newff(P, T, 2, {'logsig', 'purelin'}, 'trainlm');
net.trainParam.epochs = 200;
net.trainParam.goal = (errPerc*10.75)/100;
net = init(net);
net = train(net, P, T);

%TEST
start = input('Insert the starting point (-1 to terminate): ');
while start~=-1
    H = zeros(1, 3*sample2);    % hours observed
    E = zeros(1, sample2);  % edges observed
    H(1) = start;
    H(1) = findNextEdge(H(1));
    while tide(H(1))<terrain, H(1)=H(1)+1; H(1)=findNextEdge(H(1)); end
    while tide(H(1))>terrain, H(1)=H(1)-hN; end
    H(2)= findNextEdge(H(1));
    E(1)=tide(H(2))+randR(1, 1, minTN, maxTN);
    H(3) = H(2);
    while tide(H(3))>terrain, H(3)=H(3)+hN; end
    for i=2:sample2
        x = (i-1)*3;
        H(x+1) = H(x);
        while tide(H(x+1))<terrain, H(x+1)=H(x+1)+hN; end
        H(x+2) = findNextEdge(H(x+1));
        E(i)=tide(H(x+2))+randR(1, 1, minTN, maxTN);
        H(x+3) = H(x+2);
        while tide(H(x+3))>terrain, H(x+3)=H(x+3)+hN; end
    end
    hold off
    I = zeros(1, 3+(sample2-1)*4);  %input vector
    i = sample2;
    while i>1
        x = (i-1)*3;
        y=3+(i-2)*4;
        I(y+4)=H(x+3)-H(x+2);
        plot(H(x+3), terrain, 'bo')
        hold on
        I(y+3)=E(i);
        I(y+2)=H(x+2)-H(x+1);
        plot(H(x+2), E(i), 'bo')
        plot(H(x+2), E(i), 'bx')
        I(y+1)=H(x+1)-H(x);
        plot(H(x+1), terrain, 'bo')
        i=i-1;
    end
    I(3)=H(3)-H(2);
    plot(H(3), terrain, 'bo')
    I(2)=E(1);
    I(1)=H(2)-H(1);
    plot(H(2), E(1), 'bo')
    plot(H(2), E(1), 'bx')
    plot(H(1), terrain, 'bo')
    I = I';
    O = sim(net, I);    %output vector
    x = H(3*sample2) + O(1);
    plot(x, terrain, 'ro')
    x = x + O(2);
    plot(x, O(3), 'ro')
    plot(x, O(3), 'rx')
    x = x + O(4);
    plot(x, terrain, 'ro')
    graphicS = start -5;
    graphicE = x+5;
    fplot(@tide, [graphicS graphicE], 'b')
    fplot(@(x) terrain, [graphicS graphicE], 'black')
    axis ([graphicS graphicE -2 2]);
    pause
    start = input('Insert the starting point (-1 to terminate): ');
end