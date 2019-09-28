Usernum=30;
Servernum=1;
Computetotal=1;
Num=20;
Avgdeleymin=zeros(1,Num);
Tasknum=zeros(1,Usernum)+10;
%Tasknum(1,2)=1;
%Tasknum(1,2)=2;
%Tasknum(1,2)=3;
Nummax=max(Tasknum);
Iterationnum=100;
User=0;
server=0;
Avgdeley=zeros(1,Iterationnum);
Timeslotarray=zeros(Iterationnum,1);
Taskgraph=zeros(Nummax,Nummax,Usernum);
Taskgraph(:,:,1)=[0,-1,-1,-1,-1,-1,0,0,0,0;1,0,0,0,0,0,0,-1,-1,0;1,0,0,0,0,0,-1,0,0,0;1,0,0,0,0,0,0,-1,-1,0;1,0,0,0,0,0,0,0,-1,0;1,0,0,0,0,0,0,-1,0,0;0,0,1,0,0,0,0,0,0,-1;0,1,0,1,0,1,0,0,0,-1;0,1,0,1,1,0,0,0,0,-1;0,0,0,0,0,0,1,1,1,0]';
for p=2:Num
Taskgraph(:,:,p)=Taskgraph(:,:,1);
end
%Taskgraph(:,:,2)=[0,-2,-2,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2];
%Taskgraph(:,:,2)=[0,1,-2,-2,-2,-2,-2,-2,-2,-2;-1,0,-2,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2];
%Taskgraph(:,:,2)=[0,0,-2,-2,-2,-2,-2,-2,-2,-2;0,0,-2,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2];
%Taskgraph(:,:,2)=[0,1,0,-2,-2,-2,-2,-2,-2,-2;-1,0,1,-2,-2,-2,-2,-2,-2,-2;0,-1,0,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2];
Transdata=(zeros(Nummax,Nummax,Usernum)+0.3)*20;
            %Computecost=(zeros(Nummax,Servernum+1,Num)+0.2)*50;
Transferrate=(zeros(Num+1,Num+1,Usernum)+0.3)*40;
for p=1:Usernum
    for a=1:Num+1
        for b=1:Num+1
            if a<=b
                Transferrate(b,a,p)=Transferrate(a,b,p);
            end
        end
    end
end
Transferrateini=Transferrate;
Comstartup=(zeros(1,Num+Usernum)+0.1)*1;
%Local=zeros(1,Num)+Servernum+1;
   N=0;
for k=1:Usernum
    N=N+Tasknum(1,k);
end
%Q=Num+Usernum;
%Local=zeros(1,Usernum)++1;
 % Channel=zeros(Usernum,Num);
  % Computecost=zeros(Nummax,Num+1,Usernum);
 
  
  
while Servernum<=Num
    Local=zeros(1,Usernum)+Servernum+1;
    Channel=zeros(Usernum,Servernum);
    Q=Usernum+Servernum;
  Computecost=zeros(Nummax,Servernum+1,Usernum);
  for u=1:Usernum
   for p=1:Servernum
 for y=1:Nummax
   Computecost(y,p,u)=Servernum*Computetotal;
 end
   end
  end
 
    for u=1:Usernum
 for y=1:Nummax
   Computecost(y,Servernum+1,u)=Computetotal*Num*2;
 end
    end
  
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
    
Timeslot=0;
Timeslotlast=0;
Usercurrent=zeros(1,Servernum+1,Usernum);
Usercurrentupdate=zeros(1,Usernum);
Userfinishupdate=zeros(1,Usernum);
Userlastupdate=zeros(1,Usernum);
% for k=1:Usernum
% for i=1:Nummax
%     if i>Tasknum(1,k)
%         Taskgraph(i,i,k)=-3;
%         continue;
%     end
%     Taskgraph(i,i,k)=mean(Computecost(i,:,k));
% end
% end
% for k=1:Usernum
% for i=1:Nummax
%     for j=1:Nummax
%         if Taskgraph(i,j,k)==1 &&i~=j
%             Taskgraph(i,j,k)=mean(Comstartup(1:Servernum))+Comstartup(1,Servernum+k)+Transdata(i,j,k)/mean(Transferrate(1,:,k));%A(i,j)代表平均通讯时间
%             Taskgraph(j,i,k)=-Taskgraph(i,j,k);
%         elseif Taskgraph(i,j,k)==-2 &&i~=j
%            Taskgraph(i,j,k)=0;
%            Taskgraph(j,i,k)=-3;
%         end
%     end
% end
% end
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
%     if equal(Channellast,Channel,Usernum,Servernum)==1 && Avgdeley(1,i)>Avgdeley(1,i-1)
%         for k=i:Iterationnum
%             Avgdeley(1,k)=Avgdeley(1,i-1);
%         end
%         Avgdeleymin(1,n)=Avgdeley(1,i-1);
%         break;
%     end
    [Channel]=UpdateChannel(Channel,User,server,Servernum,Local(1,User));
     end
end
Avgdeleymin(1,Servernum)=(Avgdeley(1,Iterationnum)+Avgdeley(1,Iterationnum-1))/2;
Servernum=Servernum+1;
end
plot(1:Num,Avgdeleymin);