%MIV code
%����������www.nnetinfo.com
%������ּ���ڽ�ѧ,�����ѧϰ�����������MIV�㷨�������������������
clc;clear;
data = load('canada_datas.txt');
target = data(:,end);
data(:,5:(end-1)) = [];
data(:,end) = [];

inputData  = data'; %��x1,x2��Ϊ��������

outputData = target';       %��y��Ϊ�������

%ʹ��������������ݣ�inputData��outputData���������磬
net = newrb(inputData, outputData,0.01, 2);    %��X��Y������������磬Ŀ�����Ϊ0.01���������spread=2
%===================ʹ��BPѵ������==========================
% net= newff(inputData,outputData,4,{'tansig','purelin'},'trainlm');
% net.divideParam.trainRatio =1;  %�������ݵ���٣�������ȫ����ѵ��
% net.divideParam.valRatio =0;
% net.divideParam.testRatio =0;
% net= train(net,inputData,outputData);
%===================ʹ��BPѵ������==========================
simout = sim(net,inputData); %����matlab�����繤�����Դ���sim�����õ������Ԥ��ֵ

figure;  %�½���ͼ���ڴ���
t=1:length(simout);
plot(t,outputData,'b',t,simout,'r')%��ͼ���Ա�ԭ����y������Ԥ���y

inputLen = size( inputData,1); %
delta    = zeros(1,inputLen);

for i = 1 : inputLen
    inputData1 = inputData;
    inputData1(i,:) = inputData1(i,:)*0.9; %�Ե�i���������10%
    
    inputData2 = inputData;
    inputData2(i,:) = inputData2(i,:)*1.1; %�Ե�i����������10%
    
    %��������������������������
    dd{i} = ( sim(net, inputData2) - sim(net, inputData1));
    delta(i) = mean(dd{i});
    disp(['����',num2str(i),'��Ӱ��ֵ �� ',num2str(delta(i))])
end

% ===���´��빩�о�ʹ�ã���MIV�㷨�޹ء�=====================================
% ===����Ĵ������ڻ滭������x1,x2�ϵ����Ч����
% ==���Կ�����x1���ǲ����ģ�����x2����ƽ���ģ�������X1�ϵĲ���������������������
% w1 = linspace(min(x1),max(x1),50);
% w2 = linspace(min(x2),max(x2),50);
% 
% [X1,X2]=meshgrid(w1,w2);
% [m,n] = size(X1);
% v = zeros(m,n);
% for  i = 1 : m
%     for j = 1 : n
%         v (i,j)=   sim(net,[X1(i,j);X2(i,j)]);
%     end
% end
% figure(2)
% surf(X1,X2,v)
% ===============================================================