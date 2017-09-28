% p = hermite(ptx, fi)
% Calcolo dell'espressione del polinomio interpolante di Hermite.
%
% Input:
%   -ptx: vettore contenente le ascisse di interpolazione;
%   -fi: vettore contenente i valori della funzione e la derivata prima
%   sulle ascisse di interpolazione, nella forma [f0, f'0, f1, f'1,
%   ..., fn, f'n].
% Output:
%   -p: espressione (come funzione inline) del polinomio
%   interpolante.
%
% Autore: Tommaso Papini,
% Ultima modifica: 28 Ottobre 2012, 19:00 CET

function [p] = hermite(ptx, fi)
    n = length(ptx)-1;
    ptx2 = zeros(2*n+2, 1);
    ptx2(1:2:2*n+1)=ptx;
    ptx2(2:2:2*n+2)=ptx;
    dd = differenzeDiviseHermite(ptx2, fi);
    syms x;
    p = dd(1);
    for i=2:2*n+2
        prod = dd(i);
        for j=1:i-1
            prod = prod*(x-ptx2(j));
        end
        p = p + prod;
    end
    p = inline(p);
end