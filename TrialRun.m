%Simulation algo for ONE TRIAL of the cascade model assuming V=1
function [X, A, O, R, herdAt] = TrialRun(V,n,p,epsilon,delta)%p is col nx1 vectors
%% Input: n=number of agents, p[n]=strength of their private signal
%% epsilon[n]=BSC error rate.

%% Output: X[n], A[n], O[n].

a = zeros(n,1);%column vec
b = zeros(n,1);%column vec
A = zeros(n,1);%initalize
O = zeros(n,1);%initalize
R = zeros(n,1);
X = zeros(n,1);%initalize signals
PAHV1 = zeros(n,1);
PAHV0 = zeros(n,1);
POHV1 = zeros(n,1);
POHV0 = zeros(n,1);
POLV1 = zeros(n,1);
POLV0 = zeros(n,1);
px1 = zeros(n,1);
px0 = zeros(n,1);
po1 = zeros(n,1);
po0 = zeros(n,1);
pr1 = zeros(n,1);
pr0 = zeros(n,1);
buy = zeros(n,1);
herdAt = n+1;%default


for j = 1:n;
    if (V==1)
        X(j) = (2*(rand<p(j))-1);%=1 wp p(j), =-1 wp 1-p(j).
    elseif (V==0)
        X(j) = (2*(rand>p(j))-1);%=-1 wp p(j), =1 wp 1-p(j).
    end
