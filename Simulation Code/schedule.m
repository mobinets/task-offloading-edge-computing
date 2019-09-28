function [schedule] = schedule(Taskgraph,n,N,Rank,Comstartup,Transdata,Transferrate,Computecost,Q,schedule,Startsearch,Local,In,len,Timeslot)
%SCHEDULE 此处显示有关此函数的摘要
%   此处显示详细说明
%n表示任务图中的任务数目  N表示schedule数组中的列数
FirstFinish=0;
Scheduletemp=zeros(2,N,Q);
for k=1:Q 
    if k~=Local && Isin(k,In,len)==0
        continue;
    end
    Scheduletemp(:,:,k)=(sortrows(schedule(:,:,k)',1))';%假设能够按照第一行的列顺序排序
end
processor=0;
     for p=1:n
         [MAX,temp]=Max(Rank,n);%temp是当前具有最高优先级的任务编号
        Rank(1,temp)=-1;
        for j=Q:-1:1  %卸载到边缘服务器1上执行
             %if i==1&&j~=Local
            %continue; 不能绑定在某一个核上
           %  end
           if j~=Local && Isin(j,In,len)==0
               continue;
           end
            if (temp==1||temp==n)&&j~=Local
                continue;
            end
        Finishtime=EFTcompute(Taskgraph,schedule,Scheduletemp(:,:,j),temp,j,Comstartup,Transdata,Transferrate,Computecost,N,Q,n,Startsearch,Timeslot);
        if j==Local || FirstFinish>Finishtime 
            FirstFinish=Finishtime;
            processor=j;
            tempcore=j;
        end
        end
      schedule(2,temp+Startsearch,processor)=FirstFinish;
      schedule(1,temp+Startsearch,processor)=FirstFinish-Computecost(temp,tempcore);
                   if Scheduletemp(1,N,processor)==-1
                   Scheduletemp(1,N,processor)=FirstFinish-Computecost(temp,tempcore);
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
     end
    end


