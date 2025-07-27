 %Sine映射
 function [x] = SineMap(Max_iter)
 x(1)=rand; %初始点
for i=1:Max_iter-1
     x(i+1) = sin(pi*x(i));
end
 end
