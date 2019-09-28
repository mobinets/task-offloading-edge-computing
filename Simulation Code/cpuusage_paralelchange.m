Usernum=20;
Servernum=2;
Computetotal=1000;
Tasktotal=12;
Tasknum=zeros(1,Usernum)+Tasktotal;
    Nummax=max(Tasknum);
    Taskgraph=zeros(Nummax,Nummax,Usernum);
Avgdeleymin=zeros(1,Tasktotal-2);
Num=15;
Total=0;
j=1;
Usage=zeros(1,Tasktotal-2);
Iterationnum=100;
User=0;
server=0;
Avgdeley=zeros(1,Iterationnum);
N=0;
for i=1:Usernum
    N=N+Tasknum(1,i);
end
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
    paralelconst=cycleindex;   
    for k=1:Usernum
        Taskgraph(:,:,k)=Graphgenerateparalel(Tasktotal,Nummax,paralelconst);
    end
[Schedule,Channel,Avgdeley,Usercurrent,avgdeleymin,point,Timeslot,Timeslotlast]=Game(Usernum,Servernum,Taskgraph,Tasknum,Transdata,Computecost,Transferrate,Comstartup,Iterationnum);
Total=Total+CPUusage(Servernum,Schedule(:,((Iterationnum-1)*N+1):N*Iterationnum,1:Servernum),N,Timeslot,Timeslotlast);    
j=j+1;
    end
    Usage(1,cycleindex)=Total/Num;
    Total=0;
    j=1;
cycleindex=cycleindex+1;
end
plot(1:Tasktotal-2,Usage);