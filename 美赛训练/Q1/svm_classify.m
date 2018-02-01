% ����֧�����������з���
clear;clc;close;
% ���Ȳ�����PCA����
data = load('raw_data.txt');
data(:,1:8) = [];
target = data(:,end);
target(target ~= 0) = 1;
data(:,end) = [];
data = PCA(data,0.9);
% ����ѵ��
useDataLength = 400;
% ǰ400��������������ѵ��
trainData = data(1:useDataLength,:);
trainGroup = target(1:useDataLength,:);
SVMStruct = svmtrain(trainData,trainGroup,'kernel_function','linear');
% ��������
% index = randperm(size(data,1));
% testData = data(index,:);
% testGroup = target(index,:);
testData = data(useDataLength+1:end,:);
testGroup = target(useDataLength+1:end,:);

% �������
classification = svmclassify(SVMStruct,testData);
%������ྫ��
count=sum(classification == testGroup);
disp(count/length(testData));