% b = risolviSistemaLDLt(A, b)
% Risoluzione di un sistema lineare con matrice dei coefficienti A sdp
% fattorizzando LDLt la matrice dei coefficienti.
%
% Input:
%   -A: la matrice sdp dei coefficienti;
%   -b: vettore dei termini noti.
% Output:
%   -b: vettore soluzione del sistema.
%
% Autore: Tommaso Papini,
% Ultima modifica: 4 Novembre 2012, 11:22 CET

function [b] = risolviSistemaLDLt(A, b)
    A = fattorizzaLDLt(A);
    b = triangolareInfCol(tril(A,-1)+eye(length(A)), b);
    b = diagonale(diag(A), b);
    b = triangolareSupCol((tril(A,-1)+eye(length(A)))', b);
end