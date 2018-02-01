%Bus Problem �����ű��㷨��ϰ���뵽��һ������
%% ��ʼ��
clear;clc;close;
% �������м�ʱ��ʼ
tic
% ע��������Ҫʹ��inf,�������������������⡣��Ȼ����ͨ������������������������
% inf = 1000;
% D = [
%     0 10 inf inf inf inf
%     0 0 50 80 inf inf
%     0 0 0 10 inf inf
%     0 0 0 0 50 10
%     0 0 0 0 0 inf
%     0 0 0 0 0 0
%     ];
% D = D+D';
D = load('dist2.txt');
% ����Floyd�㷨����Դ���·��
minD = Floyd(D);
%% ��Ⱥ�㷨
% ��ʼ������
n = size(D,1);
m = ceil(n*1.5);                              % ��������
alpha = 2;                           % ��Ϣ����Ҫ�̶�����
beta = 4;                            % ����������Ҫ�̶�����
p = 0.3;                           % ��Ϣ�ػӷ�(volatilization)����
Q = 10;                               % ��ϵ��
Heu_F = 1./D;                      % ��������(heuristic function)  �����Ǿ���ĵ�����������Է���ľ���Խ��ѡ�иĵ�ĸ���Խ��
Tao = ones(n-2,n-2);                     % ��Ϣ�ؾ���
Paths = zeros(m,n-2);                  % ·����¼��
iter = 1;                            % ����������ֵ
iter_max = 80;                      % ����������
Route_best = zeros(iter_max,n-2);      % �������·��
Length_best = zeros(iter_max,1);     % �������·���ĳ���
Length_ave = zeros(iter_max,1);      % ����·����ƽ������
Limit_iter = 0;                      % ��������ʱ��������
%-------------------------------------------------------------------------
%% ����Ѱ�����·��
while iter <= iter_max
    % ��������������ϵ�������
    start = randi([1,n-2],1,m);
    Paths(:,1) = start;
    % ������ռ�
    citys_index = 1:n-2;
    % ȷ��ÿ�����ϵ�·��
    % �������·��ѡ��
    for i = 1:m
        % �������·��ѡ��
        for j = 2:n-2
            tabu = Paths(i,1:(j - 1));           % �ѷ��ʵĳ��м���(���ɱ�)
            allow_index = ~ismember(citys_index,tabu);    % �μ�˵��1������ײ���
            allow = citys_index(allow_index);  % �����ʵĳ��м���
            % �����м�ת�Ƹ���
            currentPos = tabu(end);           %��ǰ����λ��
            P0 = Tao(currentPos,allow).^alpha .* Heu_F(currentPos,allow).^beta;
            sumP = sum(P0);
            P = P0/sumP;
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
        Route = Paths(i,:)+1;       % ��ԭ��ʵ·��
        for j = 1:(n - 3)
            Length(i) = Length(i) + minD(Route(j),Route(j + 1));
        end
        Length(i) = Length(i)+minD(1,Route(1))+minD(Route(end),n);
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
    Delta_Tau = zeros(n-2,n-2);
    
    % ������ϼ���
    for i = 1:m
        PerQ = Q/Length(i);
        % ������м���
        for j = 1:(n - 3)
            Delta_Tau(Paths(i,j),Paths(i,j+1)) = Delta_Tau(Paths(i,j),Paths(i,j+1)) + PerQ;
        end
    end
    Tao = (1-p) * Tao + Delta_Tau;
    % ����������1�����·����¼��
    iter = iter + 1;
    Paths = zeros(m,n-2);
end
%--------------------------------------------------------------------------
%% �����ʾ
[Shortest_Length,index] = min(Length_best);
Shortest_Route = Route_best(index,:);
disp(['��̾���:' num2str(Shortest_Length)]);
disp(['���·��:' num2str([1 Shortest_Route+1 n])]);
disp(['������������:' num2str(Limit_iter)]);
%% �����㷨��������
plot(1:iter_max,Length_best,'b')
toc