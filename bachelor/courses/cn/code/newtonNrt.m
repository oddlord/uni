% newtonNrt(n, alpha, x0, imax, tolx)
% Metodo di Newton ottimizzato per l'approssimazione della radice
% n-esima.
%
% Input:
%   -n: l'indice della radice;
%   -alpha: l'argomento della radice;
%   -x0: l'approssimazione iniziale;
%   -imax: il numero massimo di iterazioni;
%   -tolx: la tolleranza desiderata.
%
% Autore: Tommaso Papini,
% Ultima modifica: 4 Novembre 2012, 11:19 CET

function [] = newtonNrt(n, alpha, x0, imax, tolx)
    format long e
    disp('x0 ='), disp(x0)
    x = ((n-1)*x0+alpha/(x0^(n-1)))/n;
    disp('x1 ='), disp(x)
    i = 1;
    while( i<imax ) && ( abs(x-x0)>tolx )
       i = i+1;
       x0 = x;
       x = ((n-1)*x0+alpha/(x0^(n-1)))/n;
       str = sprintf('x%d =', i);
       disp(str), disp(x)
    end
    if abs(x-x0)>tolx
        disp('NON CONVERGE entro la tolleranza ed il numero di passi richiesti')
    else
        disp('CONVERGE entro la tolleranza ed il numero di passi richiesti')
    end