g = [9, 10, 10, 10, 10, 9, 10, 10, 10, 10];

y = [7, 9, 6, 10, 9, 7, 7, 9, 7, 8];

plot(g, '-o', 'LineWidth', 3, 'MarkerSize', 15, 'Color', 'b');
hold on;
plot(y, '-s', 'LineWidth', 3, 'MarkerSize', 15, 'Color', 'r');
axis([0  11 0 11]);
title('Valutazione euristica');
legend('Gmail', 'Yahoo Mail');