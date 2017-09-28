% ptx = ascisseEquidistanti(a, b, n)
% Calcolo delle ascisse equidistanti in un dato intervallo.
%
% Input:
%   -a: estremo sinistro dell'intervallo;
%   -b: estremo destro dell'intervallo;
%   -n: numero delle ascisse da produrre (n+1, da 0 ad n).
% Output:
%   -ptx vettore contenente le n+1 ascisse equidistanti.
%
% Autore: Tommaso Papini,
% Ultima modifica: 28 Ottobre 2012, 17:09 CET

function [ptx] = ascisseEquidistanti(a, b, n)
    h = (b-a)/n;
    ptx = zeros(n+1, 1);
    for i=1:n+1
        ptx(i) = a +(i-1)*h;
    end
end