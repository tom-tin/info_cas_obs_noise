tic %starts a stopwatch timer. The function records the internal time at execution of the tic command. Display the elapsed time with the toc function
clear
close all%deletes all figures whose handles are not hidden
format compact %Set Command Window output display format: suppress excess blank lines to show more output on a single screen.
trial = 10000;
n = 1000;
%p = 0.5+1./((1:n)/10+2);
p=0.70*ones(n,1);
epsilon=zeros(n,1);
%epsilonlist = 0.01:0.001:0.25;
deltalist = 0.69:0.001:0.71;
%deltalist = 0.90:0.01:0.99;
%deltalist = 0.69:0.0001:0.70;
V=0;
parfor k = 1:numel(deltalist) %numel(A): returns the number of elements, n, in array A, equivalent to prod(size(A)).
    delta = ones(n,1) * deltalist(k);% a column n elements, all are epsilonlist(k)
    [welfare, correctness, herdPos, preherd] = ICSimulation(V,trial,n,p,epsilon,delta);
    c(k) = correctness;
    w(:,k) = welfare;
    herding(:,k) = herdPos;
    preherdseq{k} = preherd;
end

p1=plot(deltalist,1-c(end,:));
xlabel('delta')
ylabel('probability')
title('probability of correct herding');
figure
p2=plot(deltalist,w(1,:));
xlabel('delta')
ylabel('welfare')
title('Expected welfare for Agent i = 1');
figure,
p3=plot(deltalist,w(10,:));
xlabel('delta')
ylabel('welfare')
title('Expected welfare for Agent i = 10');
figure,
p4=plot(deltalist,w(100,:));
xlabel('delta')
ylabel('welfare')
title('Expected welfare for Agent i = 100');
figure,
p5=plot(deltalist,min(herding));
xlabel('delta')
ylabel('Agent number')
title('Minimum herding agent')
figure,
p6=plot(deltalist,mean(herding));
xlabel('delta')
ylabel('Agent number')
title('Average herding agent')

time = clock; % Gets the current time as a 6 element vector
timestamp = [num2str(time(1)), num2str(time(2)),num2str(time(3)),num2str(time(4)),num2str(time(5)),num2str(floor(time(6)))];
saveas(p1,fullfile('F:\Dropbox\GRAD at NU\Papers\Reports\Simulation\fig',strcat('wrongherd-',timestamp,'.png')),'png');
saveas(p2,fullfile('F:\Dropbox\GRAD at NU\Papers\Reports\Simulation\fig',strcat('agent1-',timestamp,'.png')),'png');
saveas(p3,fullfile('F:\Dropbox\GRAD at NU\Papers\Reports\Simulation\fig',strcat('agent10-',timestamp,'.png')),'png');
saveas(p4,fullfile('F:\Dropbox\GRAD at NU\Papers\Reports\Simulation\fig',strcat('agent100-',timestamp,'.png')),'png');
saveas(p5,fullfile('F:\Dropbox\GRAD at NU\Papers\Reports\Simulation\fig',strcat('minherd-',timestamp,'.png')),'png');
saveas(p6,fullfile('F:\Dropbox\GRAD at NU\Papers\Reports\Simulation\fig',strcat('aveherd-',timestamp,'.png')),'png');
toc
%save('F:\Dropbox\GRAD at NU\Papers\Reports\Simulation\fig\p080.mat')
%save('G:\p070_V1_069_070.mat')
save('F:\p070_V0_2.mat')
%save('/media/tin/My\ Passport/p070_V1_050_055.mat')



% C = {};
% n = 1;
% for i = 1:20000
%     found = 0;
%     for j = 1:numel(C);
%         if(strcmp(preherdseq{9}{i},C{j}))
%             found = 1;
%         end
%     end
%     if(found==0)
%         n = numel(C);
%         C{n+1} = preherdseq{9}{i};
%     end
% end
% 
% 
% for i = 1:numel(C)
%     l(i) = length(C{i});
% end
% [sortedC order] = sort(l);
% C{order}
% figure
% p7=plot(0.50:0.0001:0.5050,1-c(end,1:51));
% xlabel('delta')
% ylabel('probability')
% title('probability of wrong herding');
% saveas(p7,fullfile('F:\Dropbox\GRAD at NU\Papers\Reports\Simulation\fig',strcat('wrongherd-',timestamp,'.png')),'png');
