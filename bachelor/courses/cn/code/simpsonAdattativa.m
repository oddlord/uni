% [int, pt] = simpsonAdattativa(f, a, b, tol)
% Formula di Simpson adattativa per l'approssimazione dell'integrale
% definito di una funzione.
%
% Input:
%   -f: la funzione di cui si vuol calcolare l'integrale;
%   -a: estremo sinistro dell'intervallo di integrazione;
%   -b: estremo destro dell'intervallo di integrazione;
%   -tol: la tolleranza entro la quale si richiede debba rientrare la
%   soluzione approssimata.
% Output:
%   -int: l'approssimazione dell'integrale definito della funzione;
%   -pt: numero di punti generati ricorsivamente.
%
% Autore: Tommaso Papini,
% Ultima modifica: 25 Giugno 2013, 23:53 CEST

function [int, pt] = simpsonAdattativa(f, a, b, tol)
    [int, pt] = simpsonAdattativaRicorsiva(f, a, b, tol, 5);
end

function [int, pt] = simpsonAdattativaRicorsiva(f, a, b, tol, pt)
    h = (b-a)/6;
    m = (a+b)/2;
    m1 = (a+m)/2;
    m2 = (m+b)/2;
    int1 = h*(feval(f, a) +4*feval(f, m) + feval(f, b));
    int = int1/2 + h*(2*feval(f, m1) + 2*feval(f, m2) -feval(f, m));
    err = abs(int-int1)/15;
    if err>tol
        [intSx, ptSx] = simpsonAdattativaRicorsiva(f, a, m, tol/2, 1);
        [intDx, ptDx] = simpsonAdattativaRicorsiva(f, m, b, tol/2, 1);
        int = intSx+intDx;
        pt = pt+ptSx+ptDx;
    end
end