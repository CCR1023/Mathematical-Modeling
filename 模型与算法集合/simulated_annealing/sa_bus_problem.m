%Bus Problem �����ű��㷨��ϰ���뵽��һ������
clear;clc;close;
tic
%% ��ʼ��
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
%% ģ���˻����
n = size(D,1);
amount = size(D,1)-2; % ��Ϊ����Ҫ������β
a = 0.99;	% �¶�˥�������Ĳ���
t0 = 100; tf = 3; t = t0;
Markov_length = 100*amount;	% Markov������
% ������ʼ��
sol_new = 2:2+amount-1;
% E_current�ǵ�ǰ���Ӧ�Ļ�·���룻
% E_new���½�Ļ�·���룻
% E_best�����Ž��
E_current = inf;E_best = inf;
% sol_new��ÿ�β������½⣻sol_current�ǵ�ǰ�⣻sol_best����ȴ�е���ý⣻
sol_current = sol_new; sol_best = sol_new;

while t>=tf  % �����ƽ���
    for r=1:Markov_length		% �ڲ���ƽ�
        % step1 ����Ŷ��������½�
        sol_new = natural_code_new_solution(sol_new,amount);
        % step2 ����Ŀ�꺯��ֵ�������ܣ�
        E_new = minD(1,sol_new(1))+minD(sol_new(end),n);
        for i = 1 :amount-1
            E_new = E_new + ...
                minD(sol_new(i),sol_new(i+1));
        end
        % step3 �Ƿ�����½�
        if E_new < E_current
            E_current = E_new;
            sol_current = sol_new;
            if E_new < E_best
                % ����ȴ��������õĽⱣ������
                E_best = E_new;
                sol_best = sol_new;
            end
        else
            % ���½��Ŀ�꺯��ֵС�ڵ�ǰ��ģ�
            % �����һ�����ʽ����½�
            if rand < exp(-(E_new-E_current)./t)
                E_current = E_new;
                sol_current = sol_new;
            else
                sol_new = sol_current;  % �����¶ȣ������¶�����
            end
        end
    end
    t=t.*a;		% ���Ʋ���t���¶ȣ�����Ϊԭ����a��
end
disp('����·��');
disp(num2str([1 sol_best n]));
disp('��̾���');
disp(E_best);
toc