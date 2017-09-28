% A = fattorizzaLU(A)
% Fattorizzazione LU di una matrice nonsingolare con tutti i minori
% principali non nulli.
%
% Input:
%   -A: la matrice nonsingolare da fattorizzare LU.
% Output:
%   -A: la matrice riscritta con le informazioni dei fattori L ed U.
%
% Autore: Tommaso Papini,
% Ultima modifica: 7 Ottobre 2012, 13:17 CEST

function [A] = fattorizzaLU(A)
    [m,n]=size(A);
    if m~=n
        error('La matrice non è quadrata!');
    end
    for i=1:n-1
        if A(i,i)==0
            error('La matrice non è fattorizzabile LU!');
        end
        A(i+1:n,i) = A(i+1:n,i)/A(i,i);
        A(i+1:n,i+1:n) = A(i+1:n,i+1:n)-A(i+1:n,i)*A(i,i+1:n);
    end
end