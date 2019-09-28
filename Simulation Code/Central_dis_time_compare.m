Usernum=1;
Servernum=2;
Num=6;
Avgdeleymin=zeros(1,Num);

Tasknum=zeros(1,Num)+10;
%Tasknum(1,2)=1;
%Tasknum(1,2)=2;
%Tasknum(1,2)=3;
Nummax=max(Tasknum);
Iterationnum=100;
User=0;
server=0;
Avgdeley=zeros(1,Iterationnum);
Avgdeleycentral=zeros(1,Num);
Avgdeleydistribute=zeros(1,Num);
Timeslotarray=zeros(Iterationnum,1);
Taskgraph=zeros(Nummax,Nummax,Num);
Taskgraph(:,:,1)=[0,-1,-1,-1,-1,-1,0,0,0,0;1,0,0,0,0,0,0,-1,-1,0;1,0,0,0,0,0,-1,0,0,0;1,0,0,0,0,0,0,-1,-1,0;1,0,0,0,0,0,0,0,-1,0;1,0,0,0,0,0,0,-1,0,0;0,0,1,0,0,0,0,0,0,-1;0,1,0,1,0,1,0,0,0,-1;0,1,0,1,1,0,0,0,0,-1;0,0,0,0,0,0,1,1,1,0]';
for p=2:Num
Taskgraph(:,:,p)=Taskgraph(:,:,1);
end
%Taskgraph(:,:,2)=[0,-2,-2,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2];
%Taskgraph(:,:,2)=[0,1,-2,-2,-2,-2,-2,-2,-2,-2;-1,0,-2,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2];
%Taskgraph(:,:,2)=[0,0,-2,-2,-2,-2,-2,-2,-2,-2;0,0,-2,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2];
%Taskgraph(:,:,2)=[0,1,0,-2,-2,-2,-2,-2,-2,-2;-1,0,1,-2,-2,-2,-2,-2,-2,-2;0,-1,0,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2];
Transdata=(zeros(Nummax,Nummax,Num)+0.4)*30;
Computecost=(zeros(Nummax,Servernum+1,Num)+0.3)*50;
Transferrate=(zeros(Servernum+1,Servernum+1,Num)+0.26)*30;
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
Iterationnum=100;



while Usernum<=Num
[Schedule,Schedulemin,Channelmin,avgdeleymin]=Centralforce(Usernum,Servernum,Taskgraph,Tasknum,Transdata,Computecost,Transferrate,Comstartup);
Avgdeleycentral(1,Usernum)=avgdeleymin;
[Schedule,Channel,Avgdeley,Usercurrent,Avgdeleymin,point]=Game(Usernum,Servernum,Taskgraph,Tasknum,Transdata,Computecost,Transferrate,Comstartup,Iterationnum);
Avgdeleydistribute(1,Usernum)=min([Avgdeley(1,Iterationnum),Avgdeley(1,Iterationnum-1)]);
Usernum=Usernum+1;
end
plot(1:Num,Avgdeleycentral,'--');
hold on;
plot(1:Num,Avgdeleydistribute);
% plot([1,Iterationnum],[avgdeleymin,avgdeleymin],'--');
% 
% plot(1:Num,Timecentral);
% hold on;
% plot(1:Num,Timedistribute,'--');

% plot(1:Num,Centraldeley,'--');
% hold on;
% plot(1:Num,Distributedeley);

                
                
        
        
        
        
       