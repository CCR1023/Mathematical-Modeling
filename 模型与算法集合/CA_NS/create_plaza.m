function [plaza,v]=create_plaza(B,plazalength)

plaza=zeros(plazalength,B+2);
v=zeros(plazalength,B+2); 
plaza(1:plazalength,[1,2+B])=-1;

% plaza = zeros(B+2,plaza);   %��ʼ��Ԫ������
% v = zeros(B+2,plazalength); % ��ʼ���ٶ�
% plaza([1,2+B],1:plazalength) = -1;


