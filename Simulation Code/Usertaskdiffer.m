Usernum=20;
Servernum=2;
Num=50;
Avgdeleymindis=zeros(1,Num);
Avgdeleyminton=Avgdeleymindis;
Tasknum=zeros(1,Usernum)+10;
Nummax=max(Tasknum);
Iterationnum=200;
Avgdeley=zeros(1,Iterationnum);
Computetotal=150;
Variance=0; %≥ı º∑Ω≤Ó «0
Tasktotal=Nummax;
Taskgraph=zeros(Nummax,Nummax,Usernum);
%Taskgraph(:,:,1)=[0,-1,-1,-1,-1,-1,0,0,0,0;1,0,0,0,0,0,0,-1,-1,0;1,0,0,0,0,0,-1,0,0,0;1,0,0,0,0,0,0,-1,-1,0;1,0,0,0,0,0,0,0,-1,0;1,0,0,0,0,0,0,-1,0,0;0,0,1,0,0,0,0,0,0,-1;0,1,0,1,0,1,0,0,0,-1;0,1,0,1,1,0,0,0,0,-1;0,0,0,0,0,0,1,1,1,0]';
Taskgraph(:,:,1)=Graphgenerateparalel(Nummax,Nummax,Nummax-2);
for p=2:Usernum
Taskgraph(:,:,p)=Taskgraph(:,:,1);
end
Uploadnum=zeros(1,Usernum);
%Taskgraph(:,:,2)=[0,-2,-2,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2];
%Taskgraph(:,:,2)=[0,1,-2,-2,-2,-2,-2,-2,-2,-2;-1,0,-2,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2];
%Taskgraph(:,:,2)=[0,0,-2,-2,-2,-2,-2,-2,-2,-2;0,0,-2,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2];
%Taskgraph(:,:,2)=[0,1,0,-2,-2,-2,-2,-2,-2,-2;-1,0,1,-2,-2,-2,-2,-2,-2,-2;0,-1,0,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2];
Transdata=(zeros(Nummax,Nummax,Usernum)+0.3)*30;
% Computecost=zeros(Nummax,Servernum+1,Usernum);
%  Computecost(1:Nummax,1:Servernum,:)=zeros(Nummax,Servernum,Usernum)+Computetotal/Tasktotal/10;
%  Computecost(1:Nummax,Servernum+1,:)=zeros(Nummax,Usernum)+Computetotal/Tasktotal;
Transferrate=(zeros(Servernum+1,Servernum+1,Usernum)+0.3)*50;
for p=1:Usernum
    for a=1:Servernum+1
        for b=1:Servernum+1
            if a<=b
                Transferrate(b,a,p)=Transferrate(a,b,p);
            end
        end
    end
end
Comstartup=(zeros(1,Servernum+Usernum)+0.1)*3;
%Local=zeros(1,Num)+Servernum+1;
cycleindex=1;
while cycleindex<=Num
    Computecost=zeros(Nummax,Servernum+1,Usernum);
 Computecost(1:Nummax,1:Servernum,:)=abs(sqrt(Variance)*randn(Nummax,Servernum,Usernum))+Computetotal/Tasktotal/10;
 Computecost(1:Nummax,Servernum+1,:)=abs(sqrt(Variance)*randn(Nummax,Usernum))+Computetotal/Tasktotal;
% Computecost(1,1,:)=abs(sqrt(Variance)*randn(1,1,Usernum))+Computetotal/Tasktotal/10;
% for i=1:Usernum
%     for j=1:Nummax
%     for k=1:Servernum
%         Computecost(j,k,i)=Computecost(1,1,i);
%     end
%      Computecost(j,Servernum+1,i)=Computecost(1,1,i)*10;
%     end
% end
%Computecost(1:Nummax,Servernum+1,:)=abs(sqrt(Variance)*randn(Nummax,Usernum))+Computetotal/Tasktotal;
[Schedule,Channel,Avgdeley,Usercurrent,Avgdeleymin,point]=Game(Usernum,Servernum,Taskgraph,Tasknum,Transdata,Computecost,Transferrate,Comstartup,Iterationnum);
Avgdeleymindis(1,cycleindex)=min([Avgdeley(1,Iterationnum),Avgdeley(1,Iterationnum-1)]);
cycleindex=cycleindex+1;
Variance=Variance+50;
end
Computeyy=Computecost;
%ton
Servernum=2;
cycleindex=1;
Variance=0;
 Tasknum=zeros(1,Usernum)+3;
    Nummax=max(Tasknum);
    Taskgraph=zeros(Nummax,Nummax,Usernum);
    for k=1:Usernum
        Taskgraph(:,:,k)=Graphgenerateparalel(3,Nummax,1);
    end
  
   Transdata=zeros(Nummax,Nummax,Usernum);
   for u=1:Usernum
   Transdata(1,2,u)=25;
   Transdata(2,3,u)=5;
   end
while cycleindex<=Num
     Computecost=zeros(Nummax,Servernum+1,Usernum);
   Computecost(1:Nummax,1:Servernum,:)=abs(sqrt(Variance)*randn(Nummax,Servernum,Usernum))+Computetotal/10;
   Computecost(1:Nummax,Servernum+1,:)=abs(sqrt(Variance)*randn(Nummax,Usernum))+Computetotal;
% Computecost(1,1,:)=abs(sqrt(Variance)*randn(1,1,Usernum))+Computetotal/10;
% for i=1:Usernum
%     for j=1:Nummax
%     for k=1:Servernum
%         Computecost(j,k,i)=Computecost(1,1,i);
%     end
%      Computecost(j,Servernum+1,i)=Computecost(1,1,i)*10;
%     end
% end
   Computecost(1,:,:)=0;
   Computecost(3,:,:)=0;
   [Schedule,Channel,Avgdeley,Usercurrent,avgdeleymin,point]=Game(Usernum,Servernum,Taskgraph,Tasknum,Transdata,Computecost,Transferrate,Comstartup,Iterationnum);
  Avgdeleyminton(1,cycleindex)=min([Avgdeley(1,Iterationnum),Avgdeley(1,Iterationnum-1)]);   
  Variance=Variance+50;
  cycleindex=cycleindex+1;
end
plot(1:Num,Avgdeleymindis-2*Computetotal/Tasktotal);
hold on;
plot(1:Num,Avgdeleyminton);