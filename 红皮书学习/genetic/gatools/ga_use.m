% matlab�Ŵ��㷨����ʹ��
%ѧϰ������⡡f = x*sin(y)+y*sin(x) ��x,y����0-10֮������ֵ

% ga,gaoptimsetΪ���ĺ���
%ʹ�ù����䣬�ܹ�����������Ϊ��Ӧ�Ⱥ�������Ҳ������ƽ�����õ�������
%��ȻҲ���Խ���һЩ�ε��趨��������趨����ʹ���������ȷҲ����
clear;close;clc;
tic
% step1 �����Ŵ��㷨��һЩ����
ops = gaoptimset('Generations',1000,'StallGenLimit',300,'PlotFcns',@gaplotbestf);
% setp2 ���м���
% final_pop��������һ�ο�ʼ�ĳ�ʼ����Ⱥ���������ظ�����
% final_pop �������´ε�����ʹ����gaoptimset,'InitialPopulation'����,����ɼ�p91
[x,fval,reason,output,final_pop] = ga(@fitness,2,ops);
toc