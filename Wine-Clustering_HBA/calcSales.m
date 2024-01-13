function [obj] = calcSales(pos)

load('possum.mat');
dataLength = length(possum);
totalError = 0;
% for i=1:dataLength
%     objectValue(i, 1) = (possum(i,6) - a*possum(i,2)+b*possum(i,3)+c*possum(i,4)+d*possum(i,5)+e) * ...
%         (possum(i,6) - a*possum(i,2)+b*possum(i,3)+c*possum(i,4)+d*possum(i,5)+e);
% end
% 
% obj = mean(objectValue);


    for i=1:dataLength
        realObj = possum(i,12);
        guessObj = pos(1)*possum(i,1)+...
            pos(2)*possum(i,2)+...
            pos(3)*possum(i,3)+...
            pos(4)*possum(i,4)+...
            pos(5)*possum(i,5)+...
            pos(6)*possum(i,6)+...
            pos(7)*possum(i,7)+...
            pos(8)*possum(i,8)+...
            pos(9)*possum(i,9)+...
            pos(10)*possum(i,10)+...
            pos(11)*possum(i,11)+...
            pos(12);
        
        difference = realObj - guessObj;
        objectValue(i, 1) = difference * difference;
        totalError = totalError + objectValue(i, 1);
        
    end

    obj = totalError;

end

% function [obj] = pso_pro_objfunc(pos)
% 
%     a = pos(1);
%     b = pos(2);
%     c = pos(3);
%     d = pos(4);
%     e = pos(5);
%     
%     % döngüyle tüm deðerler gezilip aðýrlýk deðerleriyle gereli hesaplamalar yapýlýp ortalamasý alýnýp geri gönderilecek
%     % gerçekle tamin ettiðim deðer arasýndaki farký alýp karelerinide alýp onlarýn hepsini
%     % toplayýp ortalamasýný alýnca toplan hatayý bulmuþ olacaksýn
%     obj = (x-3.16)^2 + (y+7.98)^2 + 5;
% 
% end

