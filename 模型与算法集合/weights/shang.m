function w = shang(x,standard,flag)
% x ���߾���
% standard �Ƿ��Ѿ�����
% flag �ж�����
%cols�����б�ʾ����ָ��
%��rows��ʾ��ѡ�񷽰�

a=min(x);
b=max(x);
[rows,cols]=size(x);
if (nargin == 2 && standard == 0)
    flag = ones(1,cols);
end

k=1/log(rows);

%��׼��ָ��
if(standard == 0)
    for i=1:rows
        for j=1:cols
            if flag(j)==1
                x(i,j)=(x(i,j)-a(j))/(b(j)-a(j)); %����ָ�괦��
            else
                x(i,j)=(b(j)-x(i,j))/(b(j)-a(j));%����ָ�괦��
            end
        end
    end
end

he=sum(x); %�����׼�������ÿһ�еĺͣ������i����ѡ������j��ָ���ֵ��ռ�ĸ���
for i=1:rows
    for j=1:cols
        p(i,j)=x(i,j)/he(j);
    end
end
%ָ���һ��
for i=1:rows
    for j=1:cols
        if p(i,j)==0
            z(i,j)=0;
        else
            z(i,j)=log(p(i,j));
        end
    end
end

e=zeros(1,cols);
Q = p.*z;

for i = 1:cols
    e(i) = -k*sum(Q(:,i));
end

he=sum(e);
for i=1:cols
    w(i)=(1-e(i))/(cols-he);
end


