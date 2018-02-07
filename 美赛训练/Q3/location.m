% ����������з�������
clear;clc;close all;
data = load('��������.txt');
area = data(:,end);
record = zeros(9,9);
count = zeros(9,9);

for i = 1:size(data,1)
    xy = data(i,1:2);
    record(xy(1),xy(2))  = record(xy(1),xy(2))+data(i,end);
    if data(i,end) ~= 0
        count(xy(1),xy(2)) = count(xy(1),xy(2))+1;
    end
end
final = record./count;
[X,Y] = meshgrid(1:9);
figure;
temp = final;
final(isnan(final)) = 0;
contourf(Y,X,final);title('ƽ��ȼ�����');

figure;
contourf(Y,X,count);title('ȼ�մ���');


