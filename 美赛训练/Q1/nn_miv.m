%% Matlab������43����������

% ���������ɸѡ������MIV�����������ɸѡ
% by ��С��(@��С��_matlab)
% http://www.matlabsky.com
% Email:sina363@163.com
% http://weibo.com/hgsz2003

%% ��ջ�������
clc
clear
%% �������� �������

% ����
data = load('isi_bui_datas.txt');
target = data(:,end);
% ȥ�����ñ���
data(:,end) = [];


%���������������ֵ
p=data;
t=target;
[p,input_str] = mapminmax(p);
[t,output_str] = mapminmax(t);
t =t';

%% ����ɸѡ MIV�㷨�ĳ���ʵ�֣����ӻ��߼����Ա�����


[m,n]=size(p);
yy_temp=p;

% p_increaseΪ����10%�ľ��� p_decreaseΪ����10%�ľ���
for i=1:n
    p=yy_temp;
    pX=p(:,i);
    pa=pX*1.1;
    p(:,i)=pa;
    aa=['p_increase'  int2str(i) '=p;'];
    eval(aa);
end


for i=1:n
    p=yy_temp;
    pX=p(:,i);
    pa=pX*0.9;
    p(:,i)=pa;
    aa=['p_decrease' int2str(i) '=p;'];
    eval(aa);
end


%% ����ԭʼ����ѵ��һ����ȷ��������
nntwarn off;
p=yy_temp;
p=p';
% bp���罨��
net=newff(minmax(p),[8,1],{'tansig','purelin'},'traingdm');
% ��ʼ��bp����
net=init(net);
% ����ѵ����������
net.trainParam.show=50;
net.trainParam.lr=0.05;
% net.trainParam.mc=0.9;
net.trainParam.epochs=2000;

% bp����ѵ��
net=train(net,p,t);


%% ����ɸѡ MIV�㷨�ĺ���ʵ�֣���ֵ���㣩

% ת�ú�sim

for i=1:n
    eval(['p_increase',num2str(i),'=transpose(p_increase',num2str(i),');'])
end

for i=1:n
    eval(['p_decrease',num2str(i),'=transpose(p_decrease',num2str(i),');'])
end


% result_inΪ����10%������ result_deΪ����10%������
for i=1:n
    eval(['result_in',num2str(i),'=sim(net,','p_increase',num2str(i),');'])
end

for i=1:n
    eval(['result_de',num2str(i),'=sim(net,','p_decrease',num2str(i),');'])
end

for i=1:n
    eval(['result_in',num2str(i),'=transpose(result_in',num2str(i),');'])
end

for i=1:n
    eval(['result_de',num2str(i),'=transpose(result_de',num2str(i),');'])
end

%% MIV��ֵΪ���������������MIVֵ MIV����Ϊ���������������۱�����ص����ָ��֮һ������Ŵ�����صķ��򣬾���ֵ��С����Ӱ��������Ҫ�ԡ�


for i=1:n
    IV= ['result_in',num2str(i), '-result_de',num2str(i)];
    eval(['MIV_',num2str(i) ,'=mean(',IV,')'])
end
