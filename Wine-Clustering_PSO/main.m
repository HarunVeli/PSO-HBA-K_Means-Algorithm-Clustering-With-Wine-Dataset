% derste yapýlan kod

clc;
clear all;

funcName = 'calcCluster';
popSize = 50; 
maxIteration = 100;
D = 33; % 33 deðer üretilir 6 küme 11 er nitelikten hangi kümeye daha yakýn olduðu bulunmaya çalýþýlýr
alt = 0;
ust = 100;

run = 30;
totalRandIndex = 0;

load('data.mat');
for i=1:run
    
    [obj(i, 1), pos(i, :), cnvg(i, :), clusters(:, i)] = pso_pro_func(funcName, popSize, maxIteration, D, alt, ust);
    totalRandIndex = totalRandIndex + kFoldCrossValidation(clusters(:, i), data);
end

totalRandIndex = totalRandIndex / run;
fprintf('RandIndex deðeri->%f \n',totalRandIndex);





%% Kfold Çapraz Doðrulama
function finalRandIndex = kFoldCrossValidation(clusters, data)

    finalRandIndex = 0;
    realClusters(:, 1) = data(:, 12);
    realClusters(:, 2) = clusters;

    % RandIndex hesaplanýr
    finalRandIndex = finalRandIndex + calculateRandIndex(realClusters(:, 1), realClusters(:, 2));

end

%% RandIndex Hesaplama
function randIndex = calculateRandIndex(trueLabels, predictedLabels)
    % True Labels: Gerçek etiketler
    % Predicted Labels: Tahmin edilen etiketler

    % Verinin boyutu
    n = length(trueLabels);

    % Ayný kümede bulunan örnek sayýsý
    a = 0;
    for i = 1:n
        for j = i+1:n
            if trueLabels(i) == trueLabels(j) && predictedLabels(i) == predictedLabels(j)
                a = a + 1;
            end
        end
    end

    % Farklý kümede bulunan örnek sayýsý
    b = 0;
    for i = 1:n
        for j = i+1:n
            if trueLabels(i) ~= trueLabels(j) && predictedLabels(i) ~= predictedLabels(j)
                b = b + 1;
            end
        end
    end

    % Rand Index hesapla
    randIndex = (a + b) / nchoosek(n, 2);
end