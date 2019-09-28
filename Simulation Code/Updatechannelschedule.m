function [Schedule,Usercurrent,UserFinish] = Updatechannelschedule(User,server,Channel,Schedule,Schedulelocal,Userlocal,Taskgraph,Rank,Comstartup,Transdata,Transferrate,Computecost,Tasknum,N,Usernum,Local,Q,Timeslot,Transferrateini,Servernum)
%UPDATECHANNELSCHEDULE 此处显示有关此函数的摘要
%   此处显示详细说明
lastcore=-1;
for k=1:Servernum
    if Channel(User,k)==1 && k~=server 
      lastcore=k;
      Channel(User,k)=0;
      break;
    end
end
if lastcore~=-1
   [Transferrate]=Recomputecom(lastcore,Channel,Transferrate,Transferrateini,Usernum,Q-1); 
end
if server~=Local(1,User)
    temp=Channel(User,server);
    Channel(User,server)=1;
[Transferrate]=Recomputecom(server,Channel,Transferrate,Transferrateini,Usernum,Q-1);
    Channel(User,server)=temp;
end
[Comstartuptemp]=Comstartupart(Comstartup,Servernum,User);
flag=zeros(1,Usernum);
Usercurrent=zeros(1,Usernum)-1;
UserFinish=zeros(1,Usernum)-1;

tempmatrix=zeros(2,N,Servernum+1);
     for core=1:Q-1
         offset1=1;
         offset2=1;
     for j=1:Usernum
         offset2=offset1;
         offset1=offset1+Tasknum(1,j);
           if j==User 
               continue;
           end
           if Channel(j,core)==1
                [Transferrate]=Recomputecom(core,Channel,Transferrate,Transferrateini,Usernum,Q-1); 
               tempmatrix(:,:,1:Servernum)=Schedule(:,:,1:Servernum);
               tempmatrix(:,:,Servernum+1)=Schedule(:,:,Servernum+j);
               tempmatrix=schedule(Taskgraph(:,:,j),Tasknum(1,j),N,Rank(:,:,j),Comstartuptemp,Transdata(:,:,j),Transferrate(:,:,j),Computecost(:,:,j),Q,tempmatrix,offset2-1,Local(1,j),core,1,Timeslot);
               Schedule(:,:,1:Servernum)=tempmatrix(:,:,1:Servernum);
               Schedule(:,:,Servernum+j)=tempmatrix(:,:,Servernum+1);
               Usercurrent(1,j)=Schedule(2,offset1-1,Q+j-1)-Schedule(1,offset2,Q+j-1);
               UserFinish(1,j)=Schedule(2,offset1-1,Q+j-1);
               flag(1,j)=1;
           end
     end
     end
    
     offset1=1;
      offset2=1;
      for k=1:Usernum
                   if k-1<User
                       offset2=offset1;
                       offset1=offset1+Tasknum(1,k);
                   else
                       break;
                   end
      end
      offset1=offset1-1;
      tempmatrix(:,:,1:Servernum)=Schedule(:,:,1:Servernum);
      tempmatrix(:,:,Servernum+1)=Schedule(:,:,Servernum+User);
      tempmatrix=schedule(Taskgraph(:,:,User),Tasknum(1,User),N,Rank(:,:,User),Comstartuptemp,Transdata(:,:,User),Transferrate(:,:,User),Computecost(:,:,User),Q,tempmatrix,offset2-1,Local(1,User),server,1,Timeslot);  
      Schedule(:,:,1:Servernum)=tempmatrix(:,:,1:Servernum);
      Schedule(:,:,Servernum+User)=tempmatrix(:,:,Servernum+1);
      Usercurrent(1,User)=Schedule(2,offset1,Q+User-1)-Schedule(1,offset2,Q+User-1);
      UserFinish(1,User)=Schedule(2,offset1,Q+User-1);
      flag(1,User)=1;
      
      
       offset1=1;
       offset2=1;
      for k=1:Usernum
          offset1=offset2;
          offset2=offset2+Tasknum(1,k);
          if flag(1,k)==0 && User~=k     
         Schedule(:,offset1:offset2-1,Servernum+k)=Schedulelocal(:,offset1:offset2-1,k);
        %Schedule=Updateschedule(Schedule,Schedulelocal(:,:,k),offset1,offset2,Startsearch);
        % Schedule(:,1:N*i,:)=schedule(Taskgraph1,N1,N*i,Rank1,Comstartup1,Transdata1,Transferrate1,Computecost1,Q,Schedule(:,1:N*i,:),Q,Usernum,N*(i-1),Local,Local,1,Timeslot);
        Usercurrent(1,k)=Userlocal(1,1,k);
        UserFinish(1,k)=Schedulelocal(2,offset2-1,k);
          end
      end      
end