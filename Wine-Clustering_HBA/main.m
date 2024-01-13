% derste yapýlan kod

clc;
clear all;

funcName = 'calcSales';
popSize = 30;
maxIteration = 5000;
D = 12;
alt = -100;
ust = 100;

run = 1;

for i=1:run
    [obj(i, 1), pos(i, :), cnvg(i, :)] = pso_pro_func(funcName, popSize, maxIteration, D, alt, ust);
end

variance = findVariance();
successRate = (mean(obj)/variance);

Ort = mean(cnvg);

% funcName = 'ackley';
% popSize = 50;
% maxIteration = 1000;
% D = 2;
% alt = -30;
% ust = 30;
% pso_pro_func(funcName, popSize, maxIteration, D, alt, ust);