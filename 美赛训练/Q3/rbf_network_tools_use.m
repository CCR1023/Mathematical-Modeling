%%��ջ�������
clc
clear
close all

%ԭʼ����
data = load('��������.txt');
target = data(:,end);
useLength = 200;
p=data(1:useLength,:);  %�������ݾ���
t=target(1:useLength,:);           %Ŀ�����ݾ���
p = p';
t = t';
% ����mapminmax���������ݽ��й�һ��
[pn,input_str] = mapminmax(p) ;
[tn,output_str] = mapminmax(t) ;


%%���罨����ѵ��
%���罨��������Ϊ[x1;x2]�����ΪF��spreadʹ��Ĭ��
net=newrb(pn,tn,10^-40,2);
%%�����Ч����֤
%��ԭ���ݻش�����������Ч��
ty=sim(net,pn);
ty = mapminmax('reverse',ty,output_str);
x = 1:length(t);
%%ʹ��ͼ����������Է����Ժ��������Ч��
plot(x,t(1,:),'r-o',x,ty(1,:),'b--+')

% Ԥ��
pnew= data(useLength+1:end,:);
pnew = pnew';
%��һ��
pnew = mapminmax('apply',pnew,input_str);
tnew = sim(net,pnew);
% ȥ��һ��
tnew = mapminmax('reverse',tnew,output_str)
figure;
plot(target(useLength+1:end,:));hold on;plot(tnew);

