% Esercizio 4.11
%
% Autore: Tommaso Papini,
% Ultima modifica: 31 Ottobre 2012, 16:57 CET

fRunge = inline('1./(1.+x.^2)');
fBernstein = inline('abs(x)');
e = inline('abs( feval(f,x) - feval(p,x) )');

disp('Esempio di Runge:')
a=-5; b=5;
n = 5;
ascisse = ascisseEquidistanti(a, b, n);
pRunge = formaNewton(ascisse, fRunge(ascisse));
figure(1)
fplot(@(x)(e(fRunge, pRunge, x)), [a b], 'b');
hold on
grid on
legend('n=5')
title('Esempio di Runge: Errori')
maxErr = e(fRunge, pRunge, fminbnd(@(x)(-e(fRunge, pRunge, x)), a, b));
str = sprintf('Errore massimo con n = %d: %5.4f', n, maxErr); disp(str);
figure (2)
subplot(2,2,1)
fplot(fRunge, [a b], 'b')
hold on
grid on
fplot(pRunge, [a b], 'r')
plot(ascisse, fRunge(ascisse), 'k *')
title(sprintf('n=%d', n))

n = 10;
ascisse = ascisseEquidistanti(a, b, n);
pRunge = formaNewton(ascisse, fRunge(ascisse));
figure(1)
fplot(@(x)(e(fRunge, pRunge, x)), [a b], 'r');
legend('n=5', 'n=10')
maxErr = e(fRunge, pRunge, fminbnd(@(x)(-e(fRunge, pRunge, x)), a, b));
str = sprintf('Errore massimo con n = %d: %5.4f', n, maxErr); disp(str);
figure (2)
subplot(2,2,2)
fplot(fRunge, [a b], 'b')
hold on
grid on
fplot(pRunge, [a b], 'r')
plot(ascisse, fRunge(ascisse), 'k *')
title(sprintf('n=%d', n))

n = 15;
ascisse = ascisseEquidistanti(a, b, n);
pRunge = formaNewton(ascisse, fRunge(ascisse));
figure(1)
fplot(@(x)(e(fRunge, pRunge, x)), [a b], 'g');
legend('n=5', 'n=10', 'n=15')
maxErr = e(fRunge, pRunge, fminbnd(@(x)(-e(fRunge, pRunge, x)), a, b));
str = sprintf('Errore massimo con n = %d: %5.4f', n, maxErr); disp(str);
figure (2)
subplot(2,2,3)
fplot(fRunge, [a b], 'b')
hold on
grid on
fplot(pRunge, [a b], 'r')
plot(ascisse, fRunge(ascisse), 'k *')
title(sprintf('n=%d', n))

n = 20;
ascisse = ascisseEquidistanti(a, b, n);
pRunge = formaNewton(ascisse, fRunge(ascisse));
maxErr = e(fRunge, pRunge, fminbnd(@(x)(-e(fRunge, pRunge, x)), a, b));
str = sprintf('Errore massimo con n = %d: %5.4f', n, maxErr); disp(str);
figure (2)
subplot(2,2,4)
fplot(fRunge, [a b], 'b')
hold on
grid on
fplot(pRunge, [a b], 'r')
plot(ascisse, fRunge(ascisse), 'k *')
title(sprintf('n=%d', n))

disp(' '), disp('Esempio di Bernstein:')
a=-1; b=1;
n = 5;
ascisse = ascisseEquidistanti(a, b, n);
pBernstein = formaNewton(ascisse, fBernstein(ascisse));
figure(3)
fplot(@(x)(e(fBernstein, pBernstein, x)), [a b], 'b');
hold on
grid on
legend('n=5')
title('Esempio di Bernstein: Errori')
maxErr = e(fBernstein, pBernstein, fminbnd(@(x)(-e(fBernstein, pBernstein, x)), a, b));
str = sprintf('Errore massimo con n = %d: %5.4f', n, maxErr); disp(str);
figure (4)
subplot(2,2,1)
fplot(fBernstein, [a b], 'b')
hold on
grid on
fplot(pBernstein, [a b], 'r')
plot(ascisse, fBernstein(ascisse), 'k *')
title(sprintf('n=%d', n))

n = 10;
ascisse = ascisseEquidistanti(a, b, n);
pBernstein = formaNewton(ascisse, fBernstein(ascisse));
figure(3)
fplot(@(x)(e(fBernstein, pBernstein, x)), [a b], 'r');
legend('n=5', 'n=10')
maxErr = e(fBernstein, pBernstein, fminbnd(@(x)(-e(fBernstein, pBernstein, x)), a, b));
str = sprintf('Errore massimo con n = %d: %5.4f', n, maxErr); disp(str);
figure (4)
subplot(2,2,2)
fplot(fBernstein, [a b], 'b')
hold on
grid on
fplot(pBernstein, [a b], 'r')
plot(ascisse, fBernstein(ascisse), 'k *')
title(sprintf('n=%d', n))

n = 15;
ascisse = ascisseEquidistanti(a, b, n);
pBernstein = formaNewton(ascisse, fBernstein(ascisse));
figure(3)
fplot(@(x)(e(fBernstein, pBernstein, x)), [a b], 'g');
legend('n=5', 'n=10', 'n=15')
maxErr = e(fBernstein, pBernstein, fminbnd(@(x)(-e(fBernstein, pBernstein, x)), a, b));
str = sprintf('Errore massimo con n = %d: %5.4f', n, maxErr); disp(str);
figure (4)
subplot(2,2,3)
fplot(fBernstein, [a b], 'b')
hold on
grid on
fplot(pBernstein, [a b], 'r')
plot(ascisse, fBernstein(ascisse), 'k *')
title(sprintf('n=%d', n))

n = 20;
ascisse = ascisseEquidistanti(a, b, n);
pBernstein = formaNewton(ascisse, fBernstein(ascisse));
maxErr = e(fBernstein, pBernstein, fminbnd(@(x)(-e(fBernstein, pBernstein, x)), a, b));
str = sprintf('Errore massimo con n = %d: %5.4f', n, maxErr); disp(str);
figure (4)
subplot(2,2,4)
fplot(fBernstein, [a b], 'b')
hold on
grid on
fplot(pBernstein, [a b], 'r')
plot(ascisse, fBernstein(ascisse), 'k *')
title(sprintf('n=%d', n))