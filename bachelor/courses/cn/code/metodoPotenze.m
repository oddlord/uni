% [l1, x1] = metodoPotenze(A, tol)
% Generico metodo delle potenze che calcola l'autovalore dominante
% semplice e l'autovettore corrispondente di una matrice entro una
% certa tolleranza.
%
% Input:
%   -A: la matrice di cui calcolare l'autovalore dominante e
%   l'autovettore corrisondente;
%   -tol: la tolleranza richiesta per l'approssimazione
%   dell'autovalore.
% Output:
%   -l1: l'approssimazione dell'autovalore dominante;
%   -x1: l'approssimazione dell'autovettore corrispondente
%   all'autovalore dominante.
%
% Autore: Tommaso Papini,
% Ultima modifica: 26 Ottobre 2012, 12:09 CEST

function [l1, x1] = metodoPotenze(A, tol)
    [m,n] = size(A);
    if m~=n
        error('La matrice non è quadrata!');
    end
    x1 = rand(n, 1);
    l1 = inf;
    err = inf;
    while err>tol
        x0 = x1/norm(x1, 2);
        x1 = A*x0;
        l0 = l1;
        l1 = x0'*x1;
        err = abs(l0-l1);
    end
end