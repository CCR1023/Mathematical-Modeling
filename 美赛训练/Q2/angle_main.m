% Ԫ���Զ�������-������ȼ�������ϵ
clear;clc;close;
% ��ʼ������
T = 22.4;          % �¶�
V = 3;         % ����
aw = 1;         % ��Ի�����Ӱ��̶�
h = 0.63;        % ��Сʪ��
W = v2w(V);     % ��ȼ�
pg = 0.000;       % ������
% pf = 0.0001;        % ����
theta = deg2rad(60);        % �緽��Ƕ�
a = 0.03;b = 0.05;c = 0.01; d = 0.3; % �����ʼ���Ӷȵ���������
R0 = a*T + b*W + c*h - d;                     % ��ʼ���Ӷ�
Ks = 1;             % ��ȼ�����ø�ָ���ϵ��
% Kf = 1;             % �����¶�
h = @(x)(R0*Ks*exp(0.1783*x));      % �����ֻ������ٶȹ�ʽ xΪ�ֽ��ķ���
Rs = 10;            % ��ȼ����
tend = 0.9;
% ���ѭ��
n = 300;            % ɭ�ֳߴ�
L = 255;
veg.life = L*ones(n);     % ɭ������ֵ
veg.fire = zeros(n);    % ɭ���Ƿ���𣬳�ʼδ���
hang = round(n/2);                 % ��ʼ����
lie = round(n/2);
veg.fire(hang,lie) = 1;
MaxIters =150;        % ����������

location = [
    0 90
    0 180
    0 360
    ];
% location (:,1) = [];
num = 4;
record = zeros(size(location,1),num);
% ģ�⿪ʼ
for i = 1:size(record,1)
    for j = 1:num
        clf;
        % ��ʾ��ʼͼ
        veg.life = L*ones(n);     % ɭ������ֵ
        veg.fire = zeros(n);    % ɭ���Ƿ���𣬳�ʼδ���
        hang = n/2; % ��ʼ����
        lie = n/2;
        veg.fire(hang,lie) = 1;
        im = image(veg.life);
        colormap(gray);
        axis square;
        set(gca, 'xtick', [], 'ytick', []);
        for k = 1:MaxIters
%             if sum(sum(veg.life == 0)) > tend*n*n
%                 break;
%             end
            theta = deg2rad(randi(location(i,:),1));
%                     theta = deg2rad(location(i));
            % ���ܵ��ڲ�ѭ��
            lr = V*cos(theta);      % ����
            ud = V*sin(theta);      % ����
            % ����ͳ�������ķ���
            if lr >0
                lr = [n,1:n-1 ];
                k1 = [veg.fire(:,n)  zeros(n,n-1) ];      % �����
            else
                lr = [2:n,1];
                k1 = [zeros(n,n-1) veg.fire(:,1) ];     % �����
            end
            if ud >0
                ud = [2:n,1];
                k2 = [zeros(n-1,n);veg.fire(1,:)];
            else
                ud = [n,1:n-1];
                k2 = [veg.fire(n,:);zeros(n-1,n)];
            end
            
            % ���ȼ���ɭ�����ܱߵĻ�����ֵ�ı仯
            %             temp = veg;
            Rx = h(V*cos(theta));
            Ry = h(V*sin(theta));
            delta = veg.fire(:,lr).*Rx + veg.fire(ud,:).*Ry;
            % ��ȥ�߽����������ķ���
            delta = delta - Rx.*k1 - Ry*k2;
            veg.life = veg.life - aw*delta-Rs.*veg.fire;
            % ���յ���ֵ�ĵ���и���
            veg.fire(veg.life < 0) = 0;
            veg.life(veg.life < 0) = 0;
            % �ټ����»� �����ǵ���ԭʼ����ֵ���Ҳ�����0
            veg.fire( veg.life ~= L & veg.life ~= 0) = 1;
            % ������
            index = find(veg.fire == 0 & veg.life ==  0 & rand(n,n) < pg);
            veg.life(index) = L;
            % ��ʾ
            % ���ȹ�һ��
            temp = Normalize(veg.life);
            set(im,'CData',[temp,temp,temp]);
            drawnow;
        end
        record(i,j) =  sum(sum(veg.life == 0));
    end
    
    
end
plot(record);
% plot(10+(1:length(record)*10),record);