function solution = binary_code_new_solution(solution,num,d,restriction)
% �����Ʊ��룺����㷴ת+ͷβ����任�����½�
% ���룺��+����
% ����� �½�
% �����������ã�ֻ���ṩ˼·������Ӧ�ÿɼ�sa-01knapsack

%��������Ŷ�
tmp=ceil(rand.*num);
solution(1,tmp)=~solution(1,tmp);
p = 1;
%����Ƿ�����Լ��
while 1
    q=(solution*d <= restriction);
    if ~q
        p=~p;	%ʵ�ֽ�������תͷβ�ĵ�һ��1
        tmp=find(solution==1);
        if p
            solution(1,tmp(1))=0;    % ���0����1���������
        else
            solution(1,tmp(end))=0;
        end
    else
        break
    end
end
end
end