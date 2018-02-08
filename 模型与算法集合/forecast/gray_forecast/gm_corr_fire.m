clc;
close;
clear all;
% ��������������
format short;
% ԭʼ����
x= load('raw_data.txt');
x(:,1:4) = [];
n1=size(x,2);
% ���ݱ�׼������
for i = 1:n1
    x(:,i) = x(:,i)./x(:,1);
end
% �����м���������ʡ�Դ˲�����ԭʼ���ݸ������data
data=x;
% ����ο����У�ĸ���أ�
consult=data(:,end);
m1=size(consult,2);
% ����Ƚ����У������أ�
compare=data(:,1:end-1);
m2=size(compare,2);
for i=1:m1
    for j=1:m2
        t(:,j)=compare(:,j)-consult(:,i);
    end
    min_min=min(min(abs(t)));
    max_max=max(max(abs(t)));
    % ͨ���ֱ��ʶ���ȡ0.5
    resolution=0.5;
    % �������ϵ��
    coefficient=(min_min+resolution*max_max)./(abs(t)+resolution*max_max);
    % ���������
    corr_degree=sum(coefficient)/size(coefficient,1);
    r(:,i)=corr_degree;
end

r
