% s = espressioniSplineCubica(ptx, fi, mi)
% Calcola le espressioni degli n polinomi costituenti una spline
% cubica.
%
% Input:
%   -ptx: vettore contenente gli n+1 nodi di interpolazione;
%   -fi: vettore contenente i valori assunti dalla funzione da
%   approssimare nei nodi in ptx;
%   -mi: fattori m_i calcolati risolvendo il sistema lineare
%   corrispondente.
% Output:
%   -s: vettore contenente le espressioni degli n polinomi che
%   definiscono la spline cubica.
%
% Autore: Tommaso Papini,
% Ultima modifica: 24 Ottobre 2012, 12:19 CEST.

function [s] = espressioniSplineCubica(ptx, fi, mi)
    s = sym('x', [length(ptx)-1 1]);
    syms x;
    for i=2:length(ptx)
        hi = ptx(i)-ptx(i-1);
        ri = fi(i-1)-((hi^2)/6)*mi(i-1);
        qi = (fi(i)-fi(i-1))/hi -(hi/6)*(mi(i)-mi(i-1));
        s(i-1)=(((x - ptx(i-1))^3)*mi(i) + ((ptx(i) - x)^3)*mi(i-1))/(6*hi) +qi*(x - ptx(i-1)) +ri;
    end
end