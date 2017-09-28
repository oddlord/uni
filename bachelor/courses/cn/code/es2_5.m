% Esercizio 2.5
%
% Autore: Tommaso Papini,
% Ultima modifica: 4 Novembre 2012, 11:10 CET

f = inline('(x-1)^10');
f1 = inline('10*(x-1)^9');
tolx = 10^-1;
disp('f1(x)=(x-1)^10')
while tolx>eps
    disp(' '), str = sprintf('Tolleranza %d', tolx); disp(str)
    disp('Newton: '), newton(f, f1, 10, 1000, tolx, 0, 0, 0);
    disp('Newton modificato: '), newtonMod(f, f1, 10, 10, 1000, tolx, 0, 0, 0);
    disp('Aitken: '), aitken(f, f1, 10, 1000, tolx, 0, 0, 0);
    tolx = tolx/10;
    disp('Premere un tasto per continuare'), pause
end

f = inline('((x-1)^10)*exp(x)');
f1 = inline('((x-1)^9)*(x+9)*exp(x)');
tolx = 10^-1;
disp(' '), disp('f2(x)=((x-1)^10)*exp(x)')
while tolx>eps
    disp(' '), str = sprintf('Tolleranza %d', tolx); disp(str)
    disp('Newton: '), newton(f, f1, 10, 1000, tolx, 0, 0, 0);
    disp('Newton modificato: '), newtonMod(f, f1, 10, 10, 1000, tolx, 0, 0, 0);
    disp('Aitken: '), aitken(f, f1, 10, 1000, tolx, 0, 0, 0);
    tolx = tolx/10;
    disp('Premere un tasto per continuare'), pause
end