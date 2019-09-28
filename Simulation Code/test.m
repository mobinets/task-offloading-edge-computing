Usernum=100;
Servernum=1;
Num=50;
Avgdeleymin=zeros(1,Num);
Avgdeleyminton=zeros(1,Num);
Computetotal=200;
Tasknum=zeros(1,Usernum)+10;
Nummax=max(Tasknum);
Tasktotal=Nummax;
Taskgraph=zeros(Nummax,Nummax,Usernum);
%Taskgraph(:,:,1)=[0,-1,-1,-1,-1,-1,0,0,0,0;1,0,0,0,0,0,0,-1,-1,0;1,0,0,0,0,0,-1,0,0,0;1,0,0,0,0,0,0,-1,-1,0;1,0,0,0,0,0,0,0,-1,0;1,0,0,0,0,0,0,-1,0,0;0,0,1,0,0,0,0,0,0,-1;0,1,0,1,0,1,0,0,0,-1;0,1,0,1,1,0,0,0,0,-1;0,0,0,0,0,0,1,1,1,0]';
Taskgraph(:,:,1)=Graphgenerateparalel(Nummax,Nummax,Nummax-2);
for p=2:Usernum
Taskgraph(:,:,p)=Taskgraph(:,:,1);
end
%Taskgraph(:,:,2)=[0,-2,-2,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2];
%Taskgraph(:,:,2)=[0,1,-2,-2,-2,-2,-2,-2,-2,-2;-1,0,-2,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2];
%Taskgraph(:,:,2)=[0,0,-2,-2,-2,-2,-2,-2,-2,-2;0,0,-2,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2];
%Taskgraph(:,:,2)=[0,1,0,-2,-2,-2,-2,-2,-2,-2;-1,0,1,-2,-2,-2,-2,-2,-2,-2;0,-1,0,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2];
Transdata=(zeros(Nummax,Nummax,Usernum)+0.3)*10;
%Computecost=zeros(Nummax,Num+1,Usernum)+Computetotal/Nummax;
Computecost=zeros(Nummax,Num+1,Usernum);
 Computecost(1:Nummax,1:Num,:)=zeros(Nummax,Num,Usernum)+Computetotal/Tasktotal/10;
 Computecost(1:Nummax,Num+1,:)=zeros(Nummax,Usernum)+Computetotal/Tasktotal;
Transferrate=(zeros(Num+1,Num+1,Usernum)+0.3)*300;
for r1=1:Usernum
    for r2=1:Num
        for r3=1:Num
Transferrate(r2,r3,r1)=Transferrate(r2,r3,r1)*Inf;
        end
    end
end
for p=1:Usernum
    for a=1:Num+1
        for b=1:Num+1
            if a<=b
                Transferrate(b,a,p)=Transferrate(a,b,p);
            end
        end
    end
end
Comstartup=(zeros(1,Usernum+Num)+0.1)*1;
Computenergy=zeros(1,Usernum)+0.5;
Transmitpower=zeros(1,Usernum)+0.2;
alfa=zeros(1,Usernum)+0.5;
Size=zeros(Usernum,Nummax)+1000;
Avgdeley=zeros(1,Num);
Totalconsumption=zeros(1,Num);
Avgdeleyton=zeros(1,Num);
Totalconsumptionton=zeros(1,Num);
Servernum=1;
 Tasknum=zeros(1,Usernum)+3;
 Size(:,1)=0;
 Size(:,3)=0;
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
  % Servernum=49;
while Servernum<=Num
     Computecosttemp=zeros(Nummax,Servernum+1,Usernum);
    Computecosttemp(1:Nummax,1:Servernum,:)=Computecost(1:Nummax,1:Servernum,:);
    Computecosttemp(1:Nummax,Servernum+1,:)=Computecost(1:Nummax,Num+1,:);
    Local=zeros(1,Usernum)+Servernum+1;
    Transferratetemp=zeros(Servernum+1,Servernum+1,Usernum);
    Transferratetemp(1:Servernum,1:(Servernum+1),:)=Transferrate(1:Servernum,1:(Servernum+1),:);
    Transferratetemp(Servernum+1,1:(Servernum+1),:)=Transferrate(Servernum+1,1:(Servernum+1),:);
    for p=1:Servernum
    Transferratetemp(Servernum+1,p,:)=Transferrate(Num+1,p,:);
    Transferratetemp(p,Servernum+1,:)=Transferratetemp(Servernum+1,p,:);
    end
    [Scheduletotal,Computeconsumption,Transmitconsumption]=globecomedgenetworks2(Usernum,Servernum,Local,Taskgraph,Tasknum,Transdata,Computecosttemp,Transferratetemp,Comstartup,Computenergy,Transmitpower,alfa,Size);
  basesearch=0;
 deley=0;
for t=1:Usernum
    Startsearch(1,t)=basesearch;
    basesearch=basesearch+Tasknum(1,t);
end
for i=1:Usernum
    deley=deley+Scheduletotal(2,Startsearch(1,i)+Tasknum(1,i),Servernum+i)-Scheduletotal(1,Startsearch(1,i)+1,Servernum+i);
end
   Avgdeleyton(1,Servernum)=deley/Usernum;
   Totalconsumptionton(1,Servernum)=sum(Computeconsumption+Transmitconsumption);
Servernum=Servernum+1;
end
plot(1:Num,Totalconsumptionton);
