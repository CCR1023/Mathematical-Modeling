% ����Ǧ�����
clear;clc;close all;
syms x y theta t g h v;
x = v*cos(theta)*t;
eq1 = v*sin(theta)*t-1/2*g*t^2+h;
tans = solve(eq1,'t');
xans = subs(x,t,tans);
% ��g= 10 h = 1.6ǰ���½��з���
xs = subs(xans,{g,h},{10,1.6});
xs = xs(1);
digits(2);
fisrt_time = true;
for i = 1:10 % v��0-10
    for j = 1:90% �Ƕȴ�0-90��
        temp = double(subs(xs,{v,theta},{i,deg2rad(j)}));
        h = plot3(i,j,temp,'or');
        if fisrt_time == true
            fisrt_time = false;
            hold on;grid on;
            xlabel('v');ylabel('\theta');zlabel('height');
            xlim([1,10]);
            zlim([0 13]);
        end
        pause(0.001);
    end
end
% ��ת�ӽ�
for i = -180:180
    view(i,30);
    drawnow;
end