% mse_calc = mseFF(x, net, inputs, targets)
% Funzione che calcola lo scarto quadratico medio di una rete neurale
% di tipo Feed-Forward.
%
% Input:
%   -x: vettore riga contenente i pesi e i bias (traslazione di
%   soglia);
%   -net: la rete neurale;
%   -inputs: il vettore di input su cui simulare la rete;
%   -targets: il vettore obiettivo.
% Output:
%   -mse_calc: lo scarto quadratico medio calcolato.
%
% Autore: Tommaso Papini,
% Ultima modifica:

function mse_calc = mseFF(x, net, inputs, targets)

    net = setwb(net, x');
    y = net(inputs);

    mse_calc = mean(sum((y-targets).^2)/length(y));
end