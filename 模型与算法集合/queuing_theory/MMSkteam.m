function [gk,p,num]=MMSkteam(s,k,mu1,mu2,T)
%�����̨
%s��������̨����
%k�������˿͵ȴ���
%T����ʱ����ֹ��
%mu1��������ʱ��������ָ���ֲ�
%mu2��������ʱ�����ָ���ֲ�
% L--��ʼ�ӳ���
%�¼���
%   arrive_time�����˿͵����¼�
%   leave_time�����˿��뿪�¼�
%mintime�����¼����е�����¼�
%current_time������ǰʱ��
%L�����ӳ�
%tt����ʱ������
%LL�����ӳ�����
%c�����˿͵���ʱ������
%b��������ʼʱ������
%e�����˿��뿪ʱ������
%a_count��������˿���
%b_count��������˿���
%e_count������ʧ�˿���
%��ʼ��
% s=1;k=10;mu1=0.5;mu2=0.3;T=10;
arrive_time=exprnd(mu1);
leave_time=[];
current_time=0;
L=0;
LL=[L];
tt=[current_time];
c=[];
b=[];
e=[];
a_count=0;
b_count=0;
e_count=0;
%ѭ��
while min([arrive_time,leave_time])<T
    current_time=min([arrive_time,leave_time]);
    tt=[tt,current_time];    %��¼ʱ������
    if current_time==arrive_time          %�˿͵����ӹ���
        arrive_time=arrive_time+exprnd(mu1);  % ˢ�¹˿͵����¼�
        a_count=a_count+1; %�ۼӵ���˿���
        if  L<s            %�п��з���̨
            L=L+1;        %���¶ӳ�
            b_count=b_count+1;%�ۼӷ���˿���
            c=[c,current_time];%��¼�˿͵���ʱ������
            b=[b,current_time];%��¼����ʼʱ������
            leave_time=[leave_time,current_time+exprnd(mu2)];%�����µĹ˿��뿪�¼�
            leave_time=sort(leave_time);%�뿪�¼�������
        elseif L<s+k             %�п��еȴ�λ
            L=L+1;        %���¶ӳ�
            b_count=b_count+1;%�ۼӷ���˿���
            c=[c,current_time];%��¼�˿͵���ʱ������
        else               %�˿���ʧ
            e_count=e_count+1;%�ۼ���ʧ�˿���
        end
    else                   %�˿��뿪�ӹ���
        leave_time(1)=[];%���¼�����Ĩȥ�˿��뿪�¼�
        e=[e,current_time];%��¼�˿��뿪ʱ������
        if L>s    %�й˿͵ȴ�
            L=L-1;        %���¶ӳ�
            b=[b,current_time];%��¼����ʼʱ������
            leave_time=[leave_time,current_time+exprnd(mu2)];
            leave_time=sort(leave_time);%�뿪�¼�������
        else    %�޹˿͵ȴ�
            L=L-1;        %���¶ӳ�
        end
    end
    LL=[LL,L];   %��¼�ӳ�����
end
length(e);
length(c);
Ws=sum(e-c(1:length(e)))/length(e);
Wq=sum(b-c(1:length(b)))/length(b);
Wb=sum(e-b(1:length(e)))/length(e);
Ls=sum(diff([tt,T]).*LL)/T;
Lq=sum(diff([tt,T]).*max(LL-s,0))/T;
fprintf('����˿���:%d\n',a_count)%����˿���
fprintf('����˿���:%d\n',b_count)%����˿���
fprintf('��ʧ�˿���:%d\n',e_count)%��ʧ�˿���
fprintf('ƽ������ʱ��:%f\n',Ws)%ƽ������ʱ��
fprintf('ƽ���ȴ�ʱ��:%f\n',Wq)%ƽ���ȴ�ʱ��
fprintf('ƽ������ʱ��:%f\n',Wb)%ƽ������ʱ��
fprintf('ƽ���ӳ�:%f\n',Ls)%ƽ���ӳ�
fprintf('ƽ���ȴ��ӳ�:%f\n',Lq)%ƽ���ȴ��ӳ�
if k~=inf
    for i=0:s+k
        p(i+1)=sum((LL==i).*diff([tt,T]))/T;%�ӳ�Ϊi�ĸ���
        num(i) = sum(LL == i);
        %        p(i+1) = sum(LL == i)/length(LL);
        if p(i+1)~=0
            fprintf('�ӳ�Ϊ%d�ĸ���:%f\n',i,p(i+1));
        end
    end
else
    for i=0:3*s
        p(i+1)=sum((LL==i).*diff([tt,T]))/T;%�ӳ�Ϊi�ĸ���
         num(i) = sum(LL == i);
        %     p(i+1) = sum(LL == i)/length(LL);
        fprintf('�ӳ�Ϊ%d�ĸ���:%f\n',i,p(i+1));
    end
end

n=length(LL);LL(n);
LL;
%fprintf('�˿Ͳ������ϵõ�����ĸ���:%f\n',1-sum(p(1:s)))%�˿Ͳ������ϵõ�����ĸ���
% out=[Ws,Wq,Wb,Ls,Lq];%out=[Ws,Wq,Wb,Ls,Lq,p];
Lk = mean(LL);
gk = (k-Lk)/T;
num
end
%
% plot(c,ones(1,length(c)),'bo');
% hold on;
% plot(b,ones(1,length(b)),'ro');
% plot(e,ones(1,length(e)),'ko')
% plot(0:0.01:max([c,b,e]),ones(1,length(max([c,b,e]))),'-');
% legend('����','��ʼ����','�뿪','��');