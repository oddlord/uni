% b = risolviSistemaLUpivoting(A,b)
% Risolve il sistema lineare Ax=b fattorizzando LU con pivoting
% parziale la matrice nonsingolare A.
%
% Input:
%   -A: matrice nonsingolare dei coefficienti;
%   -b: vettore dei termini noti.
% Output:
%   -b: vettore delle soluzioni.
%
% Autore: Tommaso Papini,
% Ultima modifica: 4 Novembre 2012, 11:22 CET

function [b]= risolviSistemaLUpivoting(A,b)
    [A,p] = fattorizzaLUpivoting(A);
    P=zeros(length(A));
    for i=1:length(A)
        P(i, p(i)) = 1;
    end
    b = triangolareInfCol(tril(A,-1)+eye(length(A)), P*b);
    b = triangolareSupCol(triu(A), b);
end