% s = splineCubica(ptx, fi, nak)
% Determina le espressioni degli n polinomi che formano una spline
% cubica naturale o con condizioni not-a-knot.
%
% Input:
%   -ptx: vettore contenente gli n+1 nodi di interpolazione;
%   -fi: vettore contenente i valori assunti dalla funzione da
%   approssimare nei nodi in ptx;
%   -nak: true se la spline implementa condizioni not-a-knot, false se
%   invece è una spline naturale.
% Output:
%   -s: il vettore contenente le n espressioni dei polinomi costituenti
%   la spline.
%
% Autore: Tommaso Papini,
% Ultima modifica: 24 Ottobre 2012, 12:50 CEST.

function [s] = splineCubica(ptx, fi, nak)
    phi = zeros(length(ptx)-2, 1);
    xi = zeros(length(ptx)-2, 1);
    dd = zeros(length(ptx)-2, 1);
    for i=2:length(ptx)-1
        hi = ptx(i) - ptx(i-1);
        hi1 = ptx(i+1) - ptx(i);
        phi(i) = hi/(hi+hi1);
        xi(i) = hi1/(hi+hi1);
        dd(i) = differenzaDivisa(ptx(i-1:i+1), fi(i-1:i+1));
    end
    if nak
        mi = risolviSistemaSplineNotAKnot(phi, xi, dd);
    else
        mi = risolviSistemaSplineNaturale(phi, xi, dd);
    end
    s = espressioniSplineCubica(ptx, fi, mi);
end