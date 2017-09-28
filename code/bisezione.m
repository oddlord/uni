% bisezione(f, a, b, tolx, s, g, gs)
% Metodo di bisezione.
%
% Input:
%   -f: la funzione;
%   -a: estremo sinistro dell'intervallo di confidenza;
%   -b: estremo destro dell'intervallo di confidenza;
%   -tolx: la tolleranza desiderata;
%   -s: true per visualizzare ogni singolo step, false altrimenti;
%   -g: true per abilitare la parte grafica, false altrimenti;
%   -gs: true per vedere ogni step del grafico, false per vedere subito
%   il grafico finale.
%
% Autore: Tommaso Papini,
% Ultima modifica: 4 Novembre 2012, 11:04 CET

function [] = bisezione(f, a, b, tolx, s, g, gs)
    tStart = tic;
    if g
        hax=axes; hold on
        fplot(f, [a-0.5, b+0.5], 'b');
        fplot(@(x) 0, get(hax, 'XLim'), 'black');
        line([a a], get(hax, 'YLim'), 'Color', [0 0 0])
        line([b b], get(hax, 'YLim'), 'Color', [0 0 0])
        if gs, pause, end
    end
    imax = ceil( log2(b-a) - log2(tolx) );
    fa = feval(f, a);
    fb = feval(f, b);
    i = 0;
    while ( i<imax )
        x = (a+b)/2;
        if s, str = sprintf('x%d =', i); disp(str), disp(x), end
        fx = feval(f, x);
        f1x = abs( (fb-fa)/(b-a) );
        if abs(fx)<=tolx*f1x
            break
        elseif fa*fx<0
            if g
                YLim=get(hax,'YLim'); rectangle('Position', [x YLim(1) abs(b-x) abs(YLim(2)-YLim(1))], 'FaceColor', [0 0 0])
                if gs, pause, end
            end
            b = x; fb = fx;
        else
            if g
                YLim=get(hax,'YLim'); rectangle('Position', [a YLim(1) abs(x-a) abs(YLim(2)-YLim(1))], 'FaceColor', [0 0 0])
                if gs, pause, end
            end
            a = x; fa = fx;
        end
        i = i+1;
    end
    if g, line([x x], get(hax, 'YLim'), 'Color', [1 0 0]), end
    str=sprintf('Converge a %5.4f in %d passi', x, i); disp(str)
    tElapsed = toc(tStart); str=sprintf('Tempo medio/step: %5.4f ms; tempo totale %5.4f ms', tElapsed*1000/i, tElapsed*1000); disp(str)
    