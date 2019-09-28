function [Schedule,Channel,Avgdeley,Usercurrent,Avgdeleymin,Convergencepoint,Timeslot,Timeslotlast] = Game(Usernum,Servernum,Taskgraph,Tasknum,Transdata,Computecost,Transferrate,Comstartup,Iterationnum)
%GAME 此处显示有关此函数的摘要
%   此处显示详细说明
Nummax=max(Tasknum);
N=0;
for k=1:Usernum
    N=N+Tasknum(1,k);
end
Q=Servernum+Usernum;
Local=zeros(1,Usernum)+Servernum+1;
User=0;
server=0;
Avgdeley=zeros(1,Iterationnum);
%Timeslotarray=zeros(Iterationnum,1);
Transferrateini=Transferrate;
Channel=zeros(Usernum,Servernum);
Channellast=Channel;
Avgdeleymin=0;
avg=-1;
Convergencepoint=-1;
Timeslot=0;
Timeslotlast=0;
Usercurrent=zeros(1,Servernum+1,Usernum);
Usercurrentupdate=zeros(1,Usernum);
Userfinishupdate=zeros(1,Usernum);
Userlastupdate=zeros(1,Usernum);
for k=1:Usernum
for i=1:Nummax
    if i>Tasknum(1,k)
        Taskgraph(i,i,k)=-3;
        continue;
    end
    Taskgraph(i,i,k)=mean(Computecost(i,:,k));
end
end
for k=1:Usernum
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
Rank=zeros(1,Nummax,Usernum);
for k=1:Usernum
    Rank(:,:,k)=Rankup(Taskgraph(:,:,k),Nummax);
end
Schedule=zeros(2,(N)*Iterationnum,Q)-1;%是否已调度，初始时均未调度 为全-1矩阵
%scheduletemp=Schedule;
Start=1;
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
    for k=1:Usernum
        Userlastupdate(1,k)=Usercurrentupdate(1,k);
    end
     if i~=1
         Channellast=Channel;
         [Channel]=UpdateChannel(Channel,User,server,Servernum,Local(1,User));
          if ((Avgdeley(1,i-1)+Avgdeley(1,i))/2)~=avg  %这里是有点问题
%         for k=i:Iterationnum
%             Avgdeley(1,k)=Avgdeley(1,i-1);
%         end
        Avgdeleymin=Avgdeley(1,i-1);
        avg=(Avgdeleymin+Avgdeley(1,i))/2;
        Convergencepoint=i-1;
     
          end
     end
end
end

