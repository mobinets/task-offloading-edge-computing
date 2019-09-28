function [user,temp]=Prioritymax(Taskgraph,Tasknum,Transdata,Transferrate,Rank,Rankset,Usernum,Servernum,alfa,Size,Computecost,Computenergy,Transmitpower,Local)
%PRIORITYMAX 此处显示有关此函数的摘要
%   此处显示详细说明
user=-1;
temp=-1;
maxpriority=-1;
for i=1:Usernum
    tasktemp=Rankset(1,i);
    if tasktemp==-1
        continue;
    end
priority=alfa(1,i)*Computenergy(1,i)*Rank(1,tasktemp,i);
T=Computecost(tasktemp,Local(1,i),i);
sum=0;
for j=1:Tasknum(1,i)
    if Taskgraph(tasktemp,j,i)>0
        sum=sum+Transdata(tasktemp,j,i)/mean(Transferrate(Servernum+1,1:Servernum,i)); %这个transferrate代表什么含义还要确认一下 哪个是本地？
    elseif Taskgraph(tasktemp,j,i)<0
        sum=sum+Transdata(j,tasktemp,i)/mean(Transferrate(Servernum+1,1:Servernum,i));
    else
        continue;
    end
end
meanrate=0;
for t=1:Servernum
    meanrate=meanrate+Transferrate(Local(1,i),t,i);
end
meanrate=meanrate/Servernum;
priority=priority+(1-alfa(1,i))*Computenergy(1,i)*T-Transmitpower(1,i)*Size(i,tasktemp)/meanrate;
if priority<0
    priority=0;
end
if priority>maxpriority
    maxpriority=priority;
    user=i;
    temp=tasktemp;
end
end
end

