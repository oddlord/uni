% score = getScore(net, validationDays, Pnew, Tnew, i)
%
% Calculates the root mean square of the net for the next
% validationDays days.
%
% Input:
%   -net: the neural network used;
%   -validationDays: number of validation days;
%   -Pnew: input vector from the last training day;
%   -Tnew: target vector from the last training day;
%   -i: current day of training.
% Output:
%   -score: the calculated root mean square.
%
% Author: Tommaso Papini,
% Last modified: 28th December 2012, 11:01 CET.

function score = getScore(net, validationDays, Pnew, Tnew, i)
    i=mod(i, 28)+1;
    lastDay = i+validationDays;
    if lastDay>28
        P=[Pnew(:,i:28), Pnew(:, 1:mod(lastDay, 28))];
        T=[Tnew(:,i:28), Tnew(:, 1:mod(lastDay, 28))];
    else
        P=Pnew(:, i:lastDay);
        T=Tnew(:, i:lastDay);
    end
    score = mse(net, T, net(P));
end

