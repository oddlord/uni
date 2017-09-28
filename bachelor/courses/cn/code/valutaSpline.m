% sx = valutaSpline(ptx, s, pt)
% Valuta una spline su una serie di punti.
%
% Input:
%   -ptx: vettore contenente gli n+1 nodi di interpolazione;
%   -s: vettore contenente le espressioni degli n polinomi che
%   definiscono la spline;
%   -pt: vettore di m punti su cui si vuole valutare la spline.
% Output:
%   -sx: vettore di m valori contenente la valutazione dei punti in pt
%   della spline (NaN se un punto non è valutabile).
%
% Autore: Tommaso Papini,
% Ultima modifica: 24 Ottobre 2012, 11:57 CEST.

function [sx] = valutaSpline(ptx, s, pt)
    sx = zeros(length(pt), 1);
    for i=1:length(pt)
        if pt(i)<ptx(1) || pt(i)>ptx(length(ptx))
            str=spintf('%5.4f non valutato: punto esterno all''intervallo [%5.4f, %5.4f].', pt(i), ptx(1), ptx(length(ptx))); disp(str);
            sx(i)=NaN;
        else
            for j=1:length(ptx)
                if pt(i)>=ptx(j-1) && pt(i)<=ptx(j)
                    f = inline(s(j));
                    sx(i)=f(pt(i));
                    break;
                end
            end
        end
    end
end