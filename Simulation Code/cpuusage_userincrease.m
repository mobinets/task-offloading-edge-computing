Usernum=1;
Servernum=2;
Num=70;
Usage=zeros(1,Num);
Tasknum=zeros(1,Num)+10;
Nummax=max(Tasknum);
Iterationnum=100;
Avgdeley=zeros(1,Iterationnum);
Computetotal=150;
Tasktotal=Nummax;
N=0;
for i=1:Usernum
    N=N+Tasknum(1,i);
end
Taskgraph=zeros(Nummax,Nummax,Num);
%Taskgraph(:,:,1)=[0,-1,-1,-1,-1,-1,0,0,0,0;1,0,0,0,0,0,0,-1,-1,0;1,0,0,0,0,0,-1,0,0,0;1,0,0,0,0,0,0,-1,-1,0;1,0,0,0,0,0,0,0,-1,0;1,0,0,0,0,0,0,-1,0,0;0,0,1,0,0,0,0,0,0,-1;0,1,0,1,0,1,0,0,0,-1;0,1,0,1,1,0,0,0,0,-1;0,0,0,0,0,0,1,1,1,0]';
Taskgraph(:,:,1)=Graphgenerateparalel(Nummax,Nummax,Nummax-2);
for p=2:Num
Taskgraph(:,:,p)=Taskgraph(:,:,1);
end
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
[Schedule,Channel,Avgdeley,Usercurrent,avgdeleymin,point,Timeslot,Timeslotlast]=Game(Usernum,Servernum,Taskgraph,Tasknum,Transdata,Computecost,Transferrate,Comstartup,Iterationnum);
N=0;
for i=1:Usernum
    N=N+Tasknum(1,i);
end
Usage(1,Usernum)=CPUusage(Servernum,Schedule(:,((Iterationnum-1)*N+1):N*Iterationnum,1:Servernum),N,Timeslot,Timeslotlast);
Usernum=Usernum+1;
end
plot(1:Num,Usage);