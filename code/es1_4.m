% Esercizio 1.4
%
% Autore: Tommaso Papini,
% Ultima modifica: 4 Novembre 2012, 11:04 CET

hold on
format long e;
tol = 1e-11;

x = zeros(1, 2);
delta = 2 - sqrt(2);
i = 1;
while(delta > tol)
    if(i==1)
        x(1, 1) = 2;
    elseif (i==2)
        x(2, 1) = 1.5;
    else
        x(i, 1) = (x(i-1, 1)*x(i-2, 1) +2)/(x(i-1, 1) + x(i-2, 1));
    end
    delta = x(i, 1) - sqrt(2);
    x(i, 2) = delta;
    i = i+1;
end
x
plot(1:i-1, x(1:i-1, 1), 'b');

x = zeros(1, 2);
delta = 2 - sqrt(2);
i = 1;
while (delta > tol)
   if (i==1)
       x(1, 1) = 2;
   else
      x(i, 1) = 1/2*(x(i-1, 1) + 2/x(i-1, 1)); 
   end
   delta = x(i, 1) - sqrt(2);
   x(i, 2) = delta;
   i = i+1;
end
x
plot(1:i-1, x(1:i-1, 1), 'r');

legend('primo metodo', 'secondo metodo')
title('Esercizio 1.4')
hold off