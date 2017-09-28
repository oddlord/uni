% aitken(f, f1, x0, imax, tolx, s, g, gs)
% Metodo di accelerazione di Aitken.
%
% Input:
%   -f: la funzione
%   -f1: la derivata della funzione;
%   -x0: l'approssimazione iniziale;
%   -imax: il numero massimo di iterazioni;
%   -tolx: la tolleranza desiderata;
%   -s: true per visualizzare ogni singolo step, false altrimenti;
%   -g: true per abilitare la parte grafica, false altrimenti;
%   -gs: true per vedere ogni step del grafico, false per vedere subito
%   il grafico finale.
%
% Autore: Tommaso Papini,
% Ultima modifica: 4 Novembre 2012, 11:04 CET

function [] = aitken(f, f1, x0, imax, tolx, s, g, gs)
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
        x1 = x0 - fx/f1x;
        if g
            plot([x0 x1], [fx 0], 'r');
            plot([x0 x0], [0 fx], 'black');
            if gs, pause, end
        end
        fx = feval(f, x1);
        f1x = feval(f1, x1);
        if f1x==0, vai=false; i=i-1; break, end
        x2 = x1 - fx/f1x;
        if g
            plot([x1 x2], [fx 0], 'r');
            plot([x1 x1], [0 fx], 'black');
            if gs, pause, end
        end
        if (x2-2*x1+x0)==0, vai=false; i=i-1; break, end
        x3 = (x2*x0-x1^2)/(x2-2*x1+x0);
        if s, str = sprintf('x%d =', i); disp(str), disp(x3), end
        if g
            fx = feval(f, x2);
            plot([x2 x3], [fx 0], 'g');
            plot([x2 x2], [0 fx], 'black');
            if gs, pause, end
        end
        vai = abs(x3-x0)>tolx;
        x0 = x3;
    end
    if vai, disp('NON CONVERGE entro la tolleranza ed il numero di passi richiesti')
    else str=sprintf('CONVERGE a %5.4f dopo %d passi', x3, i); disp(str), end
    if g, hold off, end
    tElapsed = toc(tStart); str=sprintf('Tempo medio/step: %5.4f ms; tempo totale %5.4f ms', tElapsed*1000/i, tElapsed*1000); disp(str)