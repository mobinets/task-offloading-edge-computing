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
Transferrateini=Transferrate;
Comstartup=(zeros(1,Servernum+Num)+0.1)*3;
%Local=zeros(1,Num)+Servernum+1;

for k=1:Num
for i=1:Nummax
    if i>Tasknum(1,k)
        Taskgraph(i,i,k)=-3;
        continue;
    end
    Taskgraph(i,i,k)=mean(Computecost(i,:,k));
end
end
for k=1:Num
for i=1:Nummax
    for j=1:Nummax
        if Taskgraph(i,j,k)==1 &&i~=j
            Taskgraph(i,j,k)=mean(Comstartup(1:Servernum))+Comstartup(1,Servernum+k)+Transdata(i,j,k)/mean(Transferrate(1,:,k));%A(i,j)代表平均通讯时间
            Taskgraph(j,i,k)=-Taskgraph(i,j,k);
        elseif Taskgraph(i,j,k)==-2 &&i~=j
           Taskgraph(i,j,k)=0;
           Taskgraph(j,i,k)=-3;
        end
    end
end
end


while Usernum<=Num
N=0;
for k=1:Usernum
    N=N+Tasknum(1,k);
end
Q=Servernum+Usernum;
Channel=zeros(Usernum,Servernum);
Rank=zeros(1,Nummax,Usernum);
for k=1:Usernum
    Rank(:,:,k)=Rankup(Taskgraph(:,:,k),Nummax);
end
User=zeros(1,Usernum);
for i=1:Usernum
    User(1,i)=i;
end
Usercurrent=zeros(1,Servernum+1,Usernum)-1;
Schedule=zeros(2,N,Q)-1;
Scheduletemp=Schedule;
Schedulemin=Scheduletemp;
Channelmin=Channel;
avgdeleymin=100000000;
Timeslot=0;
Timeslotlast=0;
% index=zeros(1,Servernum);
% while index(1,1)

for i=0:Usernum   %i是向server1上卸载的用户数量
     Combinei=nchoosek(User,i);
    for j=0:Usernum 
        if i+j>Usernum
            break;
        end
        %Combine=zeros(1,nchoosek(Usernum,i));
        for q=1:nchoosek(Usernum,i)
            Channeltemp=Channel;
            Usertemp=User;
            tempi=Combinei(q,:); 
        for z=1:i
        Usertemp(1,tempi(1,z))=-1;
        end
        Usertemp2=zeros(1,Usernum-i);
        o=1;
        for z=1:Usernum
            if Usertemp(1,z)~=-1
                Usertemp2(1,o)=Usertemp(1,z);
                o=o+1;
            end
        end
         Combinej=nchoosek(Usertemp2,j);
            for y=1:i
                Channeltemp(tempi(1,y),1)=1;
            end
            Channeltemp2=Channeltemp;
            permi=perms(tempi);
            for w=1:factorial(i)
                permii=permi(w,:);
                 Scheduletemp=Schedule;
                [Scheduletemp,Usercurrent]=Centralschedule(Scheduletemp,Taskgraph,N,Rank,Comstartup,Transdata,Transferrateini,Computecost,Channeltemp,Servernum,Usernum,1,Local,Timeslot,Tasknum,i,permii,Usercurrent);  
        for x=1:nchoosek(Usernum-i,j)
            Channeltemp=Channeltemp2;
            tempj=Combinej(x,:);
            for y=1:j
                     Channeltemp(tempj(1,y),2)=1;
            end
        permj=perms(tempj);
        for v=1:factorial(j)
            permjj=permj(v,:);
         [Scheduletemp,Usercurrent]=Centralschedule(Scheduletemp,Taskgraph,N,Rank,Comstartup,Transdata,Transferrateini,Computecost,Channeltemp,Servernum,Usernum,2,Local,Timeslot,Tasknum,j,permjj,Usercurrent);

        vote=zeros(1,Usernum-(i+j));
            o=1;
            for t=1:Usernum
                if Isin(t,permii,i)==0 && Isin(t,permjj,j)==0
                    vote(1,o)=t;
                    o=o+1;
                end
            end
             [Scheduletemp,Usercurrent]=Centralschedule(Scheduletemp,Taskgraph,N,Rank,Comstartup,Transdata,Transferrateini,Computecost,Channeltemp,Servernum,Usernum,3,Local,Timeslot,Tasknum,Usernum-(i+j),vote,Usercurrent);
         avgdeley=0;
        for r=1:Usernum
            if Channeltemp(r,1)==1
                p=1;
            elseif Channeltemp(r,2)==1
                p=2;
            else
                p=3;
            end  
                avgdeley=avgdeley+Usercurrent(1,p,r);
        end
        if avgdeley<avgdeleymin
            avgdeleymin=avgdeley;
            Schedulemin=Scheduletemp;
            Channelmin=Channeltemp;
        end
        
        end
            end
        end
    end
    end
