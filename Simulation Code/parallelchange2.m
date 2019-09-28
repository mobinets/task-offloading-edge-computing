Usernum=30;
Servernum=10;
Computetotal=200;
Tasktotal=102;
r=floor(log2(Tasktotal-2)+1);
Tasknum=zeros(1,Usernum)+Tasktotal;
    Nummax=max(Tasknum);
    Taskgraph=zeros(Nummax,Nummax,Usernum);
Avgdeley=zeros(1,r);
Totalconsumption=zeros(1,r);
Num=5;
Total=0;
j=1;
%Avgdeley=zeros(1,Num);
Avgdeleyminton=zeros(1,r);
User=0;
server=0;
cycleindex=1;
Transferrate=(zeros(Servernum+1,Servernum+1,Usernum)+0.1)*100;
for p=1:Usernum
    for a=1:Servernum+1
        for b=1:Servernum+1
            if a<=b
                Transferrate(b,a,p)=Transferrate(a,b,p);
            end
        end
    end
end
Comstartup=(zeros(1,Servernum+Usernum)+0.1)*1;
    Transdata=(zeros(Nummax,Nummax,Usernum)+0.5/Tasktotal)*50;
    Computenergy=zeros(1,Usernum)+0.5;
Transmitpower=zeros(1,Usernum)+0.2;
alfa=zeros(1,Usernum)+0.5;
Size=zeros(Usernum,Nummax)+10;
Local=zeros(1,Usernum)+Servernum+1;
    p=1;
%     Computecost=zeros(Nummax,Servernum+1,Usernum);
%  Computecost(1:Nummax,1:Servernum,:)=rand(Nummax,Servernum,Usernum)*Computetotal/Tasktotal/5;
%  Computecost(1:Nummax,Servernum+1,:)=rand(Nummax,Usernum)*2*Computetotal/Tasktotal;
Avgdeleytemp=zeros(1,Num);
    Totalconsumptiontemp=zeros(1,Num);
    length=1;
while cycleindex<=Tasktotal-2
    while j<=Num
%  Computecost=zeros(Nummax,Servernum+1,Usernum);
%  Computecost(1:Nummax,1:Servernum,:)=zeros(Nummax,Servernum,Usernum)+Computetotal/Tasktotal/10;
%  Computecost(1:Nummax,Servernum+1,:)=zeros(Nummax,Usernum)+Computetotal/Tasktotal;
  Computecost=zeros(Nummax,Servernum+1,Usernum);
 Computecost(1:Nummax,1:Servernum,:)=rand(Nummax,Servernum,Usernum)*Computetotal/Tasktotal/5;
 Computecost(1:Nummax,Servernum+1,:)=rand(Nummax,Usernum)*2*Computetotal/Tasktotal;
    paralelconst=cycleindex;
   
    for k=1:Usernum
        Taskgraph(:,:,k)=Graphgenerateparalel(Tasktotal,Nummax,paralelconst);
    end
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
   Avgdeleytemp(1,j)=deley/Usernum; 
   Totalconsumptiontemp(1,j)=sum(Computeconsumption+Transmitconsumption);
j=j+1;
    end
    Avgdeley(1,length)=mean(Avgdeleytemp);
    Totalconsumption(1,length)=mean(Totalconsumptiontemp);
     length=length+1;
    j=1;
cycleindex=cycleindex*2;
end
plot(1:r,Avgdeley);



%以下为one server
cycleindex=1;
Avgdeleyoneserver=zeros(1,Num);
    Totalconsumptioneserver=zeros(1,Num);
    length=1;
    j=1;
while cycleindex<=Tasktotal-2
    while j<=Num
%  Computecost=zeros(Nummax,Servernum+1,Usernum);
%  Computecost(1:Nummax,1:Servernum,:)=zeros(Nummax,Servernum,Usernum)+Computetotal/Tasktotal/10;
%  Computecost(1:Nummax,Servernum+1,:)=zeros(Nummax,Usernum)+Computetotal/Tasktotal;
  Computecost=zeros(Nummax,Servernum+1,Usernum);
 Computecost(1:Nummax,1:Servernum,:)=rand(Nummax,Servernum,Usernum)*Computetotal/Tasktotal/5;
 Computecost(1:Nummax,Servernum+1,:)=rand(Nummax,Usernum)*2*Computetotal/Tasktotal;
    paralelconst=cycleindex;
   
    for k=1:Usernum
        Taskgraph(:,:,k)=Graphgenerateparalel(Tasktotal,Nummax,paralelconst);
    end
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
   Avgdeleytemp(1,j)=deley/Usernum; 
   Totalconsumptiontemp(1,j)=sum(Computeconsumption+Transmitconsumption);
j=j+1;
    end
    Avgdeleyoneserver(1,length)=mean(Avgdeleytemp);
    Totalconsumptioneserver(1,length)=mean(Totalconsumptiontemp);
     length=length+1;
    j=1;
cycleindex=cycleindex*2;
end


plot(1:r,Avgdeley);
hold on;
plot(1:r,Avgdeleyoneserver,'--');
hold on;

plot(1:r,Totalconsumption);
hold on;
plot(1:r,Totalconsumptioneserver,'--');
hold on;
% %%%%%以下为ToN
%   %paralelconst=cycleindex;
%    Tasknum=zeros(1,Usernum)+3;
%     Nummax=max(Tasknum);
%     Taskgraph=zeros(Nummax,Nummax,Usernum);
%     for k=1:Usernum
%         Taskgraph(:,:,k)=Graphgenerateparalel(3,Nummax,1);
%     end
%    Computecost=zeros(Nummax,Servernum+1,Usernum);
% %  Computecost(1:Nummax,1:Servernum,:)=zeros(Nummax,Servernum,Usernum)+Computetotal/10;
% %  Computecost(1:Nummax,Servernum+1,:)=zeros(Nummax,Usernum)+Computetotal;
% Computecost(1:Nummax,1:Servernum,:)=zeros(Nummax,Servernum,Usernum)+Computetotal/10;
%   Computecost(1:Nummax,Servernum+1,:)=zeros(Nummax,Usernum)+Computetotal;
%  Computecost(1,:,:)=0;
%    Computecost(3,:,:)=0;
%    Transdata=zeros(Nummax,Nummax,Usernum);
%    for u=1:Usernum
%    Transdata(1,2,u)=25;
%    Transdata(2,3,u)=5;
%    end
% [Schedule,Channel,Avgdeley,Usercurrent,avgdeleymin,point]=Game(Usernum,Servernum,Taskgraph,Tasknum,Transdata,Computecost,Transferrate,Comstartup,Iterationnum);
% for k=1:r
% Avgdeleyminton(1,k)=Avgdeley(1,Iterationnum);
% end
% 
% plot(1:r,Avgdeleymin);
% hold on;
% plot(1:r,Avgdeleyminton);