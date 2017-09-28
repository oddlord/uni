% b = diagonale(A,b)
% Risoluzione di sistemi lineari diagonali.
%
% Input:
%   -A: la matrice dei coefficienti memorizzata in formato compresso
%   come vettore;
%   -b: vettore dei termini noti.
% Output:
%   -b: vettore delle soluzioni.
%
% Autore: Tommaso Papini,
% Ultima modifica: 13 Maggio 2013, 13:16 CEST

function [b] = diagonale(A,b)
    [n,m] = size(A);
    for i=1:n
        b(i) = b(i)/A(i,i);
    end
end