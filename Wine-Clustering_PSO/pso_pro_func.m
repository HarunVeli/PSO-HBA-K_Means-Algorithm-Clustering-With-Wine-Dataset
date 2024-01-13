function [gbest_obj, gbest_pos, convergence, best_clusters] = pso_pro_func(funcName, N, maxIterasyon, D, alt, ust)

% VERI OKUMA ISLEMI
% data = xlsread('IrisLastVersion.xlsx','Cluster');
load('data.mat');

best_clusters = zeros(1, 1599);

% N=10; % parcacik sayýsý,populasyon genisliði
c1=2; c2=2; %sosyal ve bilissel sabitler
inertiaMax = 0.9; %baslangictaki inertia degeri
inertiaMin = 0.4; %son iterasyondaki inertia degeri

particle=rand(N,D)*(ust-alt)+alt;
v=zeros(N,D); %hiz vektorunu olustur

convergence = zeros(1, maxIterasyon);

%parcaciklarin amac fonk degerleri hesaplandi
for i=1:N
%     ObjVal(i,1)=pso_pro_objfunc(particle(i, :)); % degerlerin alt alta gorunmesi icin (i,1) yaptik
    [ObjVal(i,1), clusters] = feval(funcName, particle(i, :), data);
end

% En iyi parcacigi bul ve ata
[gbest_obj, indis]=min(ObjVal);
gbest_pos=particle(indis, :);

% parcaciklarin ilk konumlarini en iyi olarak ata
pbest_obj=ObjVal;
pbest_pos=particle;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Iterasyonlari baslat

iter=1; %amac fonk hesapladigimiz anda iter 1 olmus olur
while iter<=maxIterasyon
    
    inertia = inertiaMax - ((inertiaMax - inertiaMin)/maxIterasyon)*iter;
    
    for i=1:N
        % i.parcacigin hiz vektorunu hesapla
        v(i,:)= inertia*v(i,:) + ... %inertia degeri eklendi yani basta buyuk adim sonra kucuk adim atacak
                c1*rand(1,D).*(pbest_pos(i,:) - particle(i,:)) + ...
                c2*rand(1,D).*(gbest_pos - particle(i,:));
        
        %hýz sinir asimi kontrolu yap (astigi sinira yaklastirilir)
%         v(i,:)=min(v(i,:), ust); %ust sinir kontrolu
%         v(i,:)=max(v(i,:), alt); %alt sinir kontrolu
        % hiz vektoruu ekleyerek i.parcacigin konumunu guncelle
        particle(i,:) = particle(i,:) + v(i,:);
        %particle sinir asimi kontrolu
        particle(i,:)=min(particle(i,:), ust); %ust sinir kontrolu
        particle(i,:)=max(particle(i,:), alt); %alt sinir kontrolu
%         ObjVal(i,1)=pso_pro_objfunc(particle(i, :)); % degerlerin alt alta gorunmesi icin (i,1) yaptik
        [ObjVal(i,1), clusters] = feval(funcName, particle(i, :), data);
        
        %Hafizadaki konumdan daha iyi mi kontrol et
        if ObjVal(i,1)<pbest_obj(i)
            pbest_obj(i)=ObjVal(i,1);
            pbest_pos(i,:)=particle(i,:);
            
        end
    end % N
    
    %gbesti kontrol et
    [obj, indis]=min(pbest_obj);
    if obj < gbest_obj
        gbest_obj=obj;
        gbest_pos=pbest_pos(indis,:); 
        best_clusters = clusters;
    end
    
    
%     fprintf('Iter:%d  Obj:%d',num2str(iter), num2str(gbest_obj));
%     for j=1:66
%     fprintf('   %d-> %d',j, num2str(gbest_pos(j)));
%     end
%     fprintf('\n');
%     
    display(['Iter:', num2str(iter),...
        '  Obj:', num2str(gbest_obj)
%         ,...
%         '  1->', num2str(gbest_pos(1)),...
%         '  2->', num2str(gbest_pos(2)),...
%         '  3->', num2str(gbest_pos(3)),...
%         '  4->', num2str(gbest_pos(4)),...
%         '  5->', num2str(gbest_pos(5)),...
%         '  6->', num2str(gbest_pos(6)),...
%         '  7->', num2str(gbest_pos(7)),...
%         '  8->', num2str(gbest_pos(8)),...
%         '  9->', num2str(gbest_pos(9)),...
%         '  10->', num2str(gbest_pos(10)),...
%         '  11->', num2str(gbest_pos(11)),...
%         '  12->', num2str(gbest_pos(12)),...
        ]);
    
    convergence(iter) = gbest_obj; %yakinsama egrisi
    
    
%     % parcaciklarin konumlarini gosterir
%     plot(particle(:, 1), particle(:, 2), 'ro') % red ve yuvarlak göstersin
%     xlabel('1. karar degiskeni x');
%     ylabel('2. karar degiskeni y');
%     title(strcat('Iterasyon:', int2str(iter), '   GlobalMin: ', num2str(gbest_obj)));
%     
%     hold on; % eklenenleri üzerinde tut
%     plot(alt, ust, 'go'); %alt ve ust sinirlar belirlendi
%     hold on;
%     plot(ust, alt, 'bo');
%     
%     hold on;
%     plot(gbest_pos(1), gbest_pos(2), 'b*');
%     
%     pause(0.1);
%     
%     hold off; %iterasyon sonunda ekrandakileri býrak
    
    iter=iter+1; 
end % maxIter




