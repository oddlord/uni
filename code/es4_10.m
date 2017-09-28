% Esercizio 4.10
%
% Autore: Tommaso Papini,
% Ultima modifica: 4 Novembre 2012, 11:12 CET

e= inline ('((2* pi ).^( n +1))./( factorial (n +1)) ');
n=0;
while (e(n)>= 10^ -6)
n=n+1;
end
fprintf ('e(%d) = %6.3 e\n', n, e(n));