function [Scheduletotal,Computeconsumption,Transmitconsumption] = globecomonedge(Usernum,Servernum,Local,Taskgraph,Tasknum,Transdata,Computecost,Transferrate,Comstartup,Computenergy,Transmitpower,alfa,Size)
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

Tasknum2=zeros(1,Usernum)+3;
    Nummax2=max(Tasknum2);
    Taskgraph2=zeros(Nummax2,Nummax2,Usernum);
    for k=1:Usernum
        Taskgraph2(:,:,k)=Graphgenerateparalel(3,Nummax2,1);
    end
    Computecost2=zeros(3,Servernum+1,Usernum);
     Computecost2(1,:,:)=0;
   Computecost2(3,:,:)=0;
   for l=1:Usernum
       for h=1:Servernum+1
   Computecost2(2,h,l)=sum(Computecost(1:Tasknum(1,l),h,l));
       end
   end

   for k=1:Usernum
for i=1:Nummax2
    if i>Tasknum2(1,k)
        Taskgraph2(i,i,k)=-3;
        continue;
    end
    Taskgraph2(i,i,k)=mean(Computecost2(i,:,k));
end
end
N2=0;
for k=1:Usernum
    N2=N2+Tasknum2(1,k);
end
Q=Servernum+Usernum;
for k=1:Usernum
for i=1:Nummax2
    for j=1:Nummax2
        if Taskgraph2(i,j,k)==1 &&i~=j
            Taskgraph2(i,j,k)=mean(Comstartup(1:Servernum))+Comstartup(1,Servernum+k)+Transdata(i,j,k)/mean(Transferrate(1,:,k));%A(i,j)代表平均通讯时间 Transdata应该影响不大
            Taskgraph2(j,i,k)=-Taskgraph2(i,j,k);
        elseif Taskgraph2(i,j,k)==-2 &&i~=j
           Taskgraph2(i,j,k)=0;
           Taskgraph2(j,i,k)=-3;
        end
    end
end
end

Rank2=zeros(1,Nummax2,Usernum);
for k=1:Usernum
    Rank2(:,:,k)=Rankup(Taskgraph2(:,:,k),Nummax2);
end
Size2=zeros(Usernum,3);
Size2(:,1)=0;
Size2(:,3)=0;
for o=1:Usernum
Size2(o,2)=sum(Size(o,1:Tasknum(1,o)));
end
Scheduletotal=zeros(2,N,Q)-1;%是否已调度，初始时均未调度 为全-1矩阵
schedulenum=0;
Rankbackup=Rank;
Rankbackup2=Rank2;
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
    [Rankset,Actualnum]=Maxset(Rank2,Tasknum2,Usernum);
    for index=1:Usernum
        [user,temp]=Prioritymax(Taskgraph2,Tasknum2,Transdata,Transferrate,Rank2,Rankset,Usernum,Servernum,alfa,Size2,Computecost2,Computenergy,Transmitpower,Local); 
        if user==-1
            break;
        end
        Rank2(1,temp,user)=-1;
        Rankset(1,user)=-1;
         Schedule=zeros(2,N,Servernum+1);
            Schedule(:,:,1:Servernum)=Scheduletotal(:,:,1:Servernum);
            Schedule(:,:,Servernum+1)=Scheduletotal(:,:,Servernum+user);
            Scheduleini=Schedule;
            mindeley=Inf;
            Inmin=1;
            for In=1:Servernum+1
                Schedule=Scheduleini;
            [Schedule]=schedule(Taskgraph(:,:,user),Tasknum(1,user),N,Rank,Comstartup,Transdata(:,:,user),Transferrate(:,:,user),Computecost(:,:,user),Servernum+1,Schedule,Startsearch(1,user),Local(1,user),In,1,0);
            deley=Schedule(2,Startsearch(1,user)+Tasknum(1,user),Servernum+1)-Schedule(1,Startsearch(1,user)+1,Servernum+1);
            if deley<mindeley
                mindeley=deley;
                Inmin=In;
            end
            end
            Schedule=Scheduleini;
            [Schedule]=schedule(Taskgraph(:,:,user),Tasknum(1,user),N,Rank,Comstartup,Transdata(:,:,user),Transferrate(:,:,user),Computecost(:,:,user),Servernum+1,Schedule,Startsearch(1,user),Local(1,user),Inmin,1,0);
         Scheduletotal(:,:,1:Servernum)=Schedule(:,:,1:Servernum);
          Scheduletotal(:,:,Servernum+user)=Schedule(:,:,Servernum+1);
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