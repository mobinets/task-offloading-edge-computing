Usernum=1;
Servernum=20;
Num=100;
Avgdeley=zeros(1,Num);
Avgdeleyton=Avgdeley;
Totalconsumption=zeros(1,Num);
Totalconsumptiononedge=zeros(1,Num);
Totalconsumptionton=zeros(1,Num);
Tasknum=zeros(1,Num)+10;
Nummax=max(Tasknum);
Computetotal=200;
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
Transdata=(zeros(Nummax,Nummax,Num)+0.3)*10;
Computecost=zeros(Nummax,Servernum+1,Num);
 Computecost(1:Nummax,1:Servernum,:)=zeros(Nummax,Servernum,Num)+Computetotal/Tasktotal/10;
 Computecost(1:Nummax,Servernum+1,:)=zeros(Nummax,Num)+Computetotal/Tasktotal;
Transferrate=(zeros(Servernum+1,Servernum+1,Num)+0.3)*300;
for r1=1:Num
    for r2=1:Servernum
        for r3=1:Servernum
Transferrate(r2,r3,r1)=Transferrate(r2,r3,r1)*Inf;
        end
    end
end
for p=1:Num
    for a=1:Servernum+1
        for b=1:Servernum+1
            if a<=b
                Transferrate(b,a,p)=Transferrate(a,b,p);
            end
        end
    end
end
Comstartup=(zeros(1,Servernum+Num)+0.1)*1;
Computenergy=zeros(1,Num)+0.5;
Transmitpower=zeros(1,Num)+0.2;
alfa=zeros(1,Num)+0.5;
Size=zeros(Num,Nummax)+1000;
Local=zeros(1,Num)+Servernum+1;
consumptiontemp=0;
while Usernum<=Num
   [Scheduletotal,Computeconsumption,Transmitconsumption]=globecomedgenetworks2(Usernum,Servernum,Local,Taskgraph,Tasknum,Transdata,Computecost,Transferrate,Comstartup,Computenergy,Transmitpower,alfa,Size);
   basesearch=0;
deley=0;
for t=1:Usernum
    Startsearch(1,t)=basesearch;
    basesearch=basesearch+Tasknum(1,t);
end
for i=1:Usernum
    deley=deley+Scheduletotal(2,Startsearch(1,i)+Tasknum(1,i),Servernum+i)-Scheduletotal(1,Startsearch(1,i)+1,Servernum+i);
end
   Avgdeley(1,Usernum)=deley/Usernum; 
   Totalconsumption(1,Usernum)=sum(Computeconsumption+Transmitconsumption);
   Usernum=Usernum+1;
end

%one server
Usernum=1;
Avgdeleyonedge=zeros(1,Num);
while Usernum<=Num
   [Scheduletotal,Computeconsumption,Transmitconsumption]=globecomonedge(Usernum,Servernum,Local,Taskgraph,Tasknum,Transdata,Computecost,Transferrate,Comstartup,Computenergy,Transmitpower,alfa,Size);
   basesearch=0;
deley=0;
for t=1:Usernum
    Startsearch(1,t)=basesearch;
    basesearch=basesearch+Tasknum(1,t);
end
for i=1:Usernum
    deley=deley+Scheduletotal(2,Startsearch(1,i)+Tasknum(1,i),Servernum+i)-Scheduletotal(1,Startsearch(1,i)+1,Servernum+i);
end
   Avgdeleyonedge(1,Usernum)=deley/Usernum; 
   Totalconsumptiononedge(1,Usernum)=sum(Computeconsumption+Transmitconsumption);
   Usernum=Usernum+1;
end


%ton
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
   [Scheduletotal,Computeconsumption,Transmitconsumption]=globecomedgenetworks2(Usernum,Servernum,Local,Taskgraph,Tasknum,Transdata,Computecost,Transferrate,Comstartup,Computenergy,Transmitpower,alfa,Size);
   basesearch=0;
deley=0;
for t=1:Usernum
    Startsearch(1,t)=basesearch;
    basesearch=basesearch+Tasknum(1,t);
end
for i=1:Usernum
    deley=deley+Scheduletotal(2,Startsearch(1,i)+Tasknum(1,i),Servernum+i)-Scheduletotal(1,Startsearch(1,i)+1,Servernum+i);
end
   Avgdeleyton(1,Usernum)=deley/Usernum;
   Totalconsumptionton(1,Usernum)=sum(Computeconsumption+Transmitconsumption);
Usernum=Usernum+1;
 end
plot(1:Num,Totalconsumption);
hold on;
plot(1:Num,Totalconsumptiononedge,'--');
hold on;
plot(1:Num,Totalconsumptionton);
hold on;

plot(1:Num,Avgdeley-2*Computetotal/Tasktotal);
hold on;
plot(1:Num,Avgdeleyton,'--');
hold on;
plot(1:Num,Avgdeleyonedge-2*Computetotal/Tasktotal);
hold on;