% Esercizio 6.12
%
% Autore: Tommaso Papini,
% Ultima modifica: 4 Novembre 2012, 11:13 CET

format short
fprintf ('\ nMETODO DI JACOBI \n')
for n =5:5:50
	tol =10^ -1;
	while (tol >10^ -10)
		A=eye(n);
		for i=2:n
			
		end
		A(1,n )= -1/2;
		b= zeros (n ,1);
		b (1)=1/2;
		[b,i]= Jacobi ( A, b, tol );
		fprintf ('n = %d \t tol = %5.4 e \t i = %d \n', n, tol , i);
		tol=tol /10;
	end
end
fprintf ('\ nMETODO DI GAUSS - SEIDEL \n')
for n =5:5:50
	tol =10^ -1;
	while (tol >10^ -10)
		A=eye(n);
		for i=2:n
			A(i,i -1)= -1;
		end
		A(1,n )= -1/2;
		b= zeros (n ,1);
		b (1)=1/2;
		[b,i]= GaussSeidel ( A, b, tol );
		fprintf ('n = %d \t tol = %5.4 e \t i = %d \n', n, tol , i);
		tol=tol /10;
	end
	fprintf ('\n')
end