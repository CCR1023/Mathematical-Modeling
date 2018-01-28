clc;clear;
tic;
% step1 ��ʼ��
% ��������
NIND = 35;
% ����Ŵ�����
MAXGEN = 180;
% ������ά��
NVAR = 2;
% �����Ķ�����λ��
% ���½�
bounds=[
    -10 10
    -10 10
    ];
precision=0.0001; %���㾫��
PRECI=ceil(log2((bounds(:,2)-bounds(:,1)) ./ precision));
 %�������
PC =0.90;
% ����
% �����Ĵ�С�����������Ƶ��Ӵ��ĳ̶�
GGAP = 1;
% ׷��
trace = zeros(MAXGEN,1);

% step2 ��������������
FieldD = [
    PRECI'
    bounds'
    rep([1;0;1;1],[1,NVAR])
    ];

%step3 �滮��Ⱥ
Chrom = crtbp(NIND,sum(PRECI));
% ��������
gen = 0;
% �Ѷ������Ӵ����ʮ����
obj_x = bs2rv(Chrom,FieldD);
% ���������Ⱥ�����Ŀ�꺯��ֵ����������������
obj_fitness = fitness(obj_x(:,1),obj_x(:,2));
% ������Ⱥ
BestChrom = Chrom;
% ���Ž�
BestFval = obj_fitness(1);  % ��¼����ֵ
BestFitness = obj_fitness; %��¼����ֵ��Ӧ����Ⱥ������ָ

%step4 ��������
while gen < MAXGEN
    % ��Ⱥ���ƣ����Ȱ�����Ӧ�Ƚ������򣨵�ʵ���ϲ������򣩣����ص�ֵ��֤һ��Ϊ֤
    FitnV = ranking(obj_fitness);
    % ѡ�����
    SubChrom = select('sus',Chrom,FitnV,GGAP);
    % �������
    SubChrom = recombin('xovsp',SubChrom,PC);
    % ����ͻ��
    SubChrom = mut(SubChrom);
    % ������ת��
    sub_obj_x = bs2rv(SubChrom,FieldD);
    % �����Ӵ�Ŀ�꺯��ֵ
    sub_ovj_fitness = fitness(sub_obj_x(:,1),sub_obj_x(:,2));
    % ���²��뵽��Ⱥ����һ�����Ӵ������һ���ĸ���
    [Chrom,obj_fitness] = reins(Chrom,SubChrom,1,1,obj_fitness,sub_ovj_fitness);
    gen = gen+1;
    % ���ܸ���
    min_value = min(obj_fitness);
    if BestFval > min_value
        BestFval = min_value;
        BestFitness = obj_fitness;
        BestChrom = Chrom;
    elseif BestFval == min_value
        BestFitness = [BestFitness;obj_fitness];
        BestChrom = [BestChrom;Chrom];
    end
    trace(gen) = min_value;
    trace(gen,2) = sum(obj_fitness)/length(obj_fitness);
end

% ��ͼ
 plot(trace(:,1));hold on;
 plot(trace(:,2),'-.');grid;
 xlabel('��������');
 ylabel('y');
 legend('��ı仯','��Ⱥ��ֵ�仯');
% ���
[~,I]  = min(BestFitness);
obj_x = bs2rv(BestChrom,FieldD);
disp('��Ӧx');
obj_x(I,:)
%fval
disp('����ֵ:');
BestFval
toc;
