%This Matlab script can be used to reproduce Figure 4.19 in the textbook:
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

close all;
clear;

%Number of antennas in the ULA
M = 10;

%Set the angles of the beams
beamAngles = asin((-M/2:1:M/2)*2/M);


%% Compute the beamforming gain in different directions
varphi = linspace(-pi/2,pi/2,1000);
beamforminggain = zeros(length(varphi),length(beamAngles));


for i = 1:length(varphi)
    
    for m = 1:length(beamAngles)
        
        factor = pi*(sin(varphi(i))-sin(beamAngles(m)))/2;
        
        if factor == 0
            beamforminggain(i,m) = M;
        else
            beamforminggain(i,m) = abs(sin(M*factor)/sin(factor))^2/M;
        end
        
    end
    
end


%% Plot the simulation results
set(groot,'defaultAxesTickLabelInterpreter','latex');  

figure;
hold on; box on; grid on;
plot(sin(varphi),pow2db(beamforminggain(:,1)),':k','LineWidth',2)
plot(sin(varphi),pow2db(beamforminggain(:,2)),'-b','LineWidth',2)
plot(sin(varphi),pow2db(beamforminggain(:,3)),'-k','LineWidth',2)
plot(sin(varphi),pow2db(beamforminggain(:,4)),'-r','LineWidth',2)
plot(sin(varphi),pow2db(beamforminggain(:,5)),'-.b','LineWidth',2)
plot(sin(varphi),pow2db(beamforminggain(:,6)),'-.k','LineWidth',2)
plot(sin(varphi),pow2db(beamforminggain(:,7)),'-.r','LineWidth',2)
plot(sin(varphi),pow2db(beamforminggain(:,8)),'--b','LineWidth',2)
plot(sin(varphi),pow2db(beamforminggain(:,9)),'--k','LineWidth',2)
plot(sin(varphi),pow2db(beamforminggain(:,10)),'--r','LineWidth',2)
ax = gca;
set(ax, 'XTick', -1:0.2:1);
set(ax, 'YTick', [-10 -5 0 6 10]);
xticklabels({'$-\frac{1}{\lambda}$','$-\frac{0.8}{\lambda}$','$-\frac{0.6}{\lambda}$','$-\frac{0.4}{\lambda}$','$-\frac{0.2}{\lambda}$','$0$','$\frac{0.2}{\lambda}$','$\frac{0.4}{\lambda}$','$\frac{0.6}{\lambda}$','$\frac{0.8}{\lambda}$','$\frac{1}{\lambda}$'});
ylim([-10 10]);
xlabel('Spatial frequency $\sin(\varphi)/\lambda$','Interpreter','latex');
ylabel('Beamforming gain [dB]','Interpreter','latex');
set(gca,'fontsize',16);



figure;
ax = polaraxes;
hold on; box on; grid on;
polarplot(varphi+pi/2,pow2db(beamforminggain(:,1)),':k','LineWidth',2)
polarplot(varphi+pi/2,pow2db(beamforminggain(:,2)),'-b','LineWidth',2)
polarplot(varphi+pi/2,pow2db(beamforminggain(:,3)),'-k','LineWidth',2)
polarplot(varphi+pi/2,pow2db(beamforminggain(:,4)),'-r','LineWidth',2)
polarplot(varphi+pi/2,pow2db(beamforminggain(:,5)),'-.b','LineWidth',2)
polarplot(varphi+pi/2,pow2db(beamforminggain(:,6)),'-.k','LineWidth',2)
polarplot(varphi+pi/2,pow2db(beamforminggain(:,7)),'-.r','LineWidth',2)
polarplot(varphi+pi/2,pow2db(beamforminggain(:,8)),'--b','LineWidth',2)
polarplot(varphi+pi/2,pow2db(beamforminggain(:,9)),'--k','LineWidth',2)
polarplot(varphi+pi/2,pow2db(beamforminggain(:,10)),'--r','LineWidth',2)
set(ax, 'RTick', [-10 -5 0 6 10]);
set(ax, 'ThetaTick', [0, 30, 60, 90, 120, 150, 180]);
set(ax, 'TickLabelInterpreter', 'latex');
set(ax, 'ThetaTickLabel',{'$-\frac{\pi}{2}$','$-\frac{\pi}{3}$','$-\frac{\pi}{6}$','$0$','$\frac{\pi}{6}$','$\frac{\pi}{3}$','$\frac{\pi}{2}$'});
set(ax,'RLim',[-10 10]);
set(gca,'fontsize',16);
ax.ThetaLim = [0 180];
