% Esercizio 2.7
%
% Autore: Tommaso Papini,
% Ultima modifica: 4 Novembre 2012, 11:10 CET

f = inline('x-cos(x)');
f1 = inline('1+sin(x)');
tolx = 10^-1;
while tolx>eps
    disp(' '), str = sprintf('Tolleranza %d', tolx); disp(str)
    disp('Newton: '), newton(f, f1, 0, 1000, tolx, 0, 0, 0);
    disp('Corde: '), corde(f, f1, 0, 1000, tolx, 0, 0, 0);
    disp('Secanti: '), secanti(f, f1, 0, 1000, tolx, 0, 0, 0);
    tolx = tolx/10;
    disp('Premere un tasto per continuare'), pause
end