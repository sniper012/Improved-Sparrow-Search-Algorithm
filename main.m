%_________________________________________________________________________%
% 融合柯西变异和反向学习的改进麻雀算法          %
%_________________________________________________________________________%
clear  
clc
close all
% rng('default');
SearchAgents_no=10; % Number of search agents 种群数量

Function_name='F1'; % Name of the test function that can be from F1 to F23 (Table 1,2,3 in the paper) 设定适应度函数

Max_iteration=1000; % Maximum numbef of iterations 设定最大迭代次数

% Load details of the selected benchmark function
[lb,ub,dim,fobj]=Get_Functions_details(Function_name);  %设定边界以及优化函数
%原始麻雀算法

[Best_pos,Best_score,SSA_curve]=SSA(SearchAgents_no,Max_iteration,lb,ub,dim,fobj); %开始优化

%融合柯西变异和反向学习的改进麻雀算法%

[Best_pos1,Best_score1,SSA_curve1]=SSANew(SearchAgents_no,Max_iteration,lb,ub,dim,fobj); %开始优化

%% 结果对比
figure('Position',[269   240   660   290])
%Draw search space
subplot(1,2,1);
func_plot(Function_name);
title('Parameter space')
xlabel('x_1');
ylabel('x_2');
zlabel([Function_name,'( x_1 , x_2 )'])

%Draw objective space
subplot(1,2,2);
semilogx(SSA_curve,'Color','b','linewidth',1.5)
hold on
semilogx(SSA_curve1,'Color','r','linewidth',1.5)
title('Objective space')
xlabel('Iteration');
ylabel('Best score obtained so far');

axis tight
grid on
box on
legend('SSA','ISSA')

display(['The best solution obtained by SSA is : ', num2str(Best_pos)]);
display(['The best optimal value of the objective funciton found by SSA is : ', num2str(Best_score)]);


display(['The best solution obtained by ISSA is : ', num2str(Best_pos1)]);
display(['The best optimal value of the objective funciton found by ISSA is : ', num2str(Best_score1)]);
        


%% 对比10次
% runtime=10;
% f1=[];
% for i=1:runtime
% [Best_pos,Best_score,SSA_curve]=SSA(SearchAgents_no,Max_iteration,lb,ub,dim,fobj); %开始优化
% f1=[f1 Best_score];
% end
% %融合柯西变异和反向学习的改进麻雀算法%
% f2=[];
% for i=1:runtime
% [Best_pos1,Best_score1,SSA_curve1]=SSANew(SearchAgents_no,Max_iteration,lb,ub,dim,fobj); %开始优化
% f2=[f2 Best_score];
% end
% mean(f1)
% mean(f2)
