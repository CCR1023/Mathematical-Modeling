% ����ѭ������-P74
clear;clc;close all;
raw_data = load('table2.txt');
n = size(raw_data,2)+1;
data = zeros(n,n);
for i = 1:n-2
    for j = i+1:n-1
        data(i,j) = sum(raw_data(:,i) & raw_data(:,j));
    end
end
% ����
data = data'+data;
% ����tsp����
% ���߱���
x = binvar(n,n,'full');
u = sdpvar(1,n);
% Ŀ��
z = sum(sum(data.*x));
% Լ�����
C = [];
for j = 1:n
    C = [C,  sum(x(:,j))-x(j,j) == 1];
end
for i = 1:n
    C = [C, sum(x(i,:)) - x(i,i) == 1];
end
for i = 2:n
    for j = 2:n
        if i~=j
            C = [C,u(i)-u(j) + n*x(i,j)<=n-1];
        end
    end
end
% ��������
ops = sdpsettings('debug','1','solver','gurobi');
% ���
result  = optimize(C,z,ops);
if result.problem== 0
    value(z)
    x = value(x);
    visted = zeros(1,n);
    compare = ones(1,n);
    scan = 1;
    visted(scan) = 1;
    path = strcat(num2str(scan));
    while(~isequal(visted,compare))
        scan = find(x(scan,:) == 1);
        visted(scan) = 1;
         path = strcat(path,',',num2str(scan));
    end
    disp(path);
else
    disp('�������г���');
end