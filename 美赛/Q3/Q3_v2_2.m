% �������˥��
clear;close;clc;
down = deg2rad(22);     % �½�
up = deg2rad(60);           % �Ͻ�
hup = 150*10^3;         %E��
hdown = 60*10^3;    %D��
total = (hdown/sin(down)*cos(down) - hup/sin(up)*cos(up) )*2;
v = 50 * 1.852;
total/v