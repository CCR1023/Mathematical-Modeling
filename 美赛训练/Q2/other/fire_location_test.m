clear;clc;close;
% 0 empty
% 1 fire
% 2 tree
n=300;      % ɭ�����
ul=[n,1:n-1];
dr=[2:n,1];

pgrowth  = 0;   % ������
rest = n*n*0.9;     % �ջٶ�
deltax = -0.02; 
total = 0.6;        % ���ƴ�����

n3 = n/3;
location = [
    n/2 n/2
    round(1*n3*1/2),round(n3*2+n3/2)
    round(n3+n3/2),round(n3*2+n3/2)
    ];

% hang=round(n/2);    % ����ȼ�յ�
% lie=round(n/2);

num = size(location,1);
record_num = 4;
record = zeros(num,record_num);     % ���ݼ�¼
sp = 1+[deltax*(1:num)]';
% ������
pspread = 0.7;
for i = 1:num
    % ������ʼ��
    clf;
    l =  location(i,:);
    hang = l(1);
    lie = l(2);
    % Ϊ��ƽ������һ�������ʷ���
    for j = 1:record_num
        veg=zeros(n);
        imh=image(cat(3,veg,veg,veg));
        axis square;
        veg=2*ones(n);
        veg(hang,lie)=1;
        % ���濪ʼ
        for  k=1:600
            e=length(find(veg==0));
            if(e>rest)
                break
            else
                h1=veg;
                h2=h1;
                h3=h2;
                h4=h3;
                h1(n,1:n)=0;
                h2(1:n,n)=0;
                h3(1:n,1)=0;
                h4(1,1:n)=0;
                sum=(h1(ul,:)==1)+(h2(:,ul)==1)+(h3(:,dr)==1)+(h4(dr,:)==1);
                sum1=((sum==1).*(1-(1-pspread)));
                sum2=((sum==2).*(1-(1-pspread)^2));
                sum3=((sum==3).*(1-(1-pspread)^3));
                sum4=((sum==4).*(1-(1-pspread)^4));
                s=sum1+sum2+sum3+sum4;
                veg=2*(veg==2)-((veg==2)&((sum>0)&(rand(n,n)<s)))+2*((veg==0)&rand(n,n)<pgrowth);
                set(imh,'cdata',cat(3,(veg==1),(veg==2),zeros(n)))
                drawnow %�����¼�����ǿ�� matlab ˢ����Ļ
            end
        end
        record(i,j) = k;
    end
    
end
% ��ͼ
mean_t = mean(record,2);
% plot(sp,mean_t);

