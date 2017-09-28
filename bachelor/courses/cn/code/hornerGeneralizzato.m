% p = hornerGeneralizzato(x, f, xx)
% Algoritmo di Horner generalizzato che valuta un polinomio in forma di
% Newton su un vettore di punti.
%
% Input:
%   -x: vettore contenente le ascisse di interpolazione;
%   -f: vettore contenente le differenze divise;
%   -xx: vettore di punti sui quali valutare il polinomio.
% Output:
%   -p: vettore contenente le valutazioni del polinomio sui punti in
%   xx.
%
% Autore: Tommaso Papini,
% Ultima modifica: 26 ottobre 2012, 18:59 CEST

function [p] = hornerGeneralizzato(x, f, xx)
    n = length(x)-1;
    p = zeros(length(xx), 1);
    for i=1:length(xx)
        p(i) = f(n+1);
        for k=n:-1:1
            p = p*(xx(i)-x(k)) +f(k);
        end
    end
end