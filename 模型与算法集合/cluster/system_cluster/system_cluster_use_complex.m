x1=randn(10,1);  
x2=randn(10,1)+10;  
x3=randn(10,1)+20;  
X=[x1;x2;x3];  
Y=randn(30,1);  

X2=zscore(X); %��׼������  
Y2=pdist(X2); %�������  
% Step2 �������֮�������  
Z2=linkage(Y2);  
% Step3 ���۾�����Ϣ  
C2=cophenet(Z2,Y2); %0.94698  
% Step4 �������࣬��������ϵͼ  
T=cluster(Z2,6);  
H=dendrogram(Z2);  
