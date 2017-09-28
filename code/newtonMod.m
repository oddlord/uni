% newtonMod(f, f1, x0, m, imax, tolx, s, g, gs)
% Metodo di Newton modificato.
%
% Input:
%   -f: la funzione;
%   -f1: la derivata della funzione;
%   -x0: l'approssimazione iniziale;
%   -m: la molteplicità della radice;
%   -imax: il numero massimo di iterazioni;
%   -tolx: la tolleranza desiderata;
%   -s: true per visualizzare ogni singolo step, false altrimenti;
%   -g: true per abilitare la parte grafica, false altrimenti;
%   -gs: true per vedere ogni step del grafico, false per vedere subito
%   il grafico finale.
%
% Autore: Tommaso Papini,
% Ultima modifica: 4 Novembre 2012, 11:18 CET

function [] = newtonMod(f, f1, x0, m, imax, tolx, s, g, gs)
    tStart = tic;
    format long e
    if g
        hax=axes; hold on
        fplot(f, [x0-5, x0+5], 'b');
        fplot(@(x) 0, get(hax, 'XLim'), 'black');
        if gs, pause, end
    end
    if s, disp('x0 ='), disp(x0), end
    i = 0;
    vai = true;
    while ( i<imax ) && vai
        i = i+1;
        fx = feval(f, x0);
        f1x = feval(f1, x0);
        if f1x==0, vai=false; i=i-1; break, end
        x1 = x0 - m*(fx/f1x);
        if s, str = sprintf('x%d =', i); disp(str), disp(x1), end
        if g
            plot([x0 x1], [fx 0], 'r');
            plot([x0 x0], [0 fx], 'black');
            if gs, pause, end
        end
        vai = abs(x1-x0)>tolx;
        x0 = x1;
    end
    if vai, disp('NON CONVERGE entro la tolleranza ed il numero di passi richiesti')
    else str=sprintf('CONVERGE a %5.4f dopo %d passi', x1, i); disp(str), end
    if g, hold off, end
    tElapsed = toc(tStart); str=sprintf('Tempo medio/step: %5.4f ms; tempo totale %5.4f ms', tElapsed*1000/i, tElapsed*1000); disp(str)