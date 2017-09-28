% Esercizio 4.9
%
% Autore: Tommaso Papini,
% Ultima modifica: 28 Ottobre 2012, 16:15 CET

format short

f = inline('(x-1).^9');
f1 = inline('9.*(x-1).^8');
ascisse = [0; 0.25; 0.5; 0.75; 1];
fi = f(ascisse);
fiHermite = zeros(2*length(ascisse), 1);
fiHermite(1:2:length(fiHermite)-1) = fi;
fiHermite(2:2:length(fiHermite)) = f1(ascisse);

pn = formaNewton(ascisse, fi);
ph = hermite(ascisse, fiHermite);

xtest = linspace(0,1,101);
figure (1)
h = subplot(1,2,1);
plot(xtest, f(xtest), 'b', xtest, pn(xtest), 'r', ascisse, fi, 'black *');
grid on
legend('funzione', 'polinomio', 'ascisse')
title('Interpolazione con polinomio di Newton')
subplot(1,2,2);
plot(xtest, f(xtest), 'b', xtest, ph(xtest), 'r', ascisse, fi, 'black *');
grid on
axis ([get(h, 'XLim') get(h, 'YLim')])
legend('funzione', 'polinomio', 'ascisse')
title('Interpolazione con polinomio di Hermite')

figure (2)
plot(xtest, pn(xtest), 'r *', xtest, ph(xtest), 'g *', xtest, f(xtest), 'b', ascisse, fi, 'black O');
grid on
legend('newton', 'hermite', 'funzione', 'ascisse')
title('Forma di Newton e Polinomio di Hermite')