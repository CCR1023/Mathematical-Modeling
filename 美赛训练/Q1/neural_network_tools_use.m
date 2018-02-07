clc;
close ;
clear ;
% ԭʼ����-���ݰ汾1.0
% data = load('raw_data.txt');
% ����Ԥ�������·ݷֿ�
% [row,col] = size(data);
% temp_data = [];
% for i = 1:12
%     index = find(data(:,3) == i);
%     temp_data =[temp_data;data(index,:)];
% end
% data(:,1:8) = [];
% target = data(:,end);
% target(target ~= 0) = 1;
% data(:,end) = [];
% data = PCA(data,0.9);

% ԭʼ����-���ô�����
data = load('canada_datas.txt');

target = data(:,end);
data(:,[1,5,6]) = [];
data(:,end) = [];
useLength = 150;

% �������ݾ���
p=data(1:useLength,:)';
% Ŀ�����ݾ���
t  = target(1:useLength,:)';
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
plot(target(1:useLength));hold on;plot(a);title('Actual sample and simulation sample');
legend('Actual','simulation');

% ��������
% index = randperm(useLength,50);
index = useLength+1:size(data,1);
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
subplot(212);
plot(testGroup);hold on;
plot(ttd);title('Actual sample and simulation sample');
legend('Actual','simulation');

mean(abs(ttd-testGroup)./testGroup)
