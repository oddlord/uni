% Esercizio 6.2
%
% Autore: Tommaso Papini,
% Ultima modifica: 4 Novembre 2012, 11:13 CET

format short

for n =5:5:50
	A=2* eye(n);
	for i=2:n
		A(i,i -1)= -1;
		A(i -1,i)= -1;
	end
	lambda = MetodoPotenze (A, 10^ -5);
	approx = 2*(1+ cos(pi /(n +1)));
	fprintf ('n = %d\ tlambda = %5.4 f\ tapprox = %5.4 f\ terr = %5.4 f \n', n, lambda , approx , abs(lambda - approx ));
end