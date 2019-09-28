Usernum=20;
Servernum=10;
Computetotal=150;
Tasktotal=12;
Tasknum=zeros(1,Usernum)+Tasktotal;
    Nummax=max(Tasknum);
    Taskgraph=zeros(Nummax,Nummax,Usernum);
Avgdeleymin=zeros(1,Tasktotal-2);
Num=1;
Total=0;
j=1;
Avgdeleyminavg=zeros(1,Num);
Avgdeleyminton=zeros(1,Tasktotal-2);
Iterationnum=150;
User=0;
server=0;
Avgdeley=zeros(1,Iterationnum);
cycleindex=1;
Transferrate=(zeros(Servernum+1,Servernum+1,Usernum)+0.1)*40;
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
while cycleindex<=Tasktotal-2
    while j<=Num
 Computecost=zeros(Nummax,Servernum+1,Usernum);
 Computecost(1:Nummax,1:Servernum,:)=rand(Nummax,Servernum,Usernum)*Computetotal/Tasktotal/5;
 Computecost(1:Nummax,Servernum+1,:)=rand(Nummax,Usernum)*2*Computetotal/Tasktotal;

    Avgdeley=zeros(1,Iterationnum);
    paralelconst=cycleindex;
   
    for k=1:Usernum
        Taskgraph(:,:,k)=Graphgenerateparalel(Tasktotal,Nummax,paralelconst);
    end
[Schedule,Channel,Avgdeley,Usercurrent,avgdeleymin,point]=Game(Usernum,Servernum,Taskgraph,Tasknum,Transdata,Computecost,Transferrate,Comstartup,Iterationnum);
Total=Total+min([Avgdeley(1,Iterationnum),Avgdeley(1,Iterationnum-1),Avgdeley(1,Iterationnum-2)]);
j=j+1;
    end
    Avgdeleymin(1,cycleindex)=Total/Num;
    Total=0;
    j=1;
cycleindex=cycleindex+1;
end

%%%%%ÒÔÏÂÎªToN
  %paralelconst=cycleindex;
   Tasknum=zeros(1,Usernum)+3;
    Nummax=max(Tasknum);
    Taskgraph=zeros(Nummax,Nummax,Usernum);
    for k=1:Usernum
        Taskgraph(:,:,k)=Graphgenerateparalel(3,Nummax,1);
    end
   Computecost=zeros(Nummax,Servernum+1,Usernum);
%  Computecost(1:Nummax,1:Servernum,:)=zeros(Nummax,Servernum,Usernum)+Computetotal/10;
%  Computecost(1:Nummax,Servernum+1,:)=zeros(Nummax,Usernum)+Computetotal;
Computecost(1:Nummax,1:Servernum,:)=zeros(Nummax,Servernum,Usernum)+Computetotal/10;
  Computecost(1:Nummax,Servernum+1,:)=zeros(Nummax,Usernum)+Computetotal;
 Computecost(1,:,:)=0;
   Computecost(3,:,:)=0;
   Transdata=zeros(Nummax,Nummax,Usernum);
   for u=1:Usernum
   Transdata(1,2,u)=25;
   Transdata(2,3,u)=5;
   end
[Schedule,Channel,Avgdeley,Usercurrent,avgdeleymin,point]=Game(Usernum,Servernum,Taskgraph,Tasknum,Transdata,Computecost,Transferrate,Comstartup,Iterationnum);
for k=1:Tasktotal-2
Avgdeleyminton(1,k)=Avgdeley(1,Iterationnum);
end

plot(1:Tasktotal-2,Avgdeleymin);
hold on;
plot(1:Tasktotal-2,Avgdeleyminton);