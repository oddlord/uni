% Esercizio 2.8
%
% Autore: Tommaso Papini,
% Ultima modifica: 4 Novembre 2012, 11:10 CET

f = inline('x-cos(x)');
f1 = inline('1+sin(x)');
tolx = 10^-1;
while tolx>eps
    disp(' '), str = sprintf('Tolleranza %d', tolx); disp(str)
    bisezione(f, 0, 1, tolx, 0, 0, 0);
    tolx = tolx/10;
    disp('Premere un tasto per continuare'), pause
end