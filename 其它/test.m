% �����Թ滮
clear;clc;close;
x = sdpvar(1,2);        % ���߱���
z = x(1)^2+x(2)^2+8;    % Ŀ�꺯��
C = [
    x(1)^2 - x(2) >= 0;
    -x(1) - x(2)^2 ==-2;
    x >= 0;
];      % Լ������
ops = sdpsettings('solver','gurobi');
result = optimize(C,z);
value(z)