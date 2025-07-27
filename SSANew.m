%_________________________________________________________________________%
% 融合柯西变异和反向学习的改进麻雀算法%
%_________________________________________________________________________%
function [Best_pos,Best_score,curve]=SSANew(pop,Max_iter,lb,ub,dim,fobj)

ST = 0.6;%预警值
PD = 0.7;%发现者的比列，剩下的是加入者
SD = 0.2;%意识到有危险麻雀的比重

PDNumber = round(pop*PD); %发现者数量
SDNumber = round(SD*pop);%意识到有危险麻雀数量
if(max(size(ub)) == 1)
   ub = ub.*ones(1,dim);
   lb = lb.*ones(1,dim);  
end

%% 改进点1：利用sine混沌映射进行种群初始化
X0=initializationNew(pop,dim,ub,lb);
X = X0;
%计算初始适应度值
fitness = zeros(1,pop);
for i = 1:pop
   fitness(i) =  fobj(X(i,:));
end
 [fitness, index]= sort(fitness);%排序
BestF = fitness(1);
WorstF = fitness(end);
GBestF = fitness(1);%全局最优适应度值
for i = 1:pop
    X(i,:) = X0(index(i),:);
end
curve=zeros(1,Max_iter);
GBestX = X(1,:);%全局最优位置
X_new = X;
for i = 1: Max_iter
    
    BestF = fitness(1);
    WorstF = fitness(end);
    Pbest = X(1,:);
    PWorst = X(end,:);
    
    R2 = rand(1);
    %% 改进点2：动态自适应权重
    w = (exp(2*(1 - i/Max_iter)) - exp(-2*(1 - i/Max_iter)))/(exp(2*(1 - i/Max_iter)) + exp(-2*(1 - i/Max_iter)));%文献（8）式   
   for j = 1:PDNumber
      if(R2<ST)
          X_new(j,:) = X(j,:) + w.*(Pbest - X(j,:)).*rand(); %改进点文献式（9）
      else
          X_new(j,:) = X(j,:) + randn().*ones(1,dim);
      end     
   end
   for j = PDNumber+1:pop
%        if(j>(pop/2))
        if(j>(pop - PDNumber)/2 + PDNumber)
          X_new(j,:)= randn().*exp((X(end,:) - X(j,:))/j^2);
       else
          %产生-1，1的随机数
          A = ones(1,dim);
          for a = 1:dim
            if(rand()>0.5)
                A(a) = -1;
            end
          end 
          AA = A'*inv(A*A');     
          X_new(j,:)= X(1,:) + abs(X(j,:) - X(1,:)).*AA';
       end
   end
   Temp = randperm(pop);
   SDchooseIndex = Temp(1:SDNumber); 
   %% 改进点3：    改进的侦查预警麻雀更新公式
   for j = 1:SDNumber
       if(fitness(SDchooseIndex(j)) ~= BestF)
           X_new(SDchooseIndex(j),:) = Pbest + randn().*abs(X(SDchooseIndex(j),:) - Pbest);
       elseif(fitness(SDchooseIndex(j))== BestF)
           X_new(SDchooseIndex(j),:) = Pbest + randn().*(abs( PWorst- Pbest));
       end
   end
   %边界控制
   for j = 1:pop
       for a = 1: dim
           if(X_new(j,a)>ub)
               X_new(j,a) =ub(a);
           end
           if(X_new(j,a)<lb)
               X_new(j,a) =lb(a);
           end
       end
   end 
   %计算适应度值
   for j=1:pop
    fitness_new(j) = fobj(X_new(j,:));
   end
   X = X_new;
   fitness = fitness_new;
    %排序更新
   [fitness, index]= sort(fitness);%排序
   BestF = fitness(1);
   WorstF = fitness(end);
   for j = 1:pop
      X(j,:) = X(index(j),:);
   end
   %% 改进点4：利用反向学习和柯西变异改进最优麻雀
   Ps = -exp(1 - i/Max_iter)^20 + 0.05;%选择概率文献式（16）
   if(rand<Ps)
       b1 = (Max_iter - i/Max_iter)^i;%文献式（13）
       GbestBack = ub + rand().*(lb - X(1,:));
       GbestTemp = GbestBack + b1.*(X(1,:) - GbestBack);       
   else
       r = tan((rand() - 0.5)*pi);%柯西随机数
       GbestTemp = X(1,:) + r*X(1,:);
   end
   %边界检查
   GbestTemp(GbestTemp>ub)=ub(GbestTemp>ub);
   GbestTemp(GbestTemp<lb)=lb(GbestTemp<lb);
   if(fobj(GbestTemp)<fitness(1))
       X(1,:) = GbestTemp;
       fitness(1) = fobj(GbestTemp);
   end
   %更新全局最优
   if(fitness(1)<GBestF)
       GBestF = fitness(1);
       GBestX = X(1,:);
   end
   curve(i) = GBestF;
end
Best_pos =GBestX;
Best_score = curve(end);
end



