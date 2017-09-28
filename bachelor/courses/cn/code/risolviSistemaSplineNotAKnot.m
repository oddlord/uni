% m = risolviSistemaSplineNotAKnot(phi, xi, dd)
% Risoluzione del sistema lineare di una spline cubica con condizioni
% not-a-knot per la determinazione dei fattori m_i necessari per la
% costruzione dell'espressione della spline cubica not-a-knot.
%
% Input:
%   -phi: vettore dei fattori phi che definiscono la matrice dei
%   coefficienti (lunghezza n-1);
%   -xi: vettore dei fattori xi che definiscono la matrice dei
%   coefficienti (lunghezza n-1);
%   -dd: vettore delle differenze divise (lunghezza n-1).
% Output:
%   -m: vettore riscritto con gli n+1 fattori m_i calcolati.
%
% Autore: Tommaso Papini,
% Ultima modifica: 24 Ottobre 2012, 12:44 CEST.

function [m] = risolviSistemaSplineNotAKnot(phi, xi, dd)
    dd=[6*dd(1); 6*dd; 6*dd(length(dd))];
    l=zeros(length(xi)+1, 1);
    u=zeros(length(xi)+2, 1);
    w=zeros(length(xi)+1, 1);
    u(1)=1;
    w(1)=0;
    l(1)=phi(1)/u(1);
    u(2)=2-phi(1);
    w(2)=xi(1)-phi(1);
    l(2)=phi(2)/u(2);
    u(3)=2-l(2)*w(2);
    for i=4:length(xi)
        w(i-1)=xi(i-2);
        l(i-1)=phi(i-1)/u(i-1);
        u(i)=2-l(i-1)*w(i-1);
    end
    w(length(xi))=xi(length(xi)-1);
    l(length(xi))=(phi(length(xi))-xi(length(xi)))/u(length(xi));
    u(length(xi)+1)=2-xi(length(xi))-l(length(xi)-1)*w(length(xi)-1);
    w(length(xi)+1)=xi(length(xi));
    l(length(xi)+1)=0;
    u(length(xi)+2)=1;

    y=zeros(length(xi)+2, 1);
    y(1)=dd(1);
    for i=2:length(xi)+2
        y(i)=dd(i)-l(i-1)*y(i-1);
    end
    m=zeros(length(xi)+2, 1);
    m(length(xi)+2)=y(length(xi)+2)/u(length(xi)+2);
    for i=length(xi)+1:-1:1
        m(i)=(y(i)-w(i)*m(i+1))/u(i);
    end
    m(1)=m(1)-m(2)-m(3);
    m(length(xi)+2)=m(length(xi)+2)-m(length(xi)+1)-m(length(xi));
end