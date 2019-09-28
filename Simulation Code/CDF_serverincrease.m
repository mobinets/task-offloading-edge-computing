Usernum=100;
Servernum=1;
Num=10;
CDFdis=zeros(1,Num);
CDFcentral=CDFdis;
Computetotal=150;
Tasknum=zeros(1,Usernum)+10;
Nummax=max(Tasknum);
Tasktotal=Nummax;
Iterationnum=200;
Avgdeley=zeros(1,Iterationnum);
Taskgraph=zeros(Nummax,Nummax,Usernum);
%Taskgraph(:,:,1)=[0,-1,-1,-1,-1,-1,0,0,0,0;1,0,0,0,0,0,0,-1,-1,0;1,0,0,0,0,0,-1,0,0,0;1,0,0,0,0,0,0,-1,-1,0;1,0,0,0,0,0,0,0,-1,0;1,0,0,0,0,0,0,-1,0,0;0,0,1,0,0,0,0,0,0,-1;0,1,0,1,0,1,0,0,0,-1;0,1,0,1,1,0,0,0,0,-1;0,0,0,0,0,0,1,1,1,0]';
Taskgraph(:,:,1)=Graphgenerateparalel(Nummax,Nummax,Nummax-2);
for p=2:Usernum
Taskgraph(:,:,p)=Taskgraph(:,:,1);
end
%Taskgraph(:,:,2)=[0,-2,-2,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2];
%Taskgraph(:,:,2)=[0,1,-2,-2,-2,-2,-2,-2,-2,-2;-1,0,-2,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2];
%Taskgraph(:,:,2)=[0,0,-2,-2,-2,·   ··说2-2,-2,-2,-2,-2;0,0,-2,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2];
%Taskgraph(:,:,2)=[0,1,0,-2,-2,-2,-2,-2,-2,-2;-1,0,1,-2,-2,-2,-2,-2,-2,-2;0,-1,0,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2];
Transdata=(zeros(Nummax,Nummax,Usernum)+0.3)*30;
%Computecost=zeros(Nummax,Num+1,Usernum)+Computetotal/Nummax;
Computecost=zeros(Nummax,Num+1,Usernum);
 Computecost(1:Nummax,1:Num,:)=zeros(Nummax,Num,Usernum)+Computetotal/Tasktotal/10;
 Computecost(1:Nummax,Num+1,:)=zeros(Nummax,Usernum)+Computetotal/Tasktotal;
Transferrate=(zeros(Num+1,Num+1,Usernum)+0.3)*50;
for p=1:Usernum
    for a=1:Num+1
        for b=1:Num+1
            if a<=b
                Transferrate(b,a,p)=Transferrate(a,b,p);
            end
        end
    end
end
Comstartup=(zeros(1,Usernum+Num)+0.1)*3;
while Servernum<=Num
    Computecosttemp=zeros(Nummax,Servernum+1,Usernum);
    Computecosttemp(1:Nummax,1:Servernum,:)=Computecost(1:Nummax,1:Servernum,:);
    Computecosttemp(1:Nummax,Servernum+1,:)=Computecost(1:Nummax,Num+1,:);
%     假定带宽相同 传输速率目前不需要特殊处理
%     Transferratetemp=zeros(Servernum+1,Servernum+1,Usernum);
%     Transferratetemp(1:Servernum,1:Servernum,:)=Transferrate(1:Servernum,1:Servernum,:);
%     Transferratetemp(1:Servernum,1:Servernum,:)=Transferrate(1:Servernum,1:Servernum,:);
  [Schedule,Channel,Avgdeley,Usercurrent,avgdeleymin,point]=Game(Usernum,Servernum,Taskgraph,Tasknum,Transdata,Computecosttemp,Transferrate,Comstartup,Iterationnum);
  CDFdis(1,Servernum)=Uploadusercount(Usernum,Servernum,Channel)/Usernum;
  Servernum=Servernum+1;
end

%   ToN
Servernum=1;
 Tasknum=zeros(1,Usernum)+3;
    Nummax=max(Tasknum);
    Taskgraph=zeros(Nummax,Nummax,Usernum);
    for k=1:Usernum
        Taskgraph(:,:,k)=Graphgenerateparalel(3,Nummax,1);
    end
   Computecost=zeros(Nummax,Num+1,Usernum);
 Computecost(1:Nummax,1:Num,:)=zeros(Nummax,Num,Usernum)+Computetotal/10;
 Computecost(1:Nummax,Num+1,:)=zeros(Nummax,Usernum)+Computetotal;
% Computecost(1:Nummax,1:Servernum,:)=rand(Nummax,Servernum,Usernum)*Computetotal/5;
%   Computecost(1:Nummax,Servernum+1,:)=rand(Nummax,Usernum)*2*Computetotal;
 Computecost(1,:,:)=0;
   Computecost(3,:,:)=0;
   Transdata=zeros(Nummax,Nummax,Usernum);
   for u=1:Usernum
   Transdata(1,2,u)=25;
   Transdata(2,3,u)=5;
   end
while Servernum<=Num
     Computecosttemp=zeros(Nummax,Servernum+1,Usernum);
    Computecosttemp(1:Nummax,1:Servernum,:)=Computecost(1:Nummax,1:Servernum,:);
    Computecosttemp(1:Nummax,Servernum+1,:)=Computecost(1:Nummax,Num+1,:);
   [Schedule,Channel,Avgdeley,Usercurrent,avgdeleymin,point]=Game(Usernum,Servernum,Taskgraph,Tasknum,Transdata,Computecosttemp,Transferrate,Comstartup,Iterationnum);
  CDFcentral(1,Servernum)=Uploadusercount(Usernum,Servernum,Channel)/Usernum;  
Servernum=Servernum+1;
end



plot(1:Num,CDFdis);
hold on;
plot(1:Num,CDFcentral);