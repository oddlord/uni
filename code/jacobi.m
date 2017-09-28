% [x1, i] = jacobi(A, b, x0, tol)
% Risoluzione iterativa di sistemi lineari tramite il metodo di Jacobi.
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
% Ultima modifica: 13 Maggio 2013, 13:16 CEST

function [x1, i] = jacobi(A, b, x0, tol)
    M = diag(diag(A));
    i = 0;
    r = A*x0-b;
    x1=x0;
    while norm(r)>tol
        i = i+1;
        u = diagonale(M, r);
        x1 = x0-u;
        x0 = x1;
        r = A*x0-b;
    end
end