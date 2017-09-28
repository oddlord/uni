% A = fattorizzaLDLt(A)
% Fattorizzazione LDLt di una matrice simmetrica e definita posiziva
% (sdp).
%
% Input:
%   -A: la matrice sdp da fattorizzare LDLt.
% Output:
%   -A: la matrice riscritta con le informazioni di L e D.
%
% Autore: Tommaso Papini,
% Ultima modifica: 4 Novembre 2012, 11:14 CET

function [A] = fattorizzaLDLt(A)
    [m,n]=size(A);
    if m~=n
        error('La matrice non è quadrata!');
    end
    if A(1,1)<=0
        error('La matrice non è sdp!');
    end
    A(2:n,1) = A(2:n,1)/A(1,1);
    for j=2:n
        v = ( A(j,1:(j-1))').*diag(A(1:(j-1),1:(j-1)));
        A(j,j) = A(j,j)-A(j,1:(j-1))*v;
        if A(j,j)<=0
            error('La matrice non è sdp!');
        end
        A((j+1):n,j) = (A((j+1):n,j)-A((j+1):n,1:(j-1))*v)/A(j,j);
    end
end