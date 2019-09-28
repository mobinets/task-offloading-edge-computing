Usernum=50;
Servernum=10;
Tasknum=zeros(1,Usernum)+10;
%Tasknum(1,2)=1;
%Tasknum(1,2)=2;
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
%Taskgraph(:,:,2)=[0,-2,-2,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2];
%Taskgraph(:,:,2)=[0,1,-2,-2,-2,-2,-2,-2,-2,-2;-1,0,-2,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2];
%Taskgraph(:,:,2)=[0,0,-2,-2,-2,-2,-2,-2,-2,-2;0,0,-2,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2;-2,-2,-2,-2,-2,-2,-2,-2,-2,-2];
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
Comstartup=rand(1,Q)*3;
Computenergy=zeros(1,Usernum)+0.2;
Transmitpower=zeros(1,Usernum)+0.2;
alfa=zeros(1,Usernum)+0.5;
Size=zeros(Usernum,Nummax)+1;
Transferrateini=Transferrate;
Channel=zeros(Usernum,Servernum);
Channellast=Channel;
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
Scheduletotal=zeros(2,N,Q)-1;%是否已调度，初始时均未调度 为全-1矩阵
schedulenum=0;
Rankbackup=Rank;
Startsearch=zeros(1,Usernum);
basesearch=0;
for t=1:Usernum
    Startsearch(1,t)=basesearch;
    basesearch=basesearch+Tasknum(1,t);
end
Scheduletemp=Scheduletotal;
while schedulenum<N
    [Rankset,Actualnum]=Maxset(Rank,Tasknum,Usernum);
    for index=1:Usernum
        [user,temp]=Prioritymax(Taskgraph,Tasknum,Transdata,Transferrate,Rank,Rankset,Usernum,Servernum,alfa,Size,Computecost,Computenergy,Transmitpower,Local); 
        if user==-1
            break;
        end
        Rank(1,temp,user)=-1;
        Rankset(1,user)=-1;
        schedule=zeros(2,N,Servernum+1);
            schedule(:,:,1:Servernum)=Scheduletotal(:,:,1:Servernum);
            schedule(:,:,Servernum+1)=Scheduletotal(:,:,Servernum+user);
    
     for j=(Servernum+1):-1:1  %卸载到边缘服务器1上执行
             %if i==1&&j~=Local
            %continue; 不能绑定在某一个核上
           %  end
            if (temp==1||temp==Tasknum(1,user))&&j~=Local(1,user)
                continue;
            end
            m=j;
        if j>Servernum
            m=Servernum+user;
        end
        Finishtime=EFTcompute(Taskgraph(:,:,user),schedule,Scheduletemp(:,:,m),temp,j,Comstartup,Transdata(:,:,user),Transferrate(:,:,user),Computecost(:,:,user),N,Servernum+1,Tasknum(1,user),Startsearch(1,user),Timeslot);
        if j==Local(1,user) || FirstFinish>Finishtime 
            FirstFinish=Finishtime;
            processor=j;
            tempcore=j;
        end
     end
        schedule(2,temp+Startsearch(1,user),processor)=FirstFinish;
      schedule(1,temp+Startsearch(1,user),processor)=FirstFinish-Computecost(temp,tempcore,user);
      if processor==Local
          processor=Servernum+user;
      end
                   if Scheduletemp(1,N,processor)==-1
                   Scheduletemp(1,N,processor)=FirstFinish-Computecost(temp,tempcore,user);
                   Scheduletemp(2,N,processor)=FirstFinish;
                   else
                   Start=1;
                   End=N;
                   k=floor((Start+End)/2);
                   while Start~=End
                       if Scheduletemp(2,k,processor)==-1
                           Start=k+1;
                       else
                           End=k;
                       end
                       k=floor((Start+End)/2);
                   end
                   for t=k:N
                       if Scheduletemp(2,t,processor)>FirstFinish
                           Scheduletemp(1,t-1,processor)=FirstFinish-Computecost(temp,tempcore);
                           Scheduletemp(2,t-1,processor)=FirstFinish;
                           t=N-1;
                           break;
                       else
                           Scheduletemp(1,t-1,processor)=Scheduletemp(1,t,processor);
                           Scheduletemp(2,t-1,processor)=Scheduletemp(2,t,processor);
                       end
                   end
                   if t==N
                        Scheduletemp(1,t,processor)=FirstFinish-Computecost(temp,tempcore);
                        Scheduletemp(2,t,processor)=FirstFinish;
                   end
                   end
          Scheduletotal(:,:,1:Servernum)=schedule(:,:,1:Servernum);
          Scheduletotal(:,:,Servernum+user)=schedule(:,:,Servernum+1);
          %假设边缘服务器之间通过高速光纤连接，不考虑信道拥塞 这里还需要斟酌
    end
    schedulenum=schedulenum+Actualnum;
end
Deley=zeros(1,Usernum);
for i=1:Usernum
    Deley(1,i)=Scheduletotal(2,Startsearch(1,i)+Tasknum(1,i),Servernum+i)-Scheduletotal(1,Startsearch(1,i)+1,Servernum+i);
end
Avgdeley=mean(Deley);
Avgdeleyarray=zeros(1,100)+Avgdeley;
plot(1:100,Avgdeley,'--');
hold on;
    
    
%     %
%     schedule=zeros(2,N,Servernum+1);
%             schedule(:,:,1:Servernum)=Scheduletotal(:,:,1:Servernum);
%             schedule(:,:,Servernum+1)=Scheduletotal(:,:,Servernum+user);
%     
%      for j=(Servernum+1):-1:1  %卸载到边缘服务器1上执行
%              %if i==1&&j~=Local
%             %continue; 不能绑定在某一个核上
%            %  end
%             if (temp==1||temp==Tasknum(1,user))&&j~=Local(1,user)
%                 continue;
%             end
%             m=j;
%         if j>Servernum
%             m=Servernum+user;
%         end
%         Finishtime=EFTcompute(Taskgraph(:,:,user),schedule,Scheduletemp(:,:,m),temp,j,Comstartup,Transdata(:,:,user),Transferrate(:,:,user),Computecost(:,:,user),N,Servernum+1,Tasknum(1,user),Startsearch(1,user),Timeslot);
%         if j==Local(1,user) || FirstFinish>Finishtime 
%             FirstFinish=Finishtime;
%             processor=j;
%             tempcore=j;
%         end
%      end
%         schedule(2,temp+Startsearch(1,user),processor)=FirstFinish;
%       schedule(1,temp+Startsearch(1,user),processor)=FirstFinish-Computecost(temp,tempcore,user);
%       if processor==Local
%           processor=Servernum+user;
%       end
%                    if Scheduletemp(1,N,processor)==-1
%                    Scheduletemp(1,N,processor)=FirstFinish-Computecost(temp,tempcore,user);
%                    Scheduletemp(2,N,processor)=FirstFinish;
%                    else
%                    Start=1;
%                    End=N;
%                    k=floor((Start+End)/2);
%                    while Start~=End
%                        if Scheduletemp(2,k,processor)==-1
%                            Start=k+1;
%                        else
%                            End=k;
%                        end
%                        k=floor((Start+End)/2);
%                    end
%                    for t=k:N
%                        if Scheduletemp(2,t,processor)>FirstFinish
%                            Scheduletemp(1,t-1,processor)=FirstFinish-Computecost(temp,tempcore);
%                            Scheduletemp(2,t-1,processor)=FirstFinish;
%                            t=N-1;
%                            break;
%                        else
%                            Scheduletemp(1,t-1,processor)=Scheduletemp(1,t,processor);
%                            Scheduletemp(2,t-1,processor)=Scheduletemp(2,t,processor);
%                        end
%                    end
%                    if t==N
%                         Scheduletemp(1,t,processor)=FirstFinish-Computecost(temp,tempcore);
%                         Scheduletemp(2,t,processor)=FirstFinish;
%                    end
%                    end
%           Scheduletotal(:,:,1:Servernum)=schedule(:,:,1:Servernum);
%           Scheduletotal(:,:,Servernum+user)=schedule(:,:,Servernum+1);
%           %假设边缘服务器之间通过高速光纤连接，不考虑信道拥塞 这里还需要斟酌
%           schedulenum=schedulenum+1;
% end
% Deley=zeros(1,Usernum);
% for i=1:Usernum
%     Deley(1,i)=Scheduletotal(2,Startsearch(1,i)+Tasknum(1,i),Servernum+i)-Scheduletotal(1,Startsearch(1,i)+1,Servernum+i);
% end
% Avgdeley=mean(Deley);
% Avgdeleyarray=zeros(1,100)+Avgdeley;
% plot(1:100,Avgdeley,'--');
% hold on;