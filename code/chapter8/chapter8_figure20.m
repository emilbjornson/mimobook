%This Matlab script can be used to reproduce Figure 8.20 in the textbook:
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

radiuss = 100;

sigmaAll = [6 3]/180*pi;
MSE = zeros(length(sigmaAll),length(Mall));
trialNumber = 100000;

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
            AOAs = atan(imag(sourcePosition-receiverPositions)./real(sourcePosition-receiverPositions));
            AOAsNoisy = wrapToPi(2*(AOAs + sigma*randn(M,1)))/2; %Wrap to -pi/2 to pi/2

            cost0 = inf;
            for initialrandom = 1:5

                pos0 = radiuss*rand(2,1);
                fx = centers(:,1);
                fy = centers(:,2);
                lb = [-radiuss; -radiuss];
                ub = [radiuss; radiuss];

                fun = @(x)(atan((x(2)-fy)./(x(1)-fx))-AOAsNoisy).'*(atan((x(2)-fy)./(x(1)-fx))-AOAsNoisy);

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
plot(Mall,sqrt(MSE(1,:)),'k','LineWidth',1.5)
plot(Mall,sqrt(MSE(2,:)),'r--','LineWidth',1.5)

ylim([0 15])
xlabel('Number of receivers ($M$) ','Interpreter','latex');
ylabel('RMSE [m]','Interpreter','latex');
legend({'$\sigma_{\varphi}=6^{\circ}$', '$\sigma_{\varphi}=3^{\circ}$'},'Interpreter','latex');
set(gca,'fontsize',16);
xlim([5 25])


