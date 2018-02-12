% ����һ-����ͨ����ƽ�淴������м���
% ���裺����ͳ�ƾ��ڰ���,����ĵ����ܶȾ�Ϊ����
%% �����˥��
% ��ʼ��
clear;clc;close all;
Pin = 100;      % ���빦��
L_Pin = 10*log10(Pin);

N = [               % ��������ܶ�
    2.5*10^9        % D��
    2*10^11         % E��
    ];
v = [
    5*10^6;    % D��
    10^5;          %E��
    ];
c = 3*10^8;
e = 1.60217662 * 10^(-19);  % ����
hup = 150*10^3;
hdown = 60*10^3;
deltah = hup - hdown;       % �߶Ȳ�
hmax = 200*10^3; % ��߸߶�
Nmax = 8*10^11; % �������ܶ�
R = 6371*10^3;      % ����뾶
m = 9.106*10^(-31);
Lg = 15.4;        % 12��Ķ������

N1= 35;
N2 = -2;

k = 1;
between = 60:-1:20;
for i = between
    delta = deg2rad(i);    % ����

    fmax = sqrt((80.8*Nmax*(1+2*hmax/R))/(sin(delta)^2+2*hmax/R));      % ���Ƶ�ʹ��㹫ʽ
    f = 0.85*fmax;    % ����Ƶ��
    lamda = c /f;   % ����
    w = 2*pi*f;     % ������Ƶ��
    Fa = 10*log10(1.38*10^(-23)*290*f);       %����
    noise = Fa+N1+N2;
    
    %% ��ļ���  
    l = deltah/sin(delta);
    a1 = (60*pi*N(1)*e^2*v(1))/(m*(w^2 + v(1)^2));        % D���������
    La1 = exp(-a1*l)*2;
    a2 = (60*pi*N(2)*e^2*v(2))/(m*(w^2 + v(2)^2));        % E���������
    La2 = exp(-a2*l)*2;
    La = La1+La2;

    
    %% ����ƽ��˥��
    % ��ʼ��
    er = 70;            % ��Խ�糣��
    o = 5;            % ��ˮ�絼��
    ee = er+60*lamda*o*i;     % ���渴��糣��
    
    % ��̬
    RH = (sin(delta)-sqrt(ee - cos(delta)^2))/(sin(delta)+sqrt(ee-cos(delta)^2));
    RV = (ee*sin(delta) - sqrt(ee - cos(delta)^2))/(ee*sin(delta)+sqrt(ee - cos(delta)^2));
    R1 = (abs(RV)^2 + abs(RH)^2);
    Lg_static = abs(10*log10(R1/2));
    
    % ��̬-������������
    wind = 10;      % ����
    h = 0.0051*wind^2;  % ���˾������߶�
    g = 0.5*(4*pi*h*f*sin(delta)/c)^2;
    p = 1/sqrt(3.2*g-2+sqrt((3.2*g)^2-7*g+9));
    R2 = p*R1;
    Lg_dynamic =abs(10*log10(R2/2));
    
    % ͳ�Ƶ���
    total = L_Pin-15.4-32.45-20*log10(f/10^6) -noise + 10;
    n1 = intvar(1,1);
    C = [
        n1*(La+Lg_static)+20*log10(150*cos(delta)/sin(delta)*2*n1)<=total;
        ];
    z = -n1;
    result = optimize(C,z);
    X1(k) = value(n1);
    
    if X1(k) == 0
           x_static(k)= NaN;        % ����
    else
        x_static(k)=  Lg_static +La +  20*log10(150*cos(delta)/sin(delta)*2)+(20*log(f/10^6)+32.45)/X1(k);        % ����
      
    end
    

    
    
    k = k+1;
end
% figure;
% plot(between,x_static,between,x_dynmic);legend('��̬','��̬');
figure;
plot(between,X1);xlabel('Antenna elevation angle');ylabel('Hup');
