Usernum=1;
Servernum=2;
Num=6;
Timecentral=zeros(1,Num);
Timedistribute=zeros(1,Num);
Centraldeley=zeros(1,Num);
Distributedeley=zeros(1,Num);
Tasknum=zeros(1,Num)+10;
Nummax=max(Tasknum);
Taskgraph=zeros(Nummax,Nummax,Num);
Taskgraph(:,:,1)=[0,-1,-1,-1,-1,-1,0,0,0,0;1,0,0,0,0,0,0,-1,-1,0;1,0,0,0,0,0,-1,0,0,0;1,0,0,0,0,0,0,-1,-1,0;1,0,0,0,0,0,0,0,-1,0;1,0,0,0,0,0,0,-1,0,0;0,0,1,0,0,0,0,0,0,-1;0,1,0,1,0,1,0,0,0,-1;0,1,0,1,1,0,0,0,0,-1;0,0,0,0,0,0,1,1,1,0]';
for p=2:Num
Taskgraph(:,:,p)=Taskgraph(:,:,1);
end
Transdata=rand(Nummax,Nummax,Num)*30;
Computecost=rand(Nummax,Servernum+1,Num)*50;
Transferrate=rand(Servernum+1,Servernum+1,Num)*50;
for p=1:Num
    for a=1:Servernum+1
        for b=1:Servernum+1
            if a<=b
                Transferrate(b,a,p)=Transferrate(a,b,p);
            end
        end
    end
end
Q=Servernum+Num;
Comstartup=rand(1,Q)*3;
Iterationnum=10;
while Usernum<=Num
t1=clock;
[Schedule,Schedulemin,Channelmin,avgdeleymin]=Centralforce(Usernum,Servernum,Taskgraph,Tasknum,Transdata,Computecost,Transferrate,Comstartup);
t2=clock;
Timecentral(1,Usernum)=etime(t2,t1);
t1=clock;
[Schedule,Channel,Avgdeley,Usercurrent,Avgdeleymin,point]=Game(Usernum,Servernum,Taskgraph,Tasknum,Transdata,Computecost,Transferrate,Comstartup,Iterationnum);
t2=clock;
Timedistribute(1,Usernum)=etime(t2,t1);
Usernum=Usernum+1;
end

plot(1:Num,Timecentral);
hold on;
plot(1:Num,Timedistribute,'--');

                
                
        
        
        
        
       