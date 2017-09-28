% b = triangolareSupCol(A, b)
% Metodo per la risoluzione di sistemi lineari triangolari superiori,
% accedendo agli elementi per colonna.
%
% Input:
%   -A: la matrice dei coefficienti;
%   -b: vettore dei termini noti.
% Output:
%   -b: vettore delle soluzioni.
%
% Autore: Tommaso Papini,
% Ultima modifica: 4 Novembre 2012, 11:27 CET

function [b] = triangolareSupCol(A, b)
    for j=length(A):-1:1
        if A(j,j)==0
            error('La matrice è singolare!')
        else
            b(j)=b(j)/A(j,j);
        end
        for i=1:j-1
            b(i)=b(i)-A(i,j)*b(j);
        end
    end