% int = simpsonComposita(f, a, b, n)
% Formula di Simpson composita per l'approssimazione dell'integrale
% definito di una funzione.
%
% Input:
%   -f: la funzione di cui si vuol calcolare l'integrale;
%   -a: estremo sinistro dell'intervallo di integrazione;
%   -b: estremo destro dell'intervallo di integrazione;
%   -n: numero, pari, di sottointervalli sui quali applicare la formula
%   di Simpson semplice.
% Output:
%   -int: l'approssimazione dell'integrale definito della funzione.
%
% Autore: Tommaso Papini,
% Ultima modifica: 24 Ottobre 2012, 18:20 CEST 

function [int] = simpsonComposita(f, a, b, n)
    h = (b-a)/n;
    int = f(a)-f(b);
    for i=1:n/2
        int = int + 4*f(a+(2*i-1)*h)+2*f((a+2*i*h));
    end
    int = int*(h/3);
end