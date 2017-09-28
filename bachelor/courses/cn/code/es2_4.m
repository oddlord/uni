% Esercizio 2.4
%
% Autore: Tommaso Papini,
% Ultima modifica: 4 Novembre 2012, 11:10 CET

f = inline('x^3-5*x');
f1 = inline('3*x^2-5');

disp('x minore di -sqrt(5/3):')
newton(f, f1, -sqrt(5/3)-eps, 100, eps, 0, 0, 0);
disp('Premere un tasto per continuare'), pause

disp('x tra -sqrt(5/3) e -1:')
newton(f, f1, (-sqrt(5/3)-1)/2, 100, eps, 0, 0, 0);
disp('Premere un tasto per continuare'), pause

disp('x tra -1 e 0:')
newton(f, f1, -1/2, 100, eps, 0, 0, 0);
disp('Premere un tasto per continuare'), pause

disp('x tra 1 e 0:')
newton(f, f1, 1/2, 100, eps, 0, 0, 0);
disp('Premere un tasto per continuare'), pause

disp('x tra 1 e sqrt(5/3):')
newton(f, f1, (1+sqrt(5/3))/2, 100, eps, 0, 0, 0);
disp('Premere un tasto per continuare'), pause

disp('x maggiore di sqrt(5/3):')
newton(f, f1, sqrt(5/3)+eps, 100, eps, 0, 0, 0);