function mse_calc = populationMSE(population, net, inputs, targets)
    [m, ~] = size(population);
    mseVec = zeros(1, m);
    for i=1:m
        mseVec(i) = mseFF(population(i, :), net, inputs, targets);
    end
    mse_calc = mean(mseVec);
end

