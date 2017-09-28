% Esercizio 5.08
%
% Autore: Tommaso Papini,
% Ultima modifica: 4 Novembre 2012, 11:13 CET

f = inline (' -2.*x .^( -3).* cos(x .^( -2)) ');
subplot (2 ,2 ,1)
axis ([ -5 105 -2 14])
title ('Trapezi composita ');
TrapeziComposita (f, 0.5 , 100 , 50, true );

subplot (2 ,2 ,2)
axis ([ -5 105 -2 14])
title ('Simpson composita ');
SimpsonComposita (f, 0.5 , 100 , 50, true );
subplot (2 ,2 ,3)
axis ([ -5 105 -2 14])
title ('Trapezi adattativa ');
TrapeziAdattativa (f, 0.5 , 100 , 10^ -3 , true );

subplot (2 ,2 ,4)
axis ([ -5 105 -2 14])
title ('Simpson adattativa ');
SimpsonAdattativa (f, 0.5 , 100 , 10^ -3 , true );