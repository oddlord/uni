% Esercizio 3.25 
%
% Autore: Tommaso Papini,
% Ultima modifica: 4 Novembre 2012, 11:11 CET

format short e
A=eye(10)+100*[ zeros(1, 10); eye(9) zeros(1, 9)']
inv(A)
cond (A)