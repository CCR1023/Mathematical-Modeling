%�ӳ�������Ⱥѡ�����, �������ƴ洢Ϊselection.m
function seln=selection(population,cumsump);
%����Ⱥ��ѡ����������
for i=1:2
   r=rand;  %����һ�������
   prand=cumsump-r;
   t = find(prand >= 0);
   j=1;
   while prand(j)<0
       j=j+1;
   end
   seln(i)=t(1); %ѡ�и�������
end
