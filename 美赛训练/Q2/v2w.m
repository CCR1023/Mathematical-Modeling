function w = v2w(v)
% ����ת���������ȼ� 
% v ����
% w ת�����ĵȼ�
a = load('wind power.txt');
for i = 1:size(a,1)
    if a(i,1) <= v && a(i,2) >= v
        w = a(i,3);
        return;
    end
end