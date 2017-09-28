% Esercizio 5.10
%
% Autore: Tommaso Papini,
% Ultima modifica: 4 Novembre 2012, 11:13 CET

f = inline (' -2*x^( -3)* cos(x^ -2) ');

fprintf ('\n\ tFormula composita di Simpson \n')
for n =1000:1000:10000
	I = SimpsonComposita (f, 1/2 , 100 , n, false );
	fprintf ('n = %d \t I = %5.4 e \t E = %5.4 e\n', n, I, abs(I -( sin (10^ -4) - sin (4))));
end
fprintf ('\n\n\ tFormula di Simpson adattativa \n')
for i =1:5
	tol = 10^ -i;
	[I, p] = SimpsonAdattativa (f, 1/2 , 100 , tol , false );
	fprintf ('tol = %1.1 e \t I = %5.4 e \t E = %5.4 e \t punti = %d\n', tol , I, abs(I -( sin (10^ -4) - sin (4))) , p);
end