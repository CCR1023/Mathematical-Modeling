function dist=Floyd(a)
% ���룺a���ڽӾ���(aij)��ָi ��j ֮��ľ��룬�����������
% �����dist�����·�ľ��룻
n=size(a,1);
for k=1:n
    for i=1:n
        for j=1:n
            if a(i,j)>a(i,k)+a(k,j)
                a(i,j)=a(i,k)+a(k,j);
            end
        end
    end
end
dist=a;

