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
Scheduletemp=Schedule;
Schedulemin=Scheduletemp;
Channelmin=Channel;
avgdeleymin=100000000;
Timeslot=0;
Timeslotlast=0;
%index=zeros(1,Servernum);
%while index(1,1)<
for i=1:Usernum   %i是向server1上卸载的用户数量
     Combinei=combntns(User,i);
    for j=1:Usernum 
        if i+j>Usernum
            break;
        end
        i+j
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
            
            
            
            for y=1:i
                Channeltemp(tempi(1,y),1)=1;
            end
            Channeltemp2=Channeltemp;
            permi=perms(tempi);
            for w=1:factorial(i)
                permii=permi(w,:);
                 Scheduletemp=Schedule;
                [Scheduletemp,Usercurrent]=Centralschedule(Scheduletemp,Taskgraph,N,Rank,Comstartup,Transdata,Transferrateini,Computecost,Channeltemp,Servernum,Usernum,1,Local,Timeslot,Timeslotlast,Tasknum,i,permii,Usercurrent);
                
                
%         Startsearch=0;
%         Scheduletemp=Schedule;
%         for k=1:Usernum
%            if Isin(k,permii,i)==0
%                continue;
%            end
%        schedulepart=zeros(2,N,Servernum+1);  
%        schedulepart(:,:,1:Servernum)=Scheduletemp(:,:,1:Servernum);
%        schedulepart(:,:,Servernum+1)=Scheduletemp(:,:,Servernum+k);
%        [schedulepart,Usercurrent(1,1,k)]=Uservote(k,schedulepart,Taskgraph(:,:,k),Tasknum(1,k),N,Rank(:,:,k),Comstartup,Transdata(:,:,k),Transferrateini,Computecost(:,:,k),Channeltemp,Servernum,Usernum,Startsearch,Tasknum(1,k),1,1,Local(1,k),Timeslot,Timeslotlast,Tasknum); 
%         Scheduletemp(:,:,1:Servernum)=schedulepart(:,:,1:Servernum);
%        Scheduletemp(:,:,Servernum+k)=schedulepart(:,:,Servernum+1);  
%         Startsearch=Startsearch+Tasknum(1,k);
%         end

        Combinej=combntns(Usertemp2,j);
        for x=1:nchoosek(Usernum-i,j)
            Channeltemp=Channeltemp2;
            tempj=Combinej(x,:);
            for y=1:j
                     Channeltemp(tempj(1,y),2)=1;
            end
        permj=perms(tempj);
        for v=1:factorial(j)
            permjj=permj(v,:);
         [Scheduletemp,Usercurrent]=Centralschedule(Scheduletemp,Taskgraph,N,Rank,Comstartup,Transdata,Transferrateini,Computecost,Channeltemp,Servernum,Usernum,2,Local,Timeslot,Timeslotlast,Tasknum,j,permjj,Usercurrent);
            
%             Startsearch=0;
%         for k=1:Usernum
%             if Isin(k,permjj,j)==0
%                 continue;
%             end
%        schedulepart=zeros(2,N,Servernum+1);  
%        schedulepart(:,:,1:Servernum)=Scheduletemp(:,:,1:Servernum);
%        schedulepart(:,:,Servernum+1)=Scheduletemp(:,:,Servernum+k);
%        [schedulepart,Usercurrent(1,2,k)]=Uservote(k,schedulepart,Taskgraph(:,:,k),Tasknum(1,k),N,Rank(:,:,k),Comstartup,Transdata(:,:,k),Transferrateini,Computecost(:,:,k),Channeltemp,Servernum,Usernum,Startsearch,Tasknum(1,k),1,2,Local(1,k),Timeslot,Timeslotlast,Tasknum); 
%         Scheduletemp(:,:,1:Servernum)=schedulepart(:,:,1:Servernum);
%        Scheduletemp(:,:,Servernum+k)=schedulepart(:,:,Servernum+1);  
%         Startsearch=Startsearch+Tasknum(1,k);
%         end

        vote=zeros(1,Usernum-(i+j));
            o=1;
            for t=1:Usernum
                if Isin(t,permii,i)==0 && Isin(t,permjj,j)==0
                    vote(1,o)=t;
                    o=o+1;
                end
            end
             [Scheduletemp,Usercurrent]=Centralschedule(Scheduletemp,Taskgraph,N,Rank,Comstartup,Transdata,Transferrateini,Computecost,Channeltemp,Servernum,Usernum,3,Local,Timeslot,Timeslotlast,Tasknum,Usernum-(i+j),vote,Usercurrent);


%         Startsearch=0;
%         for r=1:Usernum
%             if Channeltemp(r,1)+Channeltemp(r,2)==0
%             k=r;
%        schedulepart=zeros(2,N,Servernum+1);  
%        schedulepart(:,:,1:Servernum)=Scheduletemp(:,:,1:Servernum);
%        schedulepart(:,:,Servernum+1)=Scheduletemp(:,:,Servernum+k);
%        [schedulepart,Usercurrent(1,3,k)]=Uservote(k,schedulepart,Taskgraph(:,:,k),Tasknum(1,k),N,Rank(:,:,k),Comstartup,Transdata(:,:,k),Transferrateini,Computecost(:,:,k),Channeltemp,Servernum,Usernum,Startsearch,Tasknum(1,k),1,3,Local(1,k),Timeslot,Timeslotlast,Tasknum); 
%         Scheduletemp(:,:,1:Servernum)=schedulepart(:,:,1:Servernum);
%        Scheduletemp(:,:,Servernum+k)=schedulepart(:,:,Servernum+1);  
%             end
%             Startsearch=Startsearch+Tasknum(1,r);
%         end
        
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
                
               
                
                
        
        
        
        
        %{
        Combine=combntns(User,i+j);
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
      %      Combinei=combntns(Combine(t,:),i);
       %     Combinej=combntns(Combine(t,:),j);
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

%}