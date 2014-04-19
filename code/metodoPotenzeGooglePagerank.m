% x = metodoPotenzeGooglePagerank(L, p, tol)
% Calcolo dell'autovettore corrispondente all'autovalore dominante 1
% utilizzando il metodo delle potenze ottimizzato per il calcolo del
% Google pagerank. La matrice L in input viene riscritta con gli
% elementi della matrice H.
%
% Input:
%   -L: matrice contenente le informazioni sui link presenti tra le
%   diverse pagine web (L(i, j)=1 se esiste un link tra la pagina j e
%   la pagina i, altrimenti 0);
%   -p: probabilità con cui il random surfer sceglie di seguire un link
%   presente nella pagina (con probabilità 1-p salta verso una pagina a
%   caso del web);
%   -tol: tolleranza richiesta.
% Output:
%   -x: approssimazione dell'autovettore relativo all'autovalore
%   dominante.
%
% Autore: Tommaso Papini,
% Ultima modifica: 27 Ottobre 2012, 10:22 CEST

function [x] = metodoPotenzeGooglePagerank(L, p, tol)
    [m,n] = size(L);
    if m~=n
        error('La matrice non è quadrata!');
    end
    
    delta = zeros(n, 1);
    for j=1:n
        for i=1:n
            delta(j) = delta(j) + L(i, j);
        end
    end
    for j=1:n
        for i=1:n
            if delta(j)==0
                L(i, j) = 0;
            else
                L(i, j) = L(i, j)/delta(j);
            end
        end
        if delta(j)==0
            delta(j)=1;
        else
            delta(j)=0;
        end
    end
    
    x = rand(n,1);
    x = x/norm(x);
    imax = (log(tol)-log(2))/(log(p));
    for i=1:imax
        x = p*(L*x)+((1+p*(delta'*x -1))/n)*ones(n,1);
    end
end