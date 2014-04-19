% Esercizio 3.33
%
% Autore: Tommaso Papini,
% Ultima modifica: 4 Novembre 2012, 11:12 CET

format short
x (1)= input ('Valore iniziale x1 = ');
x (2)= input ('Valore iniziale x2 = ');
imax = input ('Numero massimo d''iterazioni : imax = ');
tolx = input ('Tolleranza : tolx = ');

F= inline ('[4*x (1)^3+2* x (1)+ x(2) , x (1)+2* x (2)+2] ');

i=0;
while (i< imax )&&( norm (x- xold )> tolx )
i=i+1;
xold =x;
J =[12* x (1)^2+2 , 1; 1, 2];
[J, p] = fattorizzaLUpivoting (J);
x=x+ risolviSistemaLUpivoting (J, p, -feval (F,x));
end
disp ('Punto di minimo : '), disp (x)
disp ('Valore assunto : '), disp (x (1)^4+ x (1)*( x (1)+ x (2))+(1+ x (2))^2)