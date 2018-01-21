% Simulazioni e approssimazioni della rete neurale della Cerithidea
% Decollata per la previsione delle alte maree utilizzando gli
% Algoritmi Genetici per la minimizzazione dello scarto quadratico
% medio.
%
% Autore: Tommaso Papini,
% Ultima modifica:

%PARAMETRI
samples = 3;    % numero di picchi osservati per ogni previsione
dataPerDay = 4;
tN = 0.4;   % rumore massimo assoluto di marea (tN = tide noise)
hN = 5/60; % rumore massimo assoluto sull'orario in minuti
errPerc = 10;    % errore desiderato in percentuale
tol = 1e-8;
cycle = 28*24;  % durata del ciclo di marea (28 giorni) in ore
shortMemoryLength = 7;  % in giorni
p = 5/100;  % probabilità di inserire un'osservazione nella memoria a lungo termine
pDel = 80/100;   % probabilità di eliminare un'osservazione dalla memoria a lungo termine
n = 2;  % numero di neuroni

%DATI DI ADDESTRAMENTO
terrain = 1.5;
[P, T] = trainDataEdges(500, samples, tN, hN, terrain, 0, cycle);

% RETE Feed-Forward
net = feedforwardnet(n);
net = configure(net, P, T);

% HANDLER dello scarto quadratico medio
h = @(x) mseFF(x, net, P, T);

% ALGORITMO GENETICO
ga_opts = gaoptimset('TolFun', tol, 'Generations', 100, 'display', 'iter', 'PlotFcns', @gaplotrange);
[~, ~, ~, ~, POPULATION] = ga(h, net.numWeightElements, ga_opts);

[Pshort, Tshort, Plong, Tlong] = memoryInit(dataPerDay, samples, tN, hN, terrain, cycle, shortMemoryLength, P, T, p);

test_adapt(net, samples, tN, hN, terrain);

%---------------------------------------------------------------------

terrain = 1.4;
score=inf;
i=0;
while score>=errPerc/100
    disp('Premere un tasto per continuare');
    pause
    [P, T] = trainDataEdges(dataPerDay, samples, tN, hN, terrain, 24*i, 24*(i+1));
    [Pshort, Tshort, Plong, Tlong] = memoryUpdate(dataPerDay, shortMemoryLength, Pshort, Tshort, Plong, Tlong, P, T, p, pDel);
    h = @(x) mseFF(x, net, [Pshort], [Tshort]);
    ga_opts = gaoptimset('TolFun', tol, 'Generations', 5, 'display', 'iter', 'InitialPop', POPULATION);
    [~, ~, ~, ~, POPULATION] = ga(h, net.numWeightElements, ga_opts);
    score = populationMSE(POPULATION, net, P, T);
    i=i+1;
    str=sprintf('\nGiorno %d:\n\tscore: %5.12f\n\tgoal: %5.4f\n', i, score, errPerc/100); disp(str);
end
if i==1, str=sprintf('\nGli esemplari si sono adattati alla nuova altitudine in %d giorno con un errore inferiore al %d%%', i, errPerc);
else str=sprintf('\nGli esemplari si sono adattati alla nuova altitudine in %d giorni con un errore inferiore al %d%%', i, errPerc); end
disp(str);
