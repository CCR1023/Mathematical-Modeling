% �����2.1-�Խ�ģ��
clc;close;clear;
%% ��ʼ��
Pi = 20;      % ���빦��
Po = -127;   % �������
beta = deg2rad(20);    % ����
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
h = hup - hdown;       % �߶Ȳ�
hmax = 200*10^3; % ��߸߶�
Nmax = 8*10^11; % �������ܶ�
R = 6371*10^3;      % ����뾶
m = 9.106*10^(-31);
fmax = sqrt((80.8*Nmax*(1+2*hmax/R))/(sin(beta)^2+2*hmax/R));      % ���Ƶ�ʹ��㹫ʽ
f = 0.85*fmax;    % ����Ƶ��
lamda = c /f;   % ����
w = 2*pi*f;     % ������Ƶ��

%% ���η�����ļ���
Lf = 20*log10(f/10^6);  % ����

l = h/sin(beta);
a1 = (60*pi*N(1)*e^2*v(1))/(m*(w^2 + v(1)^2));        % D���������
La1 = exp(-a1*l)*2;
a2 = (60*pi*N(2)*e^2*v(2))/(m*(w^2 + v(2)^2));        % E���������
La2 = exp(-a2*l)*2;
La = La1+La2;
Le = 15.4;        % 12��

% ɽ�ط���
% ��ʼ��
er = 4;            % ��Խ�糣��
o = 10^-3;            % ��ˮ�絼��
ee = er+60*lamda*o*i;     % ���渴��糣��

alpha = deg2rad(30);
gama = alpha - beta;
allow = pi/2 - beta;
percent = allow/pi;
RH = (sin(gama)-sqrt(ee - cos(gama)^2))/(sin(gama)+sqrt(ee-cos(gama)^2));
RV = (ee*sin(gama) - sqrt(ee - cos(gama)^2))/(ee*sin(gama)+sqrt(ee - cos(gama)^2));
R1 = (abs(RV)^2 + abs(RH)^2);
Lg = abs(10*log10(R1/2));

k = 1;
while 1
    % ����һ�����
Pi = Pi - La - 20*log10(hup/10^3*2);                   % ������Լ����ֿռ����
Pi = (Pi - Lg);     % ɽ��
Pi = 10^(Pi/10)*percent;    % ת��ΪW
Pi = 10*log10(Pi)

% �ж��Ƿ����Ѵﵽ���
temp = Pi - 32.45 - 20*log10(f/10^6);
if temp <= Po
    disp('��Ծ');
    disp(k)
    break;
end
k = k +1;
end

