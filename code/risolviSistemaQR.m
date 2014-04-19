% b = risolviSistemaQR(A,b)
% Risoluzione di un sistema lineare sovredeterminato del tipo Ax=b
% tramite fattorizzazione QR di Householder della matrice dei
% coefficienti.
%
% Input:
%   -A: matrice dei coefficienti;
%   -b: vettore dei termini noti.
% Output:
%   -b: vettore delle soluzioni del sistema lineare sovradeterminato.
%
% Autore: Tommaso Papini,
% Ultima modifica: 4 Novembre 2012, 11:23 CET

function [b] = risolviSistemaQR(A,b)
    [m,n] = size(A);
    A = fattorizzaQR(A);
    Qt=eye(m);
    for i=1:n
        Qt = [eye(i-1) zeros(i-1, m-i+1); zeros(i-1, m-i+1)' (eye(m-i+1)-(2/norm([1; A(i+1:m, i)], 2)^2)*([1; A(i+1:m, i)]*[1 A(i+1:m, i)']))]*Qt;
    end
    b = triangolareSupCol(triu(A(1:n, :)), Qt(1:n, :)*b);
end