end
avgdeleymin=avgdeleymin/Usernum;
Centraldeley(1,Usernum)=avgdeleymin;

Iterationnum=100;
Usercurrentupdate=zeros(1,Usernum);
Userfinishupdate=zeros(1,Usernum);
Userlastupdate=zeros(1,Usernum);
Schedule=zeros(2,(N)*Iterationnum,Q)-1;%是否已调度，初始时均未调度 为全-1矩阵
Start=1;
Avgdeley=zeros(1,Iterationnum);
Timeslotarray=zeros(Iterationnum,1);
Channellast=Channel;
for i=1:Iterationnum
    %scheduletemp=zeros(2,N*i,Servernum+1);
    if i~=1
        Start=N*(i-2)+1;
    end
    len=N*i-Start+1;
    scheduleserver=Schedule(:,Start:N*i,1:Servernum);
    schedulevote=zeros(2,len,Servernum+1,Servernum+1,Usernum);
     scheduletemp=zeros(2,len,Servernum+1);
     scheduletemp2=zeros(2,N,Usernum);
     for k=1:Usernum
         for p=1:Servernum+1
    schedulevote(:,1:len,1:Servernum,p,k)=scheduleserver;
    schedulevote(:,1:len,Servernum+1,p,k)=Schedule(:,Start:N*i,Servernum+k);
         end
     end
     Startsearch=len-N;
    for k=1:Usernum
        scheduletemp(:,:,:)=schedulevote(:,:,1:Servernum+1,1,k);
        for p=1:Servernum+1
            %scheduletemp(:,:,:)=schedulevote(:,:,1:Servernum+1,p,k);
      [schedulevote(:,1:len,1:Servernum+1,p,k),Usercurrent(1,p,k)]=Uservote(k,scheduletemp,Taskgraph(:,:,k),Tasknum(1,k),len,Rank(:,:,k),Comstartup,Transdata(:,:,k),Transferrateini,Computecost(:,:,k),Channel,Servernum,Usernum,Startsearch,Tasknum(1,k),1,p,Local(1,k),Timeslot,Timeslotlast,Tasknum); 
        end
         Startsearch=Startsearch+Tasknum(1,k);
    end
    for k=1:Usernum
    scheduletemp2(:,:,k)=schedulevote(:,len-N+1:len,Servernum+1,Servernum+1,k);
    end
    if i~=1
         [User,server]=Userupdatechose(Usercurrent,Userlastupdate,Servernum,Usernum); 
         [Schedule(:,N*(i-1)+1:N*i,:),Usercurrentupdate,Userfinishupdate] = Updatechannelschedule(User,server,Channel,Schedule(:,N*(i-1)+1:N*i,:),scheduletemp2,Usercurrent(:,Servernum+1,:),Taskgraph,Rank,Comstartup,Transdata,Transferrate,Computecost,Tasknum,N,Usernum,Local,Servernum+1,Timeslot,Transferrateini,Servernum);
    else
        Schedule(:,N*(i-1)+1:N*i,:)=Updateschedule(Schedule(:,N*(i-1)+1:N*i,:),scheduletemp2,Tasknum,Usernum,Servernum);
        for k=1:Usernum
        Usercurrentupdate(1,k)=Usercurrent(1,Servernum+1,k);
        Userfinishupdate(1,k)=Usercurrentupdate(1,k);
        end
    end
    Timeslotlast=Timeslot;
    Timeslot=max(Userfinishupdate);
    Avgdeley(1,i)=mean(Usercurrentupdate);
%    if Avgdeley(1,i)<avgdeleymin
%        1/0
%    end
    for k=1:Usernum
        Userlastupdate(1,k)=Usercurrentupdate(1,k);
    end
     if i~=1
    Channellast=Channel;
    if equal(Channellast,Channel,Usernum,Servernum)==1 && Avgdeley(1,i)>Avgdeley(1,i-1)
        for k=i:Iterationnum
            Avgdeley(1,k)=Avgdeley(1,i-1);
        end
        Distributedeley(1,Usernum)=Avgdeley(1,i-1);
        break;
    end
    [Channel]=UpdateChannel(Channel,User,server,Servernum,Local(1,User));
     end
end
Usernum=Usernum+1;
end
plot(1:Num,Centraldeley,'--');
hold on;
plot(1:Num,Distributedeley);
% plot([1,Iterationnum],[avgdeleymin,avgdeleymin],'--');
% 
% plot(1:Num,Timecentral);
% hold on;
% plot(1:Num,Timedistribute,'--');

% plot(1:Num,Centraldeley,'--');
% hold on;
% plot(1:Num,Distributedeley);

                
                
        
        
        
        
       