end
for j = 1:n;
    if j == 1
        A(j) = X(j);%A1 is just X1
        if (A(j)==1)
            if (V==1)
                R(j) = (2*(rand<delta(j))-1);%=1 wp delta(1), =-1 wp 1-delta(1)
            elseif (V==0)
                R(j) = (2*(rand>delta(j))-1);%=-1 wp delta(1), =1 wp 1-delta(1)
            end
            pr1(j) = log( delta(j) * (R(j)==1) + (1-delta(j)) * (R(j)==-1) );
            pr0(j) = log( (1-delta(j)) * (R(j)==1) + delta(j) * (R(j)==-1) );
        elseif (A(j)==-1)
            pr1(j) = 0;
            pr0(j) = 0;
        end%so, we will take into account if R(1)=+-1, o/w if R(1)=0 we ignore.
        O(j) = (2*(rand>epsilon(j))-1)*A(j);%O(1)=A(1) wp 1-e(1), =-A(1) wp e(1)
        PAHV1(j) = p(j);% P[A1=something and S1=H|V=1], = sig qual p(1)
        PAHV0(j) = 1-p(j);%see the second equation of agent 1
        buy(j) = (A(j)==1);%why need?maybe because we need buy(j)=0 when A(j)=-1
        POHV1(j) = (1-epsilon(j)) * PAHV1(j) + epsilon(j)*(1-PAHV1(j));%=a1,  P[action A_1 recorded on database is O_1=1 and S1=H |V=1]
        POLV1(j) = 1-POHV1(j);                                         %=1-a1,P[action A_1 recorded on database is O_1=0 and S1=L |V=1]
        POHV0(j) = (1-epsilon(j)) * PAHV0(j) + epsilon(j)*(1-PAHV0(j));%=1-a1,P[action A_1 recorded on database is O_1=1 and S1=H |V=0]
        POLV0(j) = 1-POHV0(j);                                         %=a1,  P[action A_1 recorded on database is O_1=0 and S1=L |V=0]
        po1(j) = log((POHV1(j) * (O(j)==1) + POLV1(j) * (O(j)==-1)));%contribution of agent 1 to database, P[O_1=|V=1], =log(a1) if O1=1, =log(1-a1) if O1=-1
        po0(j) = log((POHV0(j) * (O(j)==1) + POLV0(j) * (O(j)==-1)));%contribution of agent 1 to database, P[O_1=|V=0], =log(1-a1) if O1=1, =log(a1) if O1=-1
        %For now just forget about the log. Then po1(j) = P[O_1=whatever|V=1]
        %Similarly, po0(j) = P[O_1=whatever|V=0]
    else
        px1(j) = p(j) * (X(j)==1) + (1-p(j)) * (X(j)==-1);%=P[X(j)|V=1], = p(j) if X(j)=1, = 1-p(j) if X(j)=-1
        px0(j) = 1-px1(j);                                %=P[X(j)|V=0], = 1-p(j) if X(j)=1, = p(j) if X(j)=-1
        
                
        if ( log(px1(j)) + po1(j-1) + pr1(j-1) == log(px0(j)) + po0(j-1) + pr0(j-1) )
            A(j) = X(j);
        else
            A(j) = 2*(  ( log(px1(j)) + po1(j-1) + pr1(j-1) ) > ( log(px0(j)) + po0(j-1) + pr0(j-1) ) )-1;%=(p_seq|V=1>p_seq|V=0) = (gamma_seq>1/2), so A(j)= +1 or -1
        end
        
        
        if (A(j)==1)
            if (V==1)
                R(j) = (2*(rand<delta(j))-1);%=1 wp delta(1), =-1 wp 1-delta(1)
            elseif (V==0)
                R(j) = (2*(rand>delta(j))-1);%=-1 wp delta(1), =1 wp 1-delta(1)
            end
            pr1(j) = pr1(j-1) + log( delta(j) * (R(j)==1) + (1-delta(j)) * (R(j)==-1) );
            pr0(j) = pr0(j-1) + log( (1-delta(j)) * (R(j)==1) + delta(j) * (R(j)==-1) );
        elseif (A(j)==-1)
            pr1(j) = pr1(j-1);
            pr0(j) = pr0(j-1);
        end%so, we will take into account if R(j)=+-1, o/w if R(j)=0 we ignore.
        
        %so A(j) is determine either +-1 based on both contribution of X(j)
        %and the observations upto agent j-1 (which already includes contributions of all all observations of previous j-2 agents
        buy(j) = (A(j)==1);%just like b4
        O(j) = (2*(rand>epsilon(j))-1)*A(j);%just like b4, i.e., %O(j)=A(j) wp 1-e(j), =-A(j) wp e(j)
        
        %now, go on to update the contributions to po1,po0 that are going to be used for the next agent's decision
%         if ((R(j)==1) || (R(j)==-1))%i.e. if A(j)=Y, so there exists an review R(j) which is +-1 
%             a(j) = log(p(j)) + log(delta(j-1)) + po1(j-1) > log((1-p(j))) + log(1-delta(j-1)) + po0(j-1);%BY PUTTING j-1 here, NO NEED TO UPDATE po or anything for agent 1
%             b(j) = log((1-p(j))) + log(1-delta(j-1)) + po1(j-1) > log(p(j)) + log(delta(j-1)) + po0(j-1);
%         else%i.e. R(j)=0 implies there is no review. So update normally as before.
%             a(j) = log(p(j)) + po1(j-1) > log((1-p(j))) + po0(j-1);
%             b(j) = log((1-p(j))) + po1(j-1) > log(p(j)) + po0(j-1);
%         end
       
        if ( log(p(j)) + pr1(j-1) + po1(j-1) == log((1-p(j))) + pr0(j-1) + po0(j-1) )
            a(j) = 1;
        else
            a(j) = log(p(j)) + pr1(j-1) + po1(j-1) > log((1-p(j))) + pr0(j-1) + po0(j-1);%BY PUTTING j-1 here, NO NEED TO UPDATE po or anything for agent 1
        end
        if ( log((1-p(j))) + pr1(j-1) + po1(j-1) == log(p(j)) + pr0(j-1) + po0(j-1) )
            b(j) = 0;
        else
            b(j) = log((1-p(j))) + pr1(j-1) + po1(j-1) > log(p(j)) + pr0(j-1) + po0(j-1);
        end          
       
        if((a(j) == b(j)) && (A(j)==-1))%i.e. herd to N, so just copy: (the herding action, the a and b, the po1 and po0) to all subsequent agents
            %the rest observations are not updated, so all are 0's.
            %also herding position is saved in herdAt
            po1(j) = po1(j-1);
            po0(j) = po0(j-1);
%           Uncomment if future agents will also herd like the simulation I
%           did for the paper.
            A(j:end) = A(j);
            a(j:end) = a(j);
            b(j:end) = b(j);
            buy(j:end) = buy(j);
            herdAt = j;%may be should change this to j-1, since at j the agent j already herds, while preherd means only for agents who do not herd.
            break;
        elseif ((a(j) == b(j)) && (A(j)==1))%i.e. agent i herds (Note the distinction between  to Y
            %Stop taking into account this guy's signal into the next
            %agent.
            po1(j) = po1(j-1);
            po0(j) = po0(j-1);
        else%herd to Y or not yet herd
            %Note that here no need to update anything, since the review
            %(if it exists) has already been taken into account in the
            %terms a(j) and b(j) in above.
            PAHV1(j) = a(j) * p(j) + b(j) * (1-p(j));
            PAHV0(j) = a(j) * (1-p(j)) + b(j) * p(j);
            POHV1(j) = (1-epsilon(j)) * PAHV1(j) + epsilon(j)*(1-PAHV1(j));
            POLV1(j) = 1-POHV1(j);
            POHV0(j) = (1-epsilon(j)) * PAHV0(j) + epsilon(j)*(1-PAHV0(j));
            POLV0(j) = 1-POHV0(j);
            
            po1(j) = po1(j-1) + log((POHV1(j) * (O(j)==1) + POLV1(j) * (O(j)==-1)));
            po0(j) = po0(j-1) + log((POHV0(j) * (O(j)==1) + POLV0(j) * (O(j)==-1)));
            
        end
    end
end