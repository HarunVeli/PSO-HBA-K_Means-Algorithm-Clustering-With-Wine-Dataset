% derste yap�lan kod

clc;
clear all;

funcName = 'calcCluster';
popSize = 50; 
maxIteration = 100;
D = 33; % 33 de�er �retilir 6 k�me 11 er nitelikten hangi k�meye daha yak�n oldu�u bulunmaya �al���l�r
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
fprintf('RandIndex de�eri->%f \n',totalRandIndex);





%% Kfold �apraz Do�rulama
function finalRandIndex = kFoldCrossValidation(clusters, data)

    finalRandIndex = 0;
    realClusters(:, 1) = data(:, 12);
    realClusters(:, 2) = clusters;

    % RandIndex hesaplan�r
    finalRandIndex = finalRandIndex + calculateRandIndex(realClusters(:, 1), realClusters(:, 2));

end

%% RandIndex Hesaplama
function randIndex = calculateRandIndex(trueLabels, predictedLabels)
    % True Labels: Ger�ek etiketler
    % Predicted Labels: Tahmin edilen etiketler

    % Verinin boyutu
    n = length(trueLabels);

    % Ayn� k�mede bulunan �rnek say�s�
    a = 0;
    for i = 1:n
        for j = i+1:n
            if trueLabels(i) == trueLabels(j) && predictedLabels(i) == predictedLabels(j)
                a = a + 1;
            end
        end
    end

    % Farkl� k�mede bulunan �rnek say�s�
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