function [scheduletemp,usercurrent] = Uservote(User,scheduletemp,Taskgraph,n,N,Rank,Comstartup,Transdata,Transferrateini,Computecost,Channel,Servernum,Usernum,Startsearch,End1,End2,servercandidate,Local,Timeslot,Timeslotlast,Tasknum)
%USERVOTE 此处显示有关此函数的摘要
%   此处显示详细说明
Nlast=0;
flag=0;
for j=1:Usernum
Nlast=Nlast+Tasknum(1,j);
end
 Transferrate=Transferrateini;
 Transferrate2=Transferrate;
 Transferrate22=Transferrate;
 delta=0;
 if servercandidate~=Local
 [Transferrate22]=Recomputecom(servercandidate,Channel,Transferrate,Transferrateini,Usernum,Servernum);
     if Channel(User,servercandidate)~=1
         Channel(User,servercandidate)=1;
     else 
         flag=1;
     end
[Transferrate2]=Recomputecom(servercandidate,Channel,Transferrate,Transferrateini,Usernum,Servernum);
 end
 for k=1:Usernum
     if k==User
         continue;
     end
 delta=delta+Transferrate22(servercandidate,Local,k)-Transferrate2(servercandidate,Local,k);
 end
 if delta~=0
delta=delta/(Usernum-1);
 end
 if Startsearch>Nlast && servercandidate~=Local
     for k=Nlast+1:N
         if scheduletemp(1,k-Nlast,servercandidate)==-1
             continue;
         end
         scheduletemp(1,k,servercandidate)=scheduletemp(1,k-Nlast,servercandidate)+Timeslot-Timeslotlast;
         scheduletemp(2,k,servercandidate)=scheduletemp(2,k-Nlast,servercandidate)+Timeslot-Timeslotlast;
         %scheduletemp(:,(N-Nlast+1):N,servercandidate)=scheduletemp(:,(N-2*Nlast+1):(N-Nlast),servercandidate)+Timeslot;
     end
 end
 if flag==1 && N>Nlast
     usercurrent=scheduletemp(2,Startsearch+End1-Nlast,Servernum+1)-scheduletemp(1,Startsearch+End2-Nlast,Servernum+1);
     
     if Startsearch>Nlast && servercandidate~=Local
     for k=Nlast+1:N
         if scheduletemp(1,k-Nlast,Servernum+1)==-1
             continue;
         end
         scheduletemp(1,k,Servernum+1)=scheduletemp(1,k-Nlast,Servernum+1)+Timeslot-Timeslotlast;
         scheduletemp(2,k,Servernum+1)=scheduletemp(2,k-Nlast,Servernum+1)+Timeslot-Timeslotlast;
         %scheduletemp(:,(N-Nlast+1):N,servercandidate)=scheduletemp(:,(N-2*Nlast+1):(N-Nlast),servercandidate)+Timeslot;
     end
     end
     
 else 
  %{ 
 kstart=1;
 kend=Tasknum(1,1);
 for j=1:Usernum-1
     if j==User
         break;
     end
 kstart=kstart+Tasknum(1,j);
 kend=kend+Tasknum(1,j+1);
 end
 for temp=kstart:kend
     scheduletemp(1,N-Nlast+temp,servercandidate)=-1;
         %scheduletemp(1,N-Nlast+k,Servernum+User)=-1;
         scheduletemp(2,N-Nlast+temp,servercandidate)=-1;
         %scheduletemp(2,N-Nlast+k,Servernum+User)=-1;
 end
 %}
 for j=1:Nlast
     if scheduletemp(1,N-Nlast+j,servercandidate)==-1
     continue;
     end
  scheduletemp(1,N-Nlast+j,servercandidate)=scheduletemp(1,N-Nlast+j,servercandidate)+delta;
  scheduletemp(2,N-Nlast+j,servercandidate)=scheduletemp(2,N-Nlast+j,servercandidate)+delta;
 end
[Comstartuptemp]=Comstartupart(Comstartup,Servernum,User);
scheduletemp(:,N-Nlast+1:N,:)=schedule(Taskgraph,n,min(N,Nlast),Rank,Comstartuptemp,Transdata,Transferrate2(:,:,User),Computecost,Servernum+1,scheduletemp(:,N-Nlast+1:N,:),mod(Startsearch,Nlast),Local,servercandidate,1,Timeslot);
usercurrent=scheduletemp(2,Startsearch+End1,Servernum+1)-scheduletemp(1,Startsearch+End2,Servernum+1); %用户1卸载到边缘服务器1上执行
 end
end

