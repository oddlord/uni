% Esercizio 4.20
%
% Autore: Tommaso Papini,
% Ultima modifica: 1 Novembre 2012, 11:20 CET

fRunge = inline('1./(1.+x.^2)');
fBernstein = inline('abs(x)');

for i=1:4
    n=i*10;
    
    a=-5; b=5;
    ascisse = ascisseEquidistanti(a, b, n);
    fi = fRunge(ascisse);
    sN = splineCubica(ascisse, fi, false);
    sNaK = splineCubica(ascisse, fi, true);
    figure (1)
    h = subplot(2,2,i);
    fplot(fRunge, [a b], 'b')
    lims = [get(h, 'XLim') get(h, 'YLim')];
    hold on
    grid on
    for j=1:n
        fplot(inline(sN(j)), [ascisse(j) ascisse(j+1)], 'r')
    end
    axis(lims)
    plot(ascisse, fi, 'k *')
    title(sprintf('n=%d', n))
    figure (2)
    h = subplot(2,2,i);
    fplot(fRunge, [a b], 'b')
    lims = [get(h, 'XLim') get(h, 'YLim')];
    hold on
    grid on
    for j=1:n
        fplot(inline(sNaK(j)), [ascisse(j) ascisse(j+1)], 'r')
    end
    axis(lims)
    plot(ascisse(1), fi(1), 'k *', ascisse(n+1), fi(n+1), 'k *')
    plot(ascisse(2), fi(2), 'k O', ascisse(n), fi(n), 'k O')
    plot(ascisse(3:n-1), fi(3:n-1), 'k *')
    title(sprintf('n=%d', n))
    
    a=-1; b=1;
    ascisse = ascisseEquidistanti(a, b, n);
    fi = fBernstein(ascisse);
    sN = splineCubica(ascisse, fi, false);
    sNaK = splineCubica(ascisse, fi, true);
    figure (3)
    h = subplot(2,2,i);
    fplot(fBernstein, [a b], 'b')
    lims = [get(h, 'XLim') get(h, 'YLim')];
    hold on
    grid on
    for j=1:n
        fplot(inline(sN(j)), [ascisse(j) ascisse(j+1)], 'r')
    end
    axis(lims)
    plot(ascisse, fi, 'k *')
    title(sprintf('n=%d', n))
    figure (4)
    h = subplot(2,2,i);
    fplot(fBernstein, [a b], 'b')
    lims = [get(h, 'XLim') get(h, 'YLim')];
    hold on
    grid on
    for j=1:n
        fplot(inline(sNaK(j)), [ascisse(j) ascisse(j+1)], 'r')
    end
    axis(lims)
    plot(ascisse(1), fi(1), 'k *', ascisse(n+1), fi(n+1), 'k *')
    plot(ascisse(2), fi(2), 'k O', ascisse(n), fi(n), 'k O')
    plot(ascisse(3:n-1), fi(3:n-1), 'k *')
    title(sprintf('n=%d', n))
end