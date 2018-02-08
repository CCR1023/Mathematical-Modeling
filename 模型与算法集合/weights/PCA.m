% �������ݵ÷֣�Ҳ�ɼ���ָ��Ȩ�أ���ȡ��������ֵ����Ӧ������������
function data = PCA(raw_data,T)
% raw_data ԭʼ����
% T ������
% data ������
% ��ȡ����
A = raw_data;
% ���ݱ�׼��
[a,b] = size(A);
% ���ݰ��н��з���
SA = zeros(a,b);
for i=1:b
    SA(:,i)=(A(:,i)-mean(A(:,i)))/std(A(:,i));  %��һ��
end

% ������ϵ��
CM=corrcoef(SA);
% ��������ֵ����������
% V����������D����ֵ
[V, D]=eig(CM);
% ��ȡ����ֵ�����㹱���ʺ��ۼƹ�����
DS = zeros(b,3);
DS(:,1) = diag(D);
% ��ת����Ϊ����������ֵΪ��С����
DS = sortrows(DS,-1);
DS(:,2) = DS(:,1)./sum(DS(:,1));
DS(:,3) = cumsum(DS(:,2));

index = find(DS(:,3) >= T);
Com_num = index(1) ;

% ��ȡ���ɷֶ�Ӧ����������
PV = V(:,end:-1:end-Com_num+1);
% ���������ɷֵ÷�
data=SA*PV;
















