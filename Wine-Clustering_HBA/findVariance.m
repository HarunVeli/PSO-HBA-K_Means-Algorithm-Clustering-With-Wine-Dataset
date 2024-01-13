% function [variance] = findVariance()
% % VERI OKUMA ISLEMI
% % data = xlsread('SupermarketSalesDataSet','Sayfa1');
% load('possum.mat');
% dataLength = length(possum);
% totalError = 0;
% meanRealObject = mean(possum(:,12));
% 
%     for i=1:dataLength
%         realObj = possum(i,12);
%         
%         difference = realObj - meanRealObject;
%         objectValue(i, 1) = difference * difference;
%         totalError = totalError + objectValue(i, 1);
%         
%     end
% 
%     variance = totalError;
% end

function [variance] = findVariance()
% VERI OKUMA ISLEMI
% data = xlsread('SupermarketSalesDataSet','Sayfa1');
load('wineData.mat');
dataLength = length(wineData);
totalError = 0;
meanRealObject = mean(wineData(:,12));

    for i=1:dataLength
        realObj = wineData(i,12);
        
        difference = realObj - meanRealObject;
        objectValue(i, 1) = difference * difference;
        totalError = totalError + objectValue(i, 1);
        
    end

    variance = totalError;
end

