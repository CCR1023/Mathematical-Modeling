%% ��8�� ��Ⱥ�㷨��Matlabʵ�֡���TSP����
% ����8-1
%--------------------------------------------------------------------------
%% ����׼��
% ��ջ�������
clear all
clc

% �������м�ʱ��ʼ
t0 = clock;

%��������
citys=xlsread('Chap9_citys_data.xlsx', 'B2:C53');
%--------------------------------------------------------------------------
%% ������м��໥����
n = size(citys,1);
x1 = citys(:,1)*ones(1,n);
deltax = (x1-x1').^2;
y1 = citys(:,2)*ones(1,n);
deltay = (y1-y1').^2;
D = sqrt(deltax+deltay);

%--------------------------------------------------------------------------
%% ��ʼ������
m = 75;                              % ��������
alpha = 1;                           % ��Ϣ����Ҫ�̶�����
beta = 5;                            % ����������Ҫ�̶�����
p                                                               = 0.2;                           % ��Ϣ�ػӷ�(volatilization)����
Q = 10;                               % ��ϵ��
Heu_F = 1./D;                        % ��������(heuristic function)  �����Ǿ���ĵ�����������Է���ľ���Խ��ѡ�иĵ�ĸ���Խ��
Tao = ones(n,n);                     % ��Ϣ�ؾ���
Paths = zeros(m,n);                  % ·����¼��
iter = 1;                            % ����������ֵ
iter_max = 100;                      % ����������
Route_best = zeros(iter_max,n);      % �������·��
Length_best = zeros(iter_max,1);     % �������·���ĳ���
Length_ave = zeros(iter_max,1);      % ����·����ƽ������
Limit_iter = 0;                      % ��������ʱ��������
%-------------------------------------------------------------------------
%% ����Ѱ�����·��
while iter <= iter_max
    % ��������������ϵ�������
    start = randi([1,n],1,m);
    Paths(:,1) = start;
    % ������ռ�
    citys_index = 1:n;
    % ȷ��ÿ�����ϵ�·��
    % �������·��ѡ��
    for i = 1:m
        % �������·��ѡ��
        for j = 2:n
            tabu = Paths(i,1:(j - 1));           % �ѷ��ʵĳ��м���(���ɱ�)
            allow_index = ~ismember(citys_index,tabu);    % �μ�˵��1������ײ���
            allow = citys_index(allow_index);  % �����ʵĳ��м���
            % �����м�ת�Ƹ���
            currentPos = tabu(end);           %��ǰ����λ��
            P = Tao(currentPos,allow).^alpha .* Heu_F(currentPos,allow).^beta;
            sumP = sum(P);
            P = P/sumP;
            % ���̶ķ�ѡ����һ�����ʳ���
            Pc = cumsum(P);     %�μ�˵��2(����ײ�)
            target_index = find(Pc >= rand);
            target = allow(target_index(1));
            Paths(i,j) = target;
        end
    end
    % ����������ϵ�·������
    Length = zeros(m,1);
    for i = 1:m
        Route = Paths(i,:);
        for j = 1:(n - 1)
            Length(i) = Length(i) + D(Route(j),Route(j + 1));
        end
        Length(i) = Length(i) + D(Route(n),Route(1));
    end
    % �������·�����뼰ƽ������
    if iter == 1
        [min_Length,min_index] = min(Length);
        Length_best(iter) = min_Length;
        Length_ave(iter) = mean(Length);
        Route_best(iter,:) = Paths(min_index,:);
        Limit_iter = 1;
        
    else
        [min_Length,min_index] = min(Length);
        Length_best(iter) = min(Length_best(iter - 1),min_Length);    % ��̬�滮˼��
        Length_ave(iter) = mean(Length);
        if Length_best(iter) == min_Length
            Route_best(iter,:) = Paths(min_index,:);
            Limit_iter = iter;
        else
            Route_best(iter,:) = Route_best((iter-1),:);
        end
    end
    % ������Ϣ��
    Delta_Tau = zeros(n,n);
    % ������ϼ���
    for i = 1:m
        % ������м���
        for j = 1:(n - 1)
            Delta_Tau(Paths(i,j),Paths(i,j+1)) = Delta_Tau(Paths(i,j),Paths(i,j+1)) + Q/Length(i);
        end
        Delta_Tau(Paths(i,n),Paths(i,1)) = Delta_Tau(Paths(i,n),Paths(i,1)) + Q/Length(i);
    end
    Tao = (1-p) * Tao + Delta_Tau;
    % ����������1�����·����¼��
    iter = iter + 1;
    Paths = zeros(m,n);
end
%--------------------------------------------------------------------------
%% �����ʾ
[Shortest_Length,index] = min(Length_best);
Shortest_Route = Route_best(index,:);
Time_Cost=etime(clock,t0);
disp(['��̾���:' num2str(Shortest_Length)]);
disp(['���·��:' num2str([Shortest_Route Shortest_Route(1)])]);
disp(['������������:' num2str(Limit_iter)]);
disp(['����ִ��ʱ��:' num2str(Time_Cost) '��']);
%--------------------------------------------------------------------------
%% ��ͼ
figure(1)
plot([citys(Shortest_Route,1);citys(Shortest_Route(1),1)],...  %����ʡ�Է�ΪMatlab���з�
    [citys(Shortest_Route,2);citys(Shortest_Route(1),2)],'o-');
grid on
for i = 1:size(citys,1)
    text(citys(i,1),citys(i,2),['   ' num2str(i)]);
end
text(citys(Shortest_Route(1),1),citys(Shortest_Route(1),2),'       ���');
text(citys(Shortest_Route(end),1),citys(Shortest_Route(end),2),'       �յ�');
xlabel('����λ�ú�����')
ylabel('����λ��������')
title(['ACA���Ż�·��(��̾���:' num2str(Shortest_Length) ')'])
figure(2)
plot(1:iter_max,Length_best,'b')
legend('��̾���')
xlabel('��������')
ylabel('����')
title('�㷨�����켣')
%--------------------------------------------------------------------------
%% ������ͻ�˵��
% 1. ismember�����ж�һ�������е�Ԫ���Ƿ�����һ�������г��֣�����0-1����
% 2. cumsum����������������ۼ�Ԫ�صĺͣ���A=[1, 2, 3, 4, 5], ��ôcumsum(A)=[1, 3, 6, 10, 15]��
