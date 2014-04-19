% [int, pt] = trapeziAdattativaRicorsiva(f, a, b, tol, pt)
% Formula dei trapezi adattativa per l'approssimazione dell'integrale
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
% Ultima modifica: 25 Giugno 2013, 23:54 CEST 

function [int, pt] = trapeziAdattativa(f, a, b, tol)
    [int, pt] = trapeziAdattativaRicorsiva(f, a, b, tol, 3);
end

function [int, pt] = trapeziAdattativaRicorsiva(f, a, b, tol, pt)
    h = (b-a)/2;
    m = (a+b)/2;
    int1 = h*(feval(f, a) + feval(f, b));
    int = int1/2 + h*feval(f, m);
    err = abs(int-int1)/3;
    if err>tol
        [intSx, ptSx] = trapeziAdattativaRicorsiva(f, a, m, tol/2, 1);
        [intDx, ptDx] = trapeziAdattativaRicorsiva(f, m, b, tol/2, 1);
        int = intSx+intDx;
        pt = pt+ptSx+ptDx;
    end
end