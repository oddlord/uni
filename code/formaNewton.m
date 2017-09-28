% p = formaNewton(ptx, fi)
% Calcolo dell'espressione del polinomio interpolante una funzione in
% forma di Newton.
%
% Input:
%   -ptx: vettore contenente le ascisse di interpolazione;
%   -fi: i valori assunti dalla funzione da interpolare in
%   corrispondenza delle ascisse di interpolazione in ptx.
% Output:
%   -p: espressione (come funzione inline) del polinomio interpolante.
%
% Autore: Tommaso Papini,
% Ultima modifica: 28 Ottobre 2012, 19:00 CET

function [p] = formaNewton(ptx, fi)
    n = length(ptx)-1;
    dd = differenzeDivise(ptx, fi);
    syms x;
    p = dd(1);
    for i=2:n+1
        prod = dd(i);
        for j=1:i-1
            prod = prod*(x-ptx(j));
        end
        p = p + prod;
    end
    p = inline(p);
end