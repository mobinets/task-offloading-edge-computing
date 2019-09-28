function [Schedule,Schedulemin,Channelmin,avgdeleymin] = Centralforce(Usernum,Servernum,Taskgraph,Tasknum,Transdata,Computecost,Transferrate,Comstartup)
%UNTITLED 此处显示有关此函数的摘要
%   此处显示详细说明
Nummax=max(Tasknum);
N=0;
for k=1:Usernum
    N=N+Tasknum(1,k);
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
Q=Servernum+Usernum;
Local=zeros(1,Usernum)+Servernum+1;
Transferrateini=Transferrate;
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
Scheduletemp=Schedule;
Schedulemin=Scheduletemp;
Channelmin=Channel;
avgdeleymin=100000000;
Timeslot=0;
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
end

