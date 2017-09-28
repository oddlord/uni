% f = differenzeDiviseHermite(x, f)
% Calcola le differenze divise che costituiscono i coefficienti della
% forma di Newton (rispetto alla base di Newton) nel caso di ascisse di
% Hermite.
%
% Input:
%   -f: vettore contenente i valori della funzione e la derivata prima
%   sulle ascisse di interpolazione, nella forma [f0, f'0, f1, f'1,
%   ..., fn, f'n];
%   -x: vettore contenente le 2n+2 ascisse di interpolazione di
%   Hermite.
% Output:
%   -f: vettore contenente le 2n+2 differenze divise.
%
% Autore: Tommaso Papini,
% Ultima modifica: 27 Ottobre 2012, 17:55 CEST.

function [f] = differenzeDiviseHermite(x, f)
    for i = length(x)-1:-2:3
        f(i) = (f(i)-f(i-2))/(x(i)-x(i-2));
    end
    for i=2:length(x)-1
        for j=length(x):-1:i+1
            f(j) = (f(j)-f(j-1))/(x(j)-x(j-i));
        end
    end
end