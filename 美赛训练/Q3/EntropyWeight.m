function weights = EntropyWeight(D,flag)
%% ��Ȩ����ָ��Ȩ��,RΪ�������,����Ȩ������weights

[rows,cols]=size(D);   % �������Ĵ�С,rowsΪ���������colsΪָ�����
R = zeros(size(D));
a=min(D);
b=max(D);
% ��һ��
for i=1:rows
    for j=1:cols
        if flag(j)==1
            R(i,j)=(D(i,j)-a(j))/(b(j)-a(j)); %����ָ�괦��
        else
            R(i,j)=(b(j)-D(i,j))/(b(j)-a(j));%����ָ�괦��
        end
    end
end
k=1/log(rows);         % ��k

f=zeros(rows,cols);    % ��ʼ��fij
sumBycols=sum(R,1);    % ��������ÿһ��֮��(���Ϊһ��1*cols��������)
% ����fij
for i=1:rows
    for j=1:cols
        f(i,j)=R(i,j)./sumBycols(1,j);
    end
end

lnfij=zeros(rows,cols);  % ��ʼ��lnfij
% ����lnfij
for i=1:rows
    for j=1:cols
        if f(i,j)==0
            lnfij(i,j)=0;
        else
            lnfij(i,j)=log(f(i,j));
        end
    end
end

Hj=-k*(sum(f.*lnfij,1)); % ������ֵHj
weights=(1-Hj)/(cols-sum(Hj));
end