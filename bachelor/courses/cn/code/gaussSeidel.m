% [x1, i] = gaussSeidel(A, b, x0, tol)
% Risoluzione iterativa di sistemi lineari tramite il metodo di
% Gauss-Seidel.
%
% Input:
%   -A: la matrice dei coefficienti;
%   -b: vettore dei termini noti;
%   -x0: approssimazione iniziale della soluzione;
%   -tol: la tolleranza richiesta.
% Output:
%   -x1: l'approssimazione calcolata del vettore soluzione;
%   -i: numero di iterazioni eseguite.
%
% Autore: Tommaso Papini,
% Ultima modifica: 26 Ottobre 2012, 13:00 CEST

function [x1, i] = gaussSeidel(A, b, x0, tol)
    M = tril(A);
    i = 0;
    r = A*x0-b;
    while norm(r)>tol
        i = i+1;
        u = triangolareInfCol(M, r);
        x1 = x0-u;
        x0 = x1;
        r = A*x0-b;
    end
end