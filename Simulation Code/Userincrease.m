Usernum=1;
Servernum=2;
Num=25;
Avgdeleymin=zeros(1,Num);
Avgdeleyminton=Avgdeleymin;
Tasknum=zeros(1,Num)+10;
Nummax=max(Tasknum);
Iterationnum=200;
Avgdeley=zeros(1,Iterationnum);
Computetotal=150;
Tasktotal=Nummax;
Taskgraph=zeros(Nummax,Nummax,Num);
%Taskgraph(:,:,1)=[0,-1,-1,-1,-1,-1,0,0,0,0;1,0,0,0,0,0,0,-1,-1,0;1,0,0,0,0,0,-1,0,0,0;1,0,0,0,0,0,0,-1,-1,0;1,0,0,0,0,0,0,0,-1,0;1,0,0,0,0,0,0,-1,0,0;0,0,1,0,0,0,0,0,0,-1;0,1,0,1,0,1,0,0,0,-1;0,1,0,1,1,0,0,0,0,-1;0,0,0,0,0,0,1,1,1,0]';
Taskgraph(:,:,1)=Graphgenerateparalel(Nummax,Nummax,Nummax-2);
for p=2:Num
Taskgraph(:,:,p)=Taskgraph(:,:,1);
end
Uploadnum=zeros(1,Num);
%Taskgraph(:,:,2)=[0,-2,-2,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2];
%Taskgraph(:,:,2)=[0,1,-2,-2,-2,-2,-2,-2,-2,-2;-1,0,-2,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2];
%Taskgraph(:,:,2)=[0,0,-2,-2,-2,-2,-2,-2,-2,-2;0,0,-2,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2];
%Taskgraph(:,:,2)=[0,1,0,-2,-2,-2,-2,-2,-2,-2;-1,0,1,-2,-2,-2,-2,-2,-2,-2;0,-1,0,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2];
Transdata=(zeros(Nummax,Nummax,Num)+0.3)*30;
Computecost=zeros(Nummax,Servernum+1,Num);
 Computecost(1:Nummax,1:Servernum,:)=zeros(Nummax,Servernum,Num)+Computetotal/Tasktotal/10;
 Computecost(1:Nummax,Servernum+1,:)=zeros(Nummax,Num)+Computetotal/Tasktotal;
Transferrate=(zeros(Servernum+1,Servernum+1,Num)+0.3)*50;
for p=1:Num
    for a=1:Servernum+1
        for b=1:Servernum+1
            if a<=b
                Transferrate(b,a,p)=Transferrate(a,b,p);
            end
        end
    end
end
Comstartup=(zeros(1,Servernum+Num)+0.1)*3;
%Local=zeros(1,Num)+Servernum+1;
while Usernum<=Num
[Schedule,Channel,Avgdeley,Usercurrent,avgdeleymin,point]=Game(Usernum,Servernum,Taskgraph,Tasknum,Transdata,Computecost,Transferrate,Comstartup,Iterationnum);
Avgdeleymin(1,Usernum)=mean([Avgdeley(1,Iterationnum),Avgdeley(1,Iterationnum-1)]);
Uploadnum(1,Usernum)=Uploadusercount(Usernum,Servernum,Channel);
Usernum=Usernum+1;
end

%以下是ton
Usernum=1;
 Tasknum=zeros(1,Num)+3;
    Nummax=max(Tasknum);
    Taskgraph=zeros(Nummax,Nummax,Num);
    for k=1:Num
        Taskgraph(:,:,k)=Graphgenerateparalel(3,Nummax,1);
    end
   Computecost=zeros(Nummax,Servernum+1,Num);
 Computecost(1:Nummax,1:Servernum,:)=zeros(Nummax,Servernum,Num)+Computetotal/10;
 Computecost(1:Nummax,Servernum+1,:)=zeros(Nummax,Num)+Computetotal;
% Computecost(1:Nummax,1:Servernum,:)=rand(Nummax,Servernum,Usernum)*Computetotal/5;
%   Computecost(1:Nummax,Servernum+1,:)=rand(Nummax,Usernum)*2*Computetotal;
 Computecost(1,:,:)=0;
   Computecost(3,:,:)=0;
   Transdata=zeros(Nummax,Nummax,Num);
   for u=1:Num
   Transdata(1,2,u)=25;
   Transdata(2,3,u)=5;
   end
while Usernum<=Num
   [Schedule,Channel,Avgdeley,Usercurrent,avgdeleymin,point]=Game(Usernum,Servernum,Taskgraph,Tasknum,Transdata,Computecost,Transferrate,Comstartup,Iterationnum);
  Avgdeleyminton(1,Usernum)=mean([Avgdeley(1,Iterationnum),Avgdeley(1,Iterationnum-1)]);  
Usernum=Usernum+1;
end
plot(1:Num,Avgdeleymin-2*Computetotal/Tasktotal); %假设我们的多任务情况下第一个任务和最后一个任务的执行时间是0
hold on;
plot(1:Num,Avgdeleyminton);
hold on;
% plot(1:Num,Uploadnum);