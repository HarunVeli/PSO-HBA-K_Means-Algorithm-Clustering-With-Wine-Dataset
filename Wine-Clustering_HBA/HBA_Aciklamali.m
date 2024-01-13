%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Honey Badger Algorithm Kaynak Kodu
% Makale:
% Hashim, Fatma A., Essam H. Houssein, Kashif Hussain, Mai S.
% Mabrouk, Walid Al-Atabany.
% "Honey Badger Algorithm: New Metaheuristic Algorithm for
% Optimization Problems."
% Mathematics and Computers in Simulation, 2021.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
function [Xprey, Food_Score,CNVG, bestCluster] = HBA(objfunc, dim,lb,ub,tmax,N)
    % Input:
    % objfunc: Optimizasyon hedef fonksiyonu
    % dim: Uzayýn boyutu
    % lb: Alt sýnýr vektörü
    % ub: Üst sýnýr vektörü
    % tmax: Maksimum iterasyon sayýsý
    % N: Popülasyon boyutu
    % Output:
    % Xprey: En iyi bireyin konumu
    % Food_Score: En iyi bireyin hedef fonksiyon deðeri
    % CNVG: Hedef fonksiyon deðerlerinin iterasyon boyunca deðiþimi
    % bestCluster: En iyi bireyin ait olduðu küme

    beta = 6; % Honey Badger'ýn yiyeceði alabilme yeteneðini kontrol eden parametre (Eq.(4))
    C = 2; % Denklem (3)'teki sabit
    vec_flag = [1, -1]; % Rastgele vektör oluþturmak için bayraklar
    % Initialization
    X = initialization(N, dim, ub, lb);
    % Evaluation
    [fitness, clusters] = fun_calcobjfunc(objfunc, X);
    [GYbest, gbest] = min(fitness);
    bestCluster = clusters(:, gbest);
    Xprey = X(gbest,:);

    for t = 1:tmax
        % Zamanla, exp(-t/tmax) terimi nedeniyle yoðunluk faktörü düþer, 
        % bu da popülasyonun daha odaklý ve hassas bir arama yapmasýna yol açar.
        alpha = C * exp(-t / tmax); % Yoðunluk faktörü 
        % I, popülasyonun yoðunluðunu gösterir ve genellikle "Yoðunluk" olarak adlandýrýlýr.
        I = Intensity(N, Xprey, X); % Yoðunluk 

        for i = 1:N
            % Rastgele kararlar almak için 0-1 arasý sayý üretilir
            r = rand();
            % 1-3 arasý rastgele bir tam sayý elde edilir.
            % 1 veya 2 olmasý durumuna göre vec_flag rastgele seçim yapar
            % NOT->? bayraðýnýn -1 olarak rasgele seçilmesi durumunda Bal aþamasýna geçilmektedir. 
            % Bal Rehberi Kuþ (Honey-Guide Bird) un yardýmýna baþvurmasýný ifade etmektedir.
            F = vec_flag(floor(2 * rand() + 1));

            for j = 1:dim
                di = Xprey(j) - X(i, j);

                if r < 0.5
                    r3 = rand; r4 = rand; r5 = rand;
                    % Kazma Fazý 
                    % Yeni konum hesaplama 
                    Xnew(i, j) = Xprey(j) + F * beta * I(i) * Xprey(j) + F * r3 * alpha * (di) * abs(cos(2 * pi * r4) * (1 - cos(2 * pi * r5)));
                else
                    r7 = rand;
                    % Bal Fazý 
                    % Yeni konum hesaplama 
                    % Bal Rehberi Kuþ (Honey-Guide Bird) un yardýmýna baþvurmasýný ifade etmektedir.
                    Xnew(i, j) = Xprey(j) + F * r7 * alpha * di;
                end
            end
            
            % Sýnýrlarý kontrol et ve güncelle
            FU = Xnew(i,:) > ub; FL = Xnew(i,:) < lb;
            Xnew(i,:) = (Xnew(i,:) .* (~(FU + FL))) + ub .* FU + lb .* FL;

            % Yeni konumun fitness deðerini hesapla
            [tempFitness, tempclusters] = fun_calcobjfunc(objfunc, Xnew(i,:));

            % Eðer yeni konum daha iyi ise, güncelle
            if tempFitness < fitness(i)
                fitness(i) = tempFitness;
                clusters(:, i) = tempclusters;
                X(i,:) = Xnew(i,:);
            end
        end

        % Sýnýrlarý kontrol et ve güncelle
        FU = X > ub; FL = X < lb;
        X = (X .* (~(FU + FL))) + ub .* FU + lb .* FL;

        % En iyi çözümü ve fitness deðerini güncelle
        [Ybest, index] = min(fitness);
        CNVG(t) = min(Ybest);

        if Ybest < GYbest
            GYbest = Ybest;
            bestCluster = clusters(:, index);
            Xprey = X(index,:);
        end

        display(['Iter:', num2str(t), '  Obj:', num2str(GYbest)]);
    end

    % En iyi fitness deðerini ata
    Food_Score = GYbest;
end

function [Y, clusters] = fun_calcobjfunc(func, X)
    % fun_calcobjfunc fonksiyonu, objfunc tarafýndan tanýmlanan hedef fonksiyonu deðerlerini ve küme bilgilerini hesaplar.
    N = size(X, 1);

    for i = 1:N
        [Y(i), clusters(:,i)] = func(X(i,:));
    end
end

function I = Intensity(N, Xprey, X)
    % N: Popülasyon boyutu
    % Xprey: HB (Honey Badger) konumu
    % X: Popülasyonun mevcut konumlarý
    % eps: Küçük bir deðer, sýfýra bölme hatasý önlemek için kullanýlýr

    % Yoðunluk vektörünü hesaplamak için
    for i = 1:N-1
        % Her bir bireyin HB'ye olan uzaklýðýný hesapla
        di(i) = (norm((X(i,:) - Xprey + eps))).^2;
        % Her iki birey arasýndaki mesafeyi hesapla
        S(i) = (norm((X(i,:) - X(i+1,:) + eps))).^2;
    end

    % Son iki birey için ayný hesaplarý yap
    di(N) = (norm((X(N,:) - Xprey + eps))).^2;
    S(N) = (norm((X(N,:) - X(1,:) + eps))).^2;

    % Yoðunluk vektörünü hesaplamak için
    for i = 1:N
        % Rastgele bir sayý üret
        r2 = rand;
        % Yoðunluk formülüne göre yoðunluk deðerini hesapla
        I(i) = r2 * S(i) / (4 * pi * di(i));
    end
end


function [X] = initialization(N, dim, up, down)
    % N: Popülasyon boyutu
    % dim: Her bir bireyin boyutu (parametre sayýsý)
    % up: Yukarý sýnýr vektörü
    % down: Aþaðý sýnýr vektörü

    % Eðer yukarý sýnýr vektörü tek bir deðer içeriyorsa
    if size(up, 2) == 1
        % Rastgele sayýlardan oluþan bir matris oluþturun
        % Her bir elemaný, [down, up] aralýðýndaki rastgele sayýlar olsun
        X = rand(N, dim) .* (up - down) + down;
    end

    % Eðer yukarý sýnýr vektörü birden fazla deðer içeriyorsa
    if size(up, 2) > 1
        % Her bir parametre için
        for i = 1:dim
            % Yüksek ve düþük sýnýrlarý al
            high = up(i); low = down(i);
            % Rastgele sayýlardan oluþan bir sütun vektörü oluþturun
            % Her bir elemaný, [low, high] aralýðýndaki rastgele sayýlar olsun
            X(:, i) = rand(N, 1) .* (high - low) + low;
        end
    end
end
