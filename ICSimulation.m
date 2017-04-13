function [welfare, correctness, herdPos, preherd] = ICSimulation(V,k,n,p,epsilon,delta);

%% Objective: Calculation of sample welfare and correctness of the last agent's action assuming V=1.

%% Input: k=number of trials, n=number of agents
%% p[n]=strength of their private signal.
%% epsilon[n]= BSC error rate.

%% Output: welfare[n], correctness
%% herdPos: the agent where herding starts.
%% preherd: The sequence of (Action, Signal, and Observation) before herding start.




welfare = zeros(n,1);
herdPos = zeros(k,1);
for i = 1:k % run for k trials, each trial is done by using TrialRun
    [X, A, O, R, herdAt] = TrialRun(V,n,p,epsilon,delta);
    welfare = welfare + (A==1)/k;%average welfare for all k trials, BUT if A=0 then no change. Only change if A=1 meaning V=1 is the underying state
    %THE FOLLOWING IS MORE OR PROBABILITY OF CORRECT HERDING RATHER THAN
    %WELFARE. HERE THE UNDERLYING V=1
    %FOR WELFARE LIKE IN THE PAPER, YOU WOULD NEED TO AVERGAGE OUT BETWEEN 0 AND 1 (THUS, INTRODUCING A FACTOR OF HALF)
    %AND THEN INCOOPORATE THE PAYOFF OF 1/2 AND -1/2 INSTEAD OF 1 AND -1,
    %(THUS, INTRODUCING ANOTHER FACTOR OF HALF). AS A RESULT, THE AVERAGE
    %PAYOFF SHOULD BE REDUCED BY A FACTOR OF (1/2)*(1/2)=1/4 INSTEAD OF 1
    %For V=0, this is what I think should be the probability of correct
    %herding: welfare = welfare + (A==-1)/k;
    herdPos(i) = herdAt;%herding position for trial ith
    if herdAt > n %herding does not happen yet for those n agents, so take everything
        %preherd{i} = num2str([A(1:end)';X(1:end)';O(1:end)';R(1:end)']); % String that shows the preherd sequence.
        preherd{i} = num2str([X(1:end)';A(1:end)';R(1:end)']); % String that shows the preherd sequence.
    else %herding already happen at herdAt, so need to cut that that position.
        preherd{i} = num2str([X(1:herdAt)';A(1:herdAt)';R(1:herdAt)']);
        %preherd{i} = num2str([A(1:herdAt)';X(1:herdAt)';O(1:herdAt)';R(1:herdAt)']);    
    end
end
correctness = welfare(n); % correctness is welfare of the last agent.