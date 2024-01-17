%This Matlab script can be used to reproduce Figure 8.18 in the textbook:
%Emil Bjornson and Ozlem Tugfe Demir (2024),
%"Introduction to Multiple Antenna Communications and Reconfigurable Surfaces", 
%Boston-Delft: Now Publishers, http://dx.doi.org/10.1561/9781638283157
%
%This is version 1.0 (Last edited: 2024-01-17)
%
%License: This code is licensed under the GPLv2 license. If you in any way
%use this code for research that results in publications, please cite our
%textbook as described above. You can find the complete code package at
%https://github.com/emilbjornson/mimobook

clear
close all
options = optimoptions('fmincon','Display','off','Algorithm','sqp');

% Number of antennas
Mall = 5:1:25;
sigmaAll = [10 5];
MSE = zeros(length(sigmaAll),length(Mall));
trialNumber = 100000; 
radiuss = 100;

for s = 1:length(sigmaAll)
    sigma = sigmaAll(s);
    for m = 1:length(Mall)
        
        M = Mall(m);
        for trial = 1:trialNumber
            

            receiverPositions = zeros(M,1);
            for mm = 1:M
                receiverPositions(mm) = radiuss*(cos(pi/2+(mm-1)*pi/(M-1))+1i*sin(pi/2+(mm-1)*pi/(M-1)));
            end

            sourcePosition = radiuss+0*1i;

            centers = [real(receiverPositions) imag(receiverPositions)];
            distances = abs(receiverPositions-sourcePosition);
            distancesNoisy = distances + sigma*randn(M,1);
            disDifference = distancesNoisy(2:end) - distancesNoisy(1);
            CTDOAinv = inv(ones(M-1,M-1) + eye(M-1));

            cost0 = inf;
            for initialrandom = 1:5

                pos0 = radiuss*rand(2,1);
                fx = centers(2:end,1);
                fy = centers(2:end,2);
                fx0 = centers(1,1);
                fy0 = centers(1,1);
                lb = [-radiuss; -radiuss];
                ub = [radiuss; radiuss];

                fun = @(x)((sqrt((x(2)-fy).^2+(x(1)-fx).^2)-sqrt((x(2)-fy0).^2+(x(1)-fx0).^2)-disDifference).'*CTDOAinv*(sqrt((x(2)-fy).^2+(x(1)-fx).^2)-sqrt((x(2)-fy0).^2+(x(1)-fx0).^2)-disDifference));

                pos0 = fmincon(fun,pos0,[],[],[],[],lb,ub,[],options);
                
                if fun(pos0)<cost0
                    cost = abs(sourcePosition-pos0(1)-pos0(2)*1i)^2;
                    cost0 = fun(pos0);
                end
            end
            

            MSE(s,m) = MSE(s,m) + cost/trialNumber;
        end
    end
end
%% Plot the simulation results
set(groot,'defaultAxesTickLabelInterpreter','latex');

x0 = real(sourcePosition);
y0 = imag(sourcePosition);

figure;
hold on; box on; grid on;
plot(Mall,sqrt(MSE(1,:)),'k-','LineWidth',2)
plot(Mall,sqrt(MSE(2,:)),'r--','LineWidth',2)

ylim([0 40])
xlabel('Number of receivers ($M$) ','Interpreter','latex');
ylabel('RMSE [m]','Interpreter','latex');
legend({'$\sigma_{\textrm{d}}=10$', '$\sigma_{\textrm{d}}=5$'},'Interpreter','latex');
set(gca,'fontsize',16);
xlim([5 25])


