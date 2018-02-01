function [ classfication ] = SVM2_2( train,test )
%ʹ��matlab�Դ��Ĺ��ڻ������ݽ��ж�����ʵ�飨150*4�������У�ÿһ�д���һ�仨��
%����150�У���)��ÿһ�����4������ֵ������������4�С���ÿ1-50��51-100��101-150�е�����Ϊͬһ�࣬�ֱ�Ϊsetosa������࣬versicolor��֥�࣬virginica������
%ʵ����Ϊ��ʹ��svmtrain��ֻ������������⣩��ˣ������ݷ�Ϊ���࣬51-100Ϊһ�࣬1-50��101-150��Ϊһ��
%ʵ����ѡ��2������ֵ����ѡ��ȫ���ĸ�����ֵ������ѵ��ģ�ͣ����Ƚ���������ͬ������·��ྫ�ȵ������

load fisheriris                       %�������ݰ�����meas��150*4���������ݣ�
                                      %��species��150*1 �������������ݣ�
meas=meas(:,1:4);                   %ѡȡ������ǰ100�У�ǰ2��
train=[(meas(51:90,:));(meas(101:140,:))]; %ѡȡ������ÿ���Ӧ��ǰ40����Ϊѵ������
test=[(meas(91:100,:));(meas(141:150,:))];%ѡȡ������ÿ���Ӧ�ĺ�10����Ϊ��������
group=[(species(51:90));(species(101:140))];%ѡȡ����ʶǰ40��������Ϊѵ������

%ʹ��ѵ�����ݣ�����SVMģ��ѵ��
svmModel = svmtrain(train,group,'kernel_function','rbf','showplot',true);
%ʹ�ò������ݣ����Է���Ч��
classfication = svmclassify(svmModel,test,'showplot',true);

%��ȷ�ķ������ΪgroupTest��ʵ����Ի�õķ������Ϊclassfication
groupTest=[(species(91:100));(species(141:150))]; 
%������ྫ��
count=0;
for i=(1:20)
   if strcmp(classfication(i),groupTest(i))
      count=count+1;
   end
end
fprintf('���ྫ��Ϊ��%f\n' ,count/20);

end