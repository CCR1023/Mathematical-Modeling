clc;
close ;
clear ;
% ԭʼ����-���ݰ汾1.0

%ԭʼ����
data = load('��������.txt');
target = data(:,end);
useLength = 300;
index = randperm(size(data,1),useLength);
p=data(index,:);  %�������ݾ���
t=target(index,:);           %Ŀ�����ݾ���
p = p';
t = t';
% ����mapminmax���������ݽ��й�һ��
[pn,input_str] = mapminmax(p) ;
[tn,output_str] = mapminmax(t) ;

% ����BP�����磬��Ծ�һ���MATLAB�汾���°汾 newff ����ʹ�ø����һЩ
% ���Ǳ��ʺ�����û������
net=newff(pn,tn,[size(p,1) 10 size(t,1)],{'purelin','logsig','purelin'});
% 10�ֻ���ʾһ�ν��
net.trainParam.show=10;
% ѧϰ�ٶ�Ϊ0.05
net.trainParam.lr=0.045;
% ���ѵ������Ϊ5000��
net.trainParam.epochs=3000;
% �������
net.trainParam.goal=0.65*10^(-3);
% ��������������6�ε�����û�б仯��ѵ�������Զ���ֹ��ϵͳĬ�ϵģ�
% Ϊ���ó���������У�����������ȡ����������
net.divideFcn = '';
% ��ʼѵ��������pn,tn�ֱ�Ϊ�����������
net=train(net,pn,tn);
% ����ѵ���õ����磬����ԭʼ���ݶ�BP�������
an=sim(net,pn);

% ���ú���mapminmax�ѷ���õ������ݻ�ԭΪԭʼ��������
% �°汾�Ƽ�ѵ��������һ���ͷ���һ����ʹ�� mapminmax ����
a = mapminmax('reverse',an,output_str);

% ���
subplot(211);
plot(target(index));hold on;plot(a);title('ʵ�������ͷ�������');
legend('ʵ��','����');

% ��������
% index = randperm(useLength,50);
all = 1:size(data,1);
index = ~ismember(all,index);
testData = data(index,:);
testGroup = target(index,:);
testData = testData';
testGroup = testGroup';

% ��һ������
ptn = mapminmax('apply',testData,input_str);
tts = sim(net,ptn);
% ����һ��
ttd = mapminmax('reverse',tts,output_str);
subplot(212);
plot(testGroup);hold on;
plot(ttd);title('ʵ�������ͷ�������');
legend('ʵ��','����');

temp = (abs(ttd-testGroup)./testGroup)'
temp(temp == inf) = []
mean(temp)
