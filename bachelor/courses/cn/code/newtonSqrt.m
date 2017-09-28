% newtonSqrt(alpha, x0, imax, tolx)
% Metodo di Newton ottimizzato per l'approssimazione della radice
% quadrata.
%
% Input:
%   -alpha: l'argomento della radice quadrata;
%   -x0: l'approssimazione iniziale;
%   -imax: il numero massimo di iterazioni;
%   -tolx: la tolleranza desiderata.
%
% Autore: Tommaso Papini,
% Ultima modifica: 4 Novembre 2012, 11:19 CET

function [] = newtonSqrt(alpha, x0, imax, tolx)
    format long e
    disp('x0 ='), disp(x0)
    x = (x0+alpha/x0)/2;
    disp('x1 ='), disp(x)
    i = 1;
    while( i<imax ) && ( abs(x-x0)>tolx )
       i = i+1;
       x0 = x;
       x = (x0+alpha/x0)/2;
       str = sprintf('x%d =', i);
       disp(str), disp(x)
    end
    if abs(x-x0)>tolx
        disp('NON CONVERGE entro la tolleranza ed il numero di passi richiesti')
    else
        disp('CONVERGE entro la tolleranza ed il numero di passi richiesti')
    end