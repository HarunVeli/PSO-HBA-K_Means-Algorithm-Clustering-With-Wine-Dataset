%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Honey Badger Algorithm source code 
%  paper:
%     Hashim, Fatma A., Essam H. Houssein, Kashif Hussain, Mai S. %     Mabrouk, Walid Al-Atabany. 
%     "Honey Badger Algorithm: New Metaheuristic Algorithm for %  %     Solving Optimization Problems." 
%     Mathematics and Computers in Simulation, 2021.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%

clc;clear all;
close all;
fitfun = @wineFunc;%@possumFunc;
dim=33;
T=100;
Lb=0;
Ub=100;
N=50;
run = 1;
totalRandIndex= 0;
% [xmin,fmin,CNVG, clusters]=HBA(fitfun,dim,Lb,Ub,T,N);
% figure,
% semilogy(CNVG,'r')
% xlim([0 T]);
% title('Convergence curve')
% xlabel('Iteration');
% ylabel('Best fitness obtained so far');
% legend('HBA')

% display(['The best location= ', num2str(xmin)]);
% display(['The best fitness score = ', num2str(fmin)]);

% guessObject = sumsqu(xmin);   
% guessObject = guessObject';

%% 

% load('wineData.mat');

% randIndex = kFoldCrossValidation(clusters, wineData);

% display(['RanIndex= ', num2str(randIndex)]);

load('wineData.mat');
for i=1:run
    
    [xmin,fmin,CNVG, clusters]=HBA(fitfun,dim,Lb,Ub,T,N);
    totalRandIndex = totalRandIndex + kFoldCrossValidation(clusters, wineData);
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
