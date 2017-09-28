% f = differenzeDivise(x, f)
% Calcola le differenze divise che costituiscono i coefficienti della
% forma di Newton (rispetto alla base di Newton).
%
% Input:
%   -f: vettore contenente i valori della funzione sulle ascisse di
%   interpolazione;
%   -x: vettore contenente le n+1 ascisse di interpolazione.
% Output:
%   -f: vettore contenente le n+1 differenze divise.
%
% Autore: Tommaso Papini,
% Ultima modifica: 27 Ottobre 2012, 10:36 CEST.

function [f] = differenzeDivise(x, f)
    for i=1:length(x)-1
        for j=length(x):-1:i+1
            f(j) = (f(j) - f(j-1))/(x(j)-x(j-i));
        end
    end
end