% Esercizio 4.22
%
% Autore: Tommaso Papini,
% Ultima modifica: 4 Novembre 2012, 11:12 CET

hold on
y = [5.22; 4.00; 4.28; 3.89; 3.53; 3.12; 2.73; 2.70; 2.20; 2.08; 1.94];
plot ((0:10) ,y, 'black *')
y = log(y);

A = [ ones(1 ,11)' , (0:10)'];
[y, r] = SistemaQR ( FattQR (A),y);
y (1)= exp(y (1));
y(2)= -y (2);
disp ('Soluzione :'), disp (y)
disp ('Residuo :'), disp (r)

plot ((0:10) , y (1)* exp(-y (2)*(0:10)))

legend ('punti ','polinomio ','Location ','Best ')