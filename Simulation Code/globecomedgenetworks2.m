function [Scheduletotal,Computeconsumption,Transmitconsumption] = globecomedgenetworks2(Usernum,Servernum,Local,Taskgraph,Tasknum,Transdata,Computecost,Transferrate,Comstartup,Computenergy,Transmitpower,alfa,Size)
%GLOBECOMEDGENETWORKS 此处显示有关此函数的摘要
%   此处显示详细说明
Timeslot=0;
Nummax=max(Tasknum);
Computeconsumption=zeros(1,Usernum);
Transmitconsumption=zeros(1,Usernum);
for k=1:Usernum
for i=1:Nummax
    if i>Tasknum(1,k)
        Taskgraph(i,i,k)=-3;
        continue;
    end
    Taskgraph(i,i,k)=mean(Computecost(i,:,k));
end
end
N=0;
for k=1:Usernum
    N=N+Tasknum(1,k);
end
Q=Servernum+Usernum;
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
Startsearch=zeros(1,Usernum);
basesearch=0;
for t=1:Usernum
    Startsearch(1,t)=basesearch;
    basesearch=basesearch+Tasknum(1,t);
end
while schedulenum<N
    [Rankset,Actualnum]=Maxset(Rank,Tasknum,Usernum);
        [user,temp]=Prioritymax(Taskgraph,Tasknum,Transdata,Transferrate,Rank,Rankset,Usernum,Servernum,alfa,Size,Computecost,Computenergy,Transmitpower,Local); 
        if user==-1
            break;
        end
        Rank(1,temp,user)=-1;
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
      if processor==Local(1,user)
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
          %假设边缘服务器之间通过高速光纤连接，不考虑信道拥塞 这里还需要斟
    schedulenum=schedulenum+1;
end
for i=1:Usernum
    for j=1:Tasknum(1,i)
        offloading=-1;
        for k=1:Servernum
            if Scheduletotal(1,j+Startsearch(1,i),k)~=-1
                offloading=k;
                break;
            end
        end
        if offloading==-1 %本地执行
            Computeconsumption(1,i)=Computeconsumption(1,i)+Computenergy(1,i)*Computecost(j,Local(1,i),i);
        else %非本地执行
            Transmitconsumption(1,i)=Transmitconsumption(1,i)+Transmitpower(1,i)*Size(i,j)/Transferrate(Local(1,i),offloading,i);
        end
        end
    end
end

