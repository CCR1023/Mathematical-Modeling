% CA  forsest fire without firemen

clear all;close all;
%% ����Ԫ������ʼ��
a=5;                        %Ԫ���߳�
M=100;N=100;                %Ԫ����ʼ�ߴ�
dt=1;                       %ʱ�䲽��
ft=50;                     %������ֹʱ��
T=25;                       %�¶�
V=3;                        %����
theta=90;                   %����
Ks=[1,1.3,0.5,1.0,1.5,1.8]; %��ȼ�����ø�ָ���ϵ��
n=2;                        %��ȼ��ֲ������
tm=20*ones(M,N);            %����Ԫ��ȼ��ʱ��
x0=50;                      %��Դ������
y0=50;                      %��Դ������  
%% ��ʼ��Ԫ��״̬A
%A=0��1��-1��0��ʾδȼ�գ�1��ʾ��ȫȼ�գ�-1��ʾ����ȼ�� 
A0=zeros(M,N);               %��ʼ״̬δȼ��
A0(x0,y0)=1;                 %ָ����Դλ��

% %�ӷ����
% r=15;%����뾶
% x00=x0+6;
% y00=y0;
% x1=[x00-r:0.01:x00+r];
% y1=round(sqrt(r^2-(x1-x00).^2)+y00);
% y2=round(-sqrt(r^2-(x1-x00).^2)+y00);
% for i=1:size(x1,2)
%     A0(round(x1(i)),y1(i))=-2;
%     A0(round(x1(i)),y2(i))=-2;
% end

A=A0;%��ǰԪ��״̬
A1=A0;%���º��Ԫ��״̬

%% �����ٶ�R
b=0.053;
c=0.048;
d=0.275;
R0=b*T+c*V-d;%��ʼ�������ٶ�
R=ones(M,N);

%% �����¶�
% �������ݵ���

%����
x=1:M;
y=1:N;
[X,Y]=meshgrid(x,y);

%%��˹�ֲ���������
x1=50; 
y1=80;
s1=15;
s2=20;
%��ά��˹����
Z=5+100*exp(-((X-x1).^2./(2.*s1^2)+(Y-y1).^2./(2.*s2.^2)));

% %б�µ�������
% Z=10+Y./2;

% %ƽ���������
% Z=20*ones(M,N);

Z(1,1)=0;
% meshz(X,Y,Z)%ԭʼ����ͼ
axis([0 100 0 100 0 200])
map=[1 1 1           %��      -2
    0 0 0            %��      -1
    0 0.6 0          %����     0
    1 0.5 0          %�Ⱥ�    0-1
    1 0.1 0] ;       %���     1
colormap(map)
colorbar
meshz(X,Y,Z)%ԭʼ����ͼ
hold on
set(gcf,'position',[200 189.0000  651.2000  464.0000])
xlabel('x')
ylabel('y')
zlabel('z')

%��ǻ�Դ
z0=Z(x0,y0);
hp=plot3(x0,y0,z0+1,'*r','markersize',6,'linewidth',2);
h=Z;                %���ξ���

%% ����Ԫ������״̬
for t=1:dt:ft

    
        %ȼ�ս�����������
        if sum(A==1)==0
        t
        sum(sum(A==-1))
        break;       
    end
    
    
    for i=2:M-1     %ɨ�跽ʽ����Ԫ��״̬
        for j=2:N-1
            %�¶Ⱥͷ��ٶ�8������R��Ӱ��
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
             tempA=A(i-1:i+1,j-1:j+1);
             tempA=double(tempA==1);%�ҳ�A=1��Ԫ��������Χ��ȫȼ�յ�Ԫ��
             R(i-1:i+1,j-1:j+1)=tempA.*R(i-1:i+1,j-1:j+1);%δ��ȫȼ�յĲ���ɢ
             if A(i,j)==1          %��Ԫ������ȫȼ��
                 A1(i,j)=1;
             else if A(i,j)==-1     %��Ԫ������ȼ��
                     A1(i,j)=-1;
                 else  if A(i,j)==-2
                         %do nothing
                     else    %����Ԫ��״̬
                        A1(i,j)=A(i,j)+(R(i-1,j)+R(i,j-1)+R(i+1,j)+R(i,j+1))*dt/a...
                           +(R(i-1,j-1)^2+R(i-1,j+1)^2+R(i+1,j+1)^2+R(i+1,j-1)^2)*dt/(2*a^2); 
                        end
                     end
             end
             
        end
    end
%             %�ӷ����
%         if t>60
%             A1(A1>0&A1<1)=-2;
%         end
    
    A1(A1>1)=1;
    tm(A1==1)=tm(A1==1)-1;
    A1(tm==0)=-1;%��ȼ����ȫ��״̬��Ϊ-1
    

    %�������ӽ�����ӻ�
    
    % ��ɫ����
    C=A+2;
    C(1,1)=0;
    C(C==3)=4;
    C(C>2&C<3)=3;
    
    meshz(X,Y,Z,10*C)
    drawnow
  
    %���µ�ǰԪ��״̬
    A=A1;
end
legend([hp],'Fire source','Location','best')