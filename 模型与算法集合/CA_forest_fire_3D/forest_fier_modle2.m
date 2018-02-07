% CA  forsest fire with firemen

clear all;close all;
%% ����Ԫ������ʼ��
a=5;                        %Ԫ���߳�
M=100;N=100;                %Ԫ����ʼ�ߴ�
CA0=cell(M,N);              %��ʼԪ������
dt=1;                       %ʱ�䲽��
ft=80;                      %������ֹʱ��
T=25;                       %�¶�
V=0;                        %����
theta=0;                   %����
Ks=[1,1.3,0.5,1.0,1.5,1.8]; %��ȼ�����ø�ָ���ϵ��
n=2;                        %��ȼ��ֲ������
tm=15*ones(M,N);            %����Ԫ��ȼ��ʱ��
x0=50;                      %��Դ������
y0=50;                      %��Դ������  

rt=50;                      %������Ӧʱ��
num0=40;                    %��������Ԫ������
p=0.8;                      %���ǿ��


%% ��ʼ��Ԫ��״̬A
%A=0��1��-1��0��ʾδȼ�գ�1��ʾ��ȫȼ�գ�-1��ʾ����ȼ�� 
A0=zeros(M,N);               %��ʼ״̬δȼ��
A0(x0,y0)=1;                 %ָ����Դλ��

A=A0;%��ǰԪ��״̬
A1=A0;%���º��Ԫ��״̬

%% �����ٶ�R
b=0.053;
c=0.048;
d=0.275;
R0=b*T+c*V- d;%��ʼ�������ٶ�
R=ones(M,N);

%% �����¶�
% �������ݵ���
%%��˹�ֲ���������
x=1:M;
y=1:N;
[X,Y]=meshgrid(x,y);
x1=50; 
y1=80;
s1=15;
s2=20;
%��ά��˹����
Z=5+50*exp(-((X-x1).^2./(2.*s1^2)+(Y-y1).^2./(2.*s2.^2)));

% %б�µ�������
% Z=10+Y./2;

% %ƽ���������
% Z=20*ones(M,N);

Z(1,1)=0;
meshz(X,Y,Z)%ԭʼ����ͼ
axis([0 100 0 100 0 100])
map=[0.8 0.8 0.8     %ǳ��
    0 0 0      %���
    0 0.6 0         %����
    1 0.5 0          %�Ⱥ�
    1 0.1 0] ;       %���
colormap(map)
hold on
set(gcf,'position',[434.6000  189.0000  651.2000  464.0000])
xlabel('x')
ylabel('y')
zlabel('z')

%��ǻ�Դ
z0=Z(x0,y0);
h1=plot3(x0,y0,z0+1,'*r','markersize',6,'linewidth',2);
h=Z;                %���ξ���

%set(hp,'color','k')
%% ����Ԫ������״̬
for t=1:dt:ft

    %����ʼ��
    if t==rt+1        %��ʼ���
        [a0,b0]=find(A>0&A<1);
        
        [c0,d0]=max(a0);
        A(c0(1),b0(d0(1))+2)=-2;%������ĵ㿪ʼ���   
         A(c0(1),b0(d0(1))+1)=-2;
         z0=Z(c0(1),b0(d0(1)));
         h2=plot3(b0(d0(1)),c0(1)-1,z0+1,'ok','markersize',6,'linewidth',2);
         
