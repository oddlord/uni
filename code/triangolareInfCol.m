% b = triangolareInfCol(A, b)
% Metodo per la risoluzione di sistemi lineari triangolari inferiori,
% accedendo agli elementi per colonna.
% Input:
%   -A: la matrice dei coefficienti;
%   -b: vettore dei termini noti.
% Output:
%   -b: vettore delle soluzioni.
%
% Autore: Tommaso Papini,
% Ultima modifica: 6 Ottobre 2012, 10:58 CEST

function [b] = triangolareInfCol(A, b)
    for j=1:length(A)
        if A(j,j)==0
            error('La matrice è singolare!')
        else
            b(j)=b(j)/A(j,j);
        end
        for i=j+1:length(A)
            b(i)=b(i)-A(i,j)*b(j);
        end
    end