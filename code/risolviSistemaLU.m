% b = risolviSistemaLU(A,b)
% Risolve il sistema lineare Ax=b fattorizzando LU la matrice A,
% nonsingolare e con tutti i minori principali non nulli.
%
% Input:
%   -A: matrice nonsingolare dei coefficienti;
%   -b: vettore dei termini noti.
% Output:
%   -b: vettore delle soluzioni.
%
% Autore: Tommaso Papini,
% Ultima modifica: 4 Novembre 2012, 11:22 CET

function [b]= risolviSistemaLU(A,b)
    A = fattorizzaLU(A);
    b = triangolareInfCol(tril(A,-1)+eye(length(A)), b);
    b = triangolareSupCol(triu(A), b);
end