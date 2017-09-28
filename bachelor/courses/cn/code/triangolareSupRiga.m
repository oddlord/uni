% b = triangolareSupRiga(A, b)
% Metodo per la risoluzione di sistemi lineari triangolari superiori,
% accedendo agli elementi per riga.
%
% Input:
%   -A: la matrice dei coefficienti;
%   -b: vettore dei termini noti.
% Output:
%   -b: vettore delle soluzioni.
%
% Autore: Tommaso Papini,
% Ultima modifica: 4 Novembre 2012, 11:27 CET

function [b] = triangolareSupRiga(A, b)
    for i=length(A):-1:1
        for j=i+1:length(A)
            b(i)=b(i)-A(i,j)*b(j);
        end
        if A(i,i)==0
            error('La matrice è singolare!')
        else
            b(i)=b(i)/A(i,i);
        end
    end