
% �����������
clear;clc;
num = 5;            % �ܵ��������û�
s = 1;                 % ÿ���ܵ��ķ���̨����
mu = unifrnd(0.3,0.8,num,2);        % ��һ����Χ��������������
k = 10;        % ��ϸ����
T = 50; deltaT = 1;     %�۲�ʱ�估�۲���
A = zeros(3,1);
%% �����û��ܵ�����
% for i = 1:num
%     [gk,p,status,Q] = MMSkteam(s,k,mu(i,1),mu(i,2),T,deltaT);
%     theta = sdpvar(1,1);
%     logG =  0;
%     V = p.value;
%     type = p.type;
%     for j  = 1: length(p.value)
%         logG = logG+V(j)*exp(type(j)*theta);
%     end
%     target = gk*theta - logG;
%     ops = sdpsettings('verbose',0);
%     result = optimize([],-target,ops);
%     A(i) = exp( -T*value(target));
% end
% A = A./sum(A);
A =[
    0.2085
    0.2099
    0.2076
    0.1661
    0.2079];
%% �����������
N_yewu = 3; % ҵ������
N_bs = 3;   % ��վ����
B = 10^6;      % ����
W = B;          % �س���·
M = [4 2 0.5];  % ��ʹ�������
r = [20 15 10]; % �������Ҫ��
SINR = 1/(N_bs);
e = log2(1+SINR);
alpha= [20 15 10];
beta1 = 100;
beta2 = 2;
x = intvar(num,N_yewu,N_bs);
y = sdpvar(num,N_yewu,N_bs);
ekij = e*ones(num,N_yewu,N_bs);
a = ekij;
for i = 1:N_yewu
    a(:,i,:) = alpha(i)*a(:,i,:)*B-beta1*B-beta2*e*B;
end
R = x.*y*B*e;
t =x;
for i = 1:num
    t(i,:,:) = x(i,:,:)*A(i);
end
target = sum(sum(sum(t.*y.*a)));
% �����������
C = [];
% Լ��1
for k = 1:num
    for i = 1:N_yewu
        C = [
            C;
            sum(x(k,i,:)) == 1;
        ];
    end
end
% Լ��2
for j = 1:N_bs
    C = [C;sum(sum(x(:,:,j).*y(:,:,j)))];
end
% Լ��3
for j = 1:N_bs
    C = [
        C;
        sum(sum(x(:,:,j).*y(:,:,j).*R(:,:,j))) <= W;
        ];
end
% Լ��4
for k = 1:num
    for i = 1:N_yewu
        C = [
            C;
            sum(x(k,i,:).*y(k,i,:).*R(k,i,:)) >= r(i);
        ];
    end
end
% Լ��5
for i = 1:N_yewu
    C = [
        C;
        sum(sum(x(:,i,:).*y(:,i,:)*B)) >= M(i);
      ];
end
% ���
ops = sdpsettings('verbose',1,'debug',1,'solver','gurobi');
result = optimize(C,-target,ops)