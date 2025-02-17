function [BestSol,iteriter]=AMO(popsize,MaxIt,model)
benchmark_func=@(xhat) MyCost_EOCAEFA(xhat,model);
format short;
format compact;
dim=model.n-2;%ά��=�ڵ���-2
D=dim;
up=model.n;
problem_index=[1:1:1];
for problem_selection= 1:1

    problem=problem_index(problem_selection);

   
    switch problem

        case 1
            lu=[ones(1,D);up*ones(1,D)];
   
     end

    outcome=[];  % record the best results

%Main body

    time=1;
    total_time=1;
    while time<=total_time
        
      clear p
      
        % Initialize the main population
         p=repmat(lu(1,:),popsize,1)+rand(popsize,D).*(repmat(lu(2,:)-lu(1,:),popsize,1));

        % Evaluate the individuals
        for i=1:popsize
         [p(i,:),fit(i,:),Sol(i,:)]= benchmark_func(p(i,:));
        end
         ind=find(fit==min(fit(:)));
         ind=ind(end);
        
         GlobalMin=fit(ind);
         GlobalParams=p(ind,:);
       

        FES=popsize;
        iter=0;
        low=lu(1,:);
        up=lu(2,:);
        
        while   iter<MaxIt %(min(fit)-best_known(problem))>10^(-8) &
            iter=iter+1;
            p=update(p,low,up);
           for i=1:1:popsize
              
             f=i*ones(1,D);
             FF=normrnd(0,1);   
             for d=1:D

                   
                      % Neighborhood based learning scheme--Selection of exemplar particle
                     if i==1
                         lseq=[popsize-1 popsize i i+1 i+2];
                         j=randperm(5);
                         f(d)=lseq(j(2));
                     elseif i==2
                         lseq=[popsize i-1 i i+1 i+2];
                         j=randperm(5);
                         f(d)=lseq(j(2));
                     elseif i==popsize-1
                         lseq=[i-2 i-1 i popsize 1];
                         j=randperm(5);
                         f(d)=lseq(j(2));
                        
                     elseif i==popsize
                         lseq=[i-2 i-1 i 1 2];
                         j=randperm(5);
                         f(d)=lseq(j(2));
                        
                     else
                     
                     lseq=[i-2 i-1 i i+1 i+2];
                     j=randperm(5);
                     f(d)=lseq(j(2));
      
                     end
                     
                     
            end
            
            for d=1:1:D
              newV(i,d)=p(i,d)+FF.*(p(f(d),d)-p(i,d));
            end  
      end
      
        
       newV=update(newV, low,up);
       for i=1:popsize
         [newV(i,:),fit_V(i,:),Sol(i,:)]= benchmark_func(newV(i,:));
        end

        for i=1:popsize

                if fit_V(i,:)<=fit(i,:)

                    p(i,:)= newV(i,:);
                    fit(i,:)=fit_V(i,:);
                    BestSol=Sol(i,:);
                end

        end
     [sortVal, sortIndex] = sort(fit);
     for i=1:1:popsize     
         pro(sortIndex(i))=(popsize-i+1)./popsize;
     end
         ind=find(fit==min(fit));
         ind=ind(end);
         if (fit(ind)<GlobalMin)
         GlobalMin=fit(ind);
         GlobalParams=p(ind,:);
         end
         
        [r1,r2,r3,r4,r5] =getindex(popsize);
 
             for i=1:1:popsize
              
                
                 for j=1:1:D
                      if rand>pro(i) 
                         newVV(i,j)= p(r1(i),j)+rand*(GlobalParams(j)-p(i,j))+ rand*(p(r3(i),j)-p(i,j));
                     else
                         newVV(i,j)= p(i,j);
                     end
             
                 end
             end
                     
          newVV=update(newVV,low,up);
          for i=1:popsize
         [newVV(i,:),fit_VV(i,:),Sol(i,:)]= benchmark_func(newVV(i,:));
        end
       
          for i=1:popsize

                if fit_VV(i,:)<=fit(i,:)

                    p(i,:)=newVV(i,:);
                    fit(i,:)=fit_VV(i,:);
                    BestSol=Sol(i,:);
                end

          end
 
            FES=FES+popsize*2;
            
         ind=find(fit==min(fit(:)));
         ind=ind(end);
         if (fit(ind)<GlobalMin)
             GlobalMin=fit(ind);
             GlobalParams=p(ind,:);
         end      
    %  if mod(FES-50,1000)==0   %%  dynamic population. 
        
   %       seq=randperm(popsize);
   %       xnew=[];
   %       fitnew=[];
   %      for i=1:popsize
   %           xnew=[xnew;p(seq(i),:)];
   %           fitnew=[fitnew;fit(seq(i),:)];
    %      end
   %       p=xnew;
   %      fit=fitnew;
   %  end  
%        GlobalMin ;
       iteriter(iter)=GlobalMin;

        end
        outcome=[outcome min(fit)];
  
        time=time+1;
    end
% 
%     sort(outcome)
%     mean(outcome)
%     std(outcome)
end
%  toc;