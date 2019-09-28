Usernum=20;
Servernum=2;
Computetotal=100;
Num=50;
Avgdeleymin=zeros(1,Num);
Iterationnum=100;
User=0;
server=0;
Avgdeley=zeros(1,Iterationnum);
tasknum=1;
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
Transferrateini=Transferrate;
Comstartup=(zeros(1,Num+Usernum)+0.1)*1;
 Local=zeros(1,Usernum)+Servernum+1;
    Channel=zeros(Usernum,Servernum);
    Q=Usernum+Servernum;
while tasknum<=Num
    paralelconst=max(tasknum-2,1);
    Tasknum=zeros(1,Usernum)+tasknum;
    Nummax=max(Tasknum);
    Taskgraph=zeros(Nummax,Nummax,Usernum);
    for k=1:Usernum
        Taskgraph(:,:,k)=Graphgenerateparalel(tasknum,Nummax,paralelconst);
    end
Transdata=(zeros(Nummax,Nummax,Usernum)+0.5/tasknum)*50;
 Computecost=zeros(Nummax,Servernum+1,Usernum);
 Computecost(1:Nummax,1:Servernum,:)=zeros(Nummax,Servernum,Usernum)+Computetotal/tasknum/10;
 Computecost(1:Nummax,Servernum+1,:)=zeros(Nummax,Usernum)+Computetotal/tasknum;
[Schedule,Channel,Avgdeley,Usercurrent,avgdeleymin,point,~,~]=Game(Usernum,Servernum,Taskgraph,Tasknum,Transdata,Computecost,Transferrate,Comstartup,Iterationnum);
Avgdeleymin(1,tasknum)=min([Avgdeley(1,Iterationnum),Avgdeley(1,Iterationnum-1)]);      
tasknum=tasknum+1;
end
plot(1:Num,Avgdeleymin);