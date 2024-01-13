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
    % dim: Uzay�n boyutu
    % lb: Alt s�n�r vekt�r�
    % ub: �st s�n�r vekt�r�
    % tmax: Maksimum iterasyon say�s�
    % N: Pop�lasyon boyutu
    % Output:
    % Xprey: En iyi bireyin konumu
    % Food_Score: En iyi bireyin hedef fonksiyon de�eri
    % CNVG: Hedef fonksiyon de�erlerinin iterasyon boyunca de�i�imi
    % bestCluster: En iyi bireyin ait oldu�u k�me

    beta = 6; % Honey Badger'�n yiyece�i alabilme yetene�ini kontrol eden parametre (Eq.(4))
    C = 2; % Denklem (3)'teki sabit
    vec_flag = [1, -1]; % Rastgele vekt�r olu�turmak i�in bayraklar
    % Initialization
    X = initialization(N, dim, ub, lb);
    % Evaluation
    [fitness, clusters] = fun_calcobjfunc(objfunc, X);
    [GYbest, gbest] = min(fitness);
    bestCluster = clusters(:, gbest);
    Xprey = X(gbest,:);

    for t = 1:tmax
        % Zamanla, exp(-t/tmax) terimi nedeniyle yo�unluk fakt�r� d��er, 
        % bu da pop�lasyonun daha odakl� ve hassas bir arama yapmas�na yol a�ar.
        alpha = C * exp(-t / tmax); % Yo�unluk fakt�r� 
        % I, pop�lasyonun yo�unlu�unu g�sterir ve genellikle "Yo�unluk" olarak adland�r�l�r.
        I = Intensity(N, Xprey, X); % Yo�unluk 

        for i = 1:N
            % Rastgele kararlar almak i�in 0-1 aras� say� �retilir
            r = rand();
            % 1-3 aras� rastgele bir tam say� elde edilir.
            % 1 veya 2 olmas� durumuna g�re vec_flag rastgele se�im yapar
            % NOT->? bayra��n�n -1 olarak rasgele se�ilmesi durumunda Bal a�amas�na ge�ilmektedir. 
            % Bal Rehberi Ku� (Honey-Guide Bird) un yard�m�na ba�vurmas�n� ifade etmektedir.
            F = vec_flag(floor(2 * rand() + 1));

            for j = 1:dim
                di = Xprey(j) - X(i, j);

                if r < 0.5
                    r3 = rand; r4 = rand; r5 = rand;
                    % Kazma Faz� 
                    % Yeni konum hesaplama 
                    Xnew(i, j) = Xprey(j) + F * beta * I(i) * Xprey(j) + F * r3 * alpha * (di) * abs(cos(2 * pi * r4) * (1 - cos(2 * pi * r5)));
                else
                    r7 = rand;
                    % Bal Faz� 
                    % Yeni konum hesaplama 
                    % Bal Rehberi Ku� (Honey-Guide Bird) un yard�m�na ba�vurmas�n� ifade etmektedir.
                    Xnew(i, j) = Xprey(j) + F * r7 * alpha * di;
                end
            end
            
            % S�n�rlar� kontrol et ve g�ncelle
            FU = Xnew(i,:) > ub; FL = Xnew(i,:) < lb;
            Xnew(i,:) = (Xnew(i,:) .* (~(FU + FL))) + ub .* FU + lb .* FL;

            % Yeni konumun fitness de�erini hesapla
            [tempFitness, tempclusters] = fun_calcobjfunc(objfunc, Xnew(i,:));

            % E�er yeni konum daha iyi ise, g�ncelle
            if tempFitness < fitness(i)
                fitness(i) = tempFitness;
                clusters(:, i) = tempclusters;
                X(i,:) = Xnew(i,:);
            end
        end

        % S�n�rlar� kontrol et ve g�ncelle
        FU = X > ub; FL = X < lb;
        X = (X .* (~(FU + FL))) + ub .* FU + lb .* FL;

        % En iyi ��z�m� ve fitness de�erini g�ncelle
        [Ybest, index] = min(fitness);
        CNVG(t) = min(Ybest);

        if Ybest < GYbest
            GYbest = Ybest;
            bestCluster = clusters(:, index);
            Xprey = X(index,:);
        end

        display(['Iter:', num2str(t), '  Obj:', num2str(GYbest)]);
    end

    % En iyi fitness de�erini ata
    Food_Score = GYbest;
end

function [Y, clusters] = fun_calcobjfunc(func, X)
    % fun_calcobjfunc fonksiyonu, objfunc taraf�ndan tan�mlanan hedef fonksiyonu de�erlerini ve k�me bilgilerini hesaplar.
    N = size(X, 1);

    for i = 1:N
        [Y(i), clusters(:,i)] = func(X(i,:));
    end
end

function I = Intensity(N, Xprey, X)
    % N: Pop�lasyon boyutu
    % Xprey: HB (Honey Badger) konumu
    % X: Pop�lasyonun mevcut konumlar�
    % eps: K���k bir de�er, s�f�ra b�lme hatas� �nlemek i�in kullan�l�r

    % Yo�unluk vekt�r�n� hesaplamak i�in
    for i = 1:N-1
        % Her bir bireyin HB'ye olan uzakl���n� hesapla
        di(i) = (norm((X(i,:) - Xprey + eps))).^2;
        % Her iki birey aras�ndaki mesafeyi hesapla
        S(i) = (norm((X(i,:) - X(i+1,:) + eps))).^2;
    end

    % Son iki birey i�in ayn� hesaplar� yap
    di(N) = (norm((X(N,:) - Xprey + eps))).^2;
    S(N) = (norm((X(N,:) - X(1,:) + eps))).^2;

    % Yo�unluk vekt�r�n� hesaplamak i�in
    for i = 1:N
        % Rastgele bir say� �ret
        r2 = rand;
        % Yo�unluk form�l�ne g�re yo�unluk de�erini hesapla
        I(i) = r2 * S(i) / (4 * pi * di(i));
    end
end


function [X] = initialization(N, dim, up, down)
    % N: Pop�lasyon boyutu
    % dim: Her bir bireyin boyutu (parametre say�s�)
    % up: Yukar� s�n�r vekt�r�
    % down: A�a�� s�n�r vekt�r�

    % E�er yukar� s�n�r vekt�r� tek bir de�er i�eriyorsa
    if size(up, 2) == 1
        % Rastgele say�lardan olu�an bir matris olu�turun
        % Her bir eleman�, [down, up] aral���ndaki rastgele say�lar olsun
        X = rand(N, dim) .* (up - down) + down;
    end

    % E�er yukar� s�n�r vekt�r� birden fazla de�er i�eriyorsa
    if size(up, 2) > 1
        % Her bir parametre i�in
        for i = 1:dim
            % Y�ksek ve d���k s�n�rlar� al
            high = up(i); low = down(i);
            % Rastgele say�lardan olu�an bir s�tun vekt�r� olu�turun
            % Her bir eleman�, [low, high] aral���ndaki rastgele say�lar olsun
            X(:, i) = rand(N, 1) .* (high - low) + low;
        end
    end
end