%         [c0,d0]=min(a0);
%         A(c0(1),b0(d0(1)))=-2;%�����Ϸ��ĵ㿪ʼ���  
%         z0=Z(c0(1),b0(d0(1)));
%              h2=plot3(c0(1)+2,b0(d0(1))-7,z0+3,'ok','markersize',6,'linewidth',2);
    end
    
    %�ж�ȼ���Ƿ����
    if sum(A==1)==0
        t
        sum(sum(A<0))
        break;
        
    end
    num=num0;
    
    for i=2:M-1     %ɨ�跽ʽ����Ԫ��״̬
        for j=2:N-1
            %8���¶Ⱥͷ��ٶ�R��Ӱ��
            %OA����
            Kw=exp(0.1783*V*cos((315-theta)*pi/180));%�����ϵ��
            dh=h(i,j)-h(i-1,j-1)+eps;
            G=(-dh/abs(dh)+1)/2;
            Kf=exp(3.533*(-1)^G*(abs(dh/(sqrt(2)*a)))^1.2);%�����¶ȸ���ϵ�� 
            R(i-1,j-1)=R0*Ks(n)*Kw*Kf;
            %OB����
            Kw=exp(0.1783*V*cos((theta)*pi/180));%�����ϵ��
            dh=h(i,j)-h(i-1,j)+eps;
            G=(-dh/abs(dh)+1)/2;
            Kf=exp(3.533*(-1)^G*(abs(dh/a))^1.2);%�����¶ȸ���ϵ�� 
            R(i-1,j)=R0*Ks(n)*Kw*Kf;
            %OC����
            Kw=exp(0.1783*V*cos((theta-45)*pi/180));%�����ϵ��
            dh=h(i,j)-h(i-1,j+1)+eps;
            G=(-dh/abs(dh)+1)/2;
            Kf=exp(3.533*(-1)^G*(abs(dh/(sqrt(2)*a)))^1.2);%�����¶ȸ���ϵ�� 
            R(i-1,j+1)=R0*Ks(n)*Kw*Kf;
            %OD����
            Kw=exp(0.1783*V*cos((theta-90)*pi/180));%�����ϵ��
            dh=h(i,j)-h(i,j+1)+eps;
            G=(-dh/abs(dh)+1)/2;
            Kf=exp(3.533*(-1)^G*(abs(dh/a))^1.2);%�����¶ȸ���ϵ�� 
            R(i,j+1)=R0*Ks(n)*Kw*Kf;
            %OE����
            Kw=exp(0.1783*V*cos((theta-135)*pi/180));%�����ϵ��
            dh=h(i,j)-h(i+1,j+1)+eps;
            G=(-dh/abs(dh)+1)/2;
            Kf=exp(3.533*(-1)^G*(abs(dh/(sqrt(2)*a)))^1.2);%�����¶ȸ���ϵ�� 
            R(i+1,j+1)=R0*Ks(n)*Kw*Kf;
            %OF����
            Kw=exp(0.1783*V*cos((theta-180)*pi/180));%�����ϵ��
            dh=h(i,j)-h(i+1,j)+eps;
            G=(-dh/abs(dh)+1)/2;
            Kf=exp(3.533*(-1)^G*(abs(dh/a))^1.2);%�����¶ȸ���ϵ�� 
            R(i+1,j)=R0*Ks(n)*Kw*Kf;
            %OG����
            Kw=exp(0.1783*V*cos((225-theta)*pi/180));%�����ϵ��
            dh=h(i,j)-h(i+1,j-1)+eps;
            G=(-dh/abs(dh)+1)/2;
            Kf=exp(3.533*(-1)^G*(abs(dh/(sqrt(2)*a)))^1.2);%�����¶ȸ���ϵ�� 
            R(i+1,j-1)=R0*Ks(n)*Kw*Kf;
            %OH����
            Kw=exp(0.1783*V*cos((theta+90)*pi/180));%�����ϵ��
            dh=h(i,j)-h(i,j-1)+eps;
            G=(-dh/abs(dh)+1)/2;
            Kf=exp(3.533*(-1)^G*(abs(dh/a))^1.2);%�����¶ȸ���ϵ�� 
            R(i,j-1)=R0*Ks(n)*Kw*Kf;
              
            %����Ԫ��״̬A
             temp=A(i-1:i+1,j-1:j+1);
             temp1=double(temp==1);%�ҳ�A=1��Ԫ��������Χ��ȫȼ�յ�Ԫ��

             R(i-1:i+1,j-1:j+1)=temp1.*R(i-1:i+1,j-1:j+1);%δ��ȫȼ�յĲ���ɢ
             if A(i,j)==1          %��Ԫ������ȫȼ��
                  if sum(temp(temp==-2))~=0%Ԫ����Χ��������ӣ�״̬Ϊ-2��Ԫ����
                      if num>0&&rand>1-p
                         A1(i,j)=-2; 
                         num=num-1;
                      end
                      
                  end
             else if A(i,j)==-1     %��Ԫ������ȼ�ջ��Ѿ�ȼ����
                      A1(i,j)=-1 ;
                 else if A(i,j)==-2
                             A1(i,j)=-2;
                     else               %����Ԫ��״̬
                         
                      if sum(temp(temp==-2))~=0%Ԫ����Χ��������ӣ�״̬Ϊ-2��Ԫ����
                          if A(i,j)~=0
                              if num>0&&rand>1-p
                                  A1(i,j)=-2;
                                  num=num-1;
                              end                           
                          end
                      else
                        A1(i,j)=A(i,j)+(R(i-1,j)+R(i,j-1)+R(i+1,j)+R(i,j+1))*dt/a...
                           +(R(i-1,j-1)^2+R(i-1,j+1)^2+R(i+1,j+1)^2+R(i+1,j-1)^2)*dt/(2*a^2); 
                      end
                      
                     end
                     
                 end
             end           
        end
    end
    A1(A1>1)=1;
    tm(A1==1)=tm(A1==1)-1;
    A1(tm==0)=-1;%��ȼ����ȫ��״̬��Ϊ-1
    %�������ӽ�����ӻ�
    
    % ��ɫ����
    C=A1+2;
    C(1,1)=0;
    C(C==3)=4;
    C(C>2&C<3)=3;
    
    meshz(X,Y,Z,50*C)
    drawnow
  

    %�����µĵ�ǰԪ��״̬
    A=A1;
end
legend([h1,h2],'Fire source','Extinguishing starting point','Location','best')