Usernum=6;
Servernum=2;
Tasknum=zeros(1,Usernum)+10;
Tasknum(1,2)=3;
Nummax=max(Tasknum);
N=0;
for k=1:Usernum
    N=N+Tasknum(1,k);
end
Q=Servernum+Usernum;
Local=zeros(1,Usernum)+Servernum+1;
Taskgraph=zeros(Nummax,Nummax,Usernum);
Taskgraph(:,:,1)=[0,-1,-1,-1,-1,-1,0,0,0,0;1,0,0,0,0,0,0,-1,-1,0;1,0,0,0,0,0,-1,0,0,0;1,0,0,0,0,0,0,-1,-1,0;1,0,0,0,0,0,0,0,-1,0;1,0,0,0,0,0,0,-1,0,0;0,0,1,0,0,0,0,0,0,-1;0,1,0,1,0,1,0,0,0,-1;0,1,0,1,1,0,0,0,0,-1;0,0,0,0,0,0,1,1,1,0]';
for p=3:Usernum
Taskgraph(:,:,p)=Taskgraph(:,:,1);
end
Taskgraph(:,:,2)=[0,1,0,-2,-2,-2,-2,-2,-2,-2;-1,0,1,-2,-2,-2,-2,-2,-2,-2;0,-1,0,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2];

Transdata=rand(Nummax,Nummax,Usernum)*30;
Computecost=rand(Nummax,Servernum+1,Usernum)*50;
Transferrate=rand(Servernum+1,Servernum+1,Usernum)*50;
for p=1:Usernum
    for a=1:Servernum+1
        for b=1:Servernum+1
            if a<=b
                Transferrate(b,a,p)=Transferrate(a,b,p);
            end
        end
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
Transferrateini=Transferrate;
Comstartup=rand(1,Q)*3;
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
Schedulemin=Scheduletemp;
Channelmin=Channel;
avgdeleymin=100000000;
Timeslot=0;
Timeslotlast=0;
%index=zeros(1,Servernum);
%while index(1,1)<
for i=0:Usernum   %i是向server1上卸载的用户数量
    for j=0:Usernum 
        if i+j>Usernum
            break;
        end
        %Combine=zeros(1,nchoosek(Usernum,i));
        Combine=nchoosek(User,i+j);
        for t=1:nchoosek(Usernum,i+j)
        perm=perms(Combine(t,:));
        for k=1:factorial(i+j) %1:perm的行数，也就是i+j个元素的排列数
        %    k
         Channeltemp=Channel;
        updatei=perm(k,1:i);
        updatej=perm(k,i+1:i+j);
        for temp1=1:i
            Channeltemp(updatei(1,temp1),1)=1;
        end
        for temp1=1:j
            Channeltemp(updatej(1,temp1),2)=1;
        end
        Startsearch=0;
        Scheduletemp=Schedule;
        for k=1:Usernum
            if Channeltemp(k,1)==1
                p=1;
            elseif Channeltemp(k,2)==1
                p=2;
            else
                p=3;
            end
     %   [Comstartuptemp]=Comstartupart(Comstartup,1,s);
       % schedule(Taskgraph(:,:,s),Tasknum(1,s),N,Rank(:,:,s),Comstartuptemp,Transdata(:,:,s),Transferrate2(:,:,User),Computecost,Servernum+1,scheduletemp(:,N-Nlast+1:N,:),mod(Startsearch,Nlast),Local,servercandidate,1,Timeslot);
       schedulepart=zeros(2,N,Servernum+1);  
       schedulepart(:,:,1:Servernum)=Scheduletemp(:,:,1:Servernum);
       schedulepart(:,:,Servernum+1)=Scheduletemp(:,:,Servernum+k);
       [schedulepart,Usercurrent(1,p,k)]=Uservote(k,schedulepart,Taskgraph(:,:,k),Tasknum(1,k),N,Rank(:,:,k),Comstartup,Transdata(:,:,k),Transferrateini,Computecost(:,:,k),Channeltemp,Servernum,Usernum,Startsearch,Tasknum(1,k),1,p,Local(1,k),Timeslot,Timeslotlast,Tasknum); 
        Scheduletemp(:,:,1:Servernum)=schedulepart(:,:,1:Servernum);
       Scheduletemp(:,:,Servernum+k)=schedulepart(:,:,Servernum+1);  
        Startsearch=Startsearch+Tasknum(1,k);
        end
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
avgdeleymin=avgdeleymin/Usernum;
%{
     %   for t=1:nchoosek(Usernum,i+j)
      %      Combinei=nchoosek(Combine(t,:),i);
       %     Combinej=nchoosek(Combine(t,:),j);
       % end
        for k=1:nchoosek(Combine(1,:),i)
            tempi=Combinei(k,:);
                    for k2=1:i
                        Channeltemp(tempi(1,k3),1)=1;
                    end
                    for p=1:nchoosek(Combine(1,:),j)
                        
        for t=1:nchoosek(Combine(1,:),i)
            permi=perms(Combinei);
            permj=perms(Combinej);
        end
   %} 





Iterationnum=100;
Usercurrentupdate=zeros(1,Usernum);
Userfinishupdate=zeros(1,Usernum);
Userlastupdate=zeros(1,Usernum);
Schedule=zeros(2,(N)*Iterationnum,Q)-1;%是否已调度，初始时均未调度 为全-1矩阵
Start=1;
Avgdeley=zeros(1,Iterationnum);
Timeslotarray=zeros(Iterationnum,1);
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
    [Channel]=UpdateChannel(Channel,User,server,Servernum,Local(1,User));
     end
end
plot(1:1:Iterationnum,Avgdeley);
hold on;
plot([1,Iterationnum],[avgdeleymin,avgdeleymin],'--');

