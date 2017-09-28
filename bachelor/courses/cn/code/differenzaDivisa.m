% dd = differenzaDivisa(ptx, fi)
% Calcola la differenza divisa relativa ad un set di ascisse.
%
% Input:
%   -ptx: vettore contenente le ascisse su cui calcolare la differenza
%   divisa;
%   -fi: vettore contenente i valori assunti dalla funzione in
%   corrispondenza dei punti in ptx.
% Output:
%   -dd: il valore della differenza divisa risultante.
%
% Autore: Tommaso Papini,
% Ultima modifica: 24 Ottobre 2012, 12:36 CEST.

function [dd] = differenzaDivisa(ptx, fi)
    dd = 0;
    for i=1:length(ptx)
        prod = 1;
        for j=1:length(ptx)
            if j~=i
                prod = prod*(ptx(i)-ptx(j));
            end
        end
        dd = dd+fi(i)/prod;
    end
end