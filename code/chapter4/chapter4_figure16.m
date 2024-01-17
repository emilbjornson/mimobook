%This Matlab script can be used to reproduce Figure 4.16 in the textbook:
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
M = [10 20];

%% Compute the beamforming gain in different directions
varphi = linspace(-pi/2,pi/2,1000);
beamforminggain = zeros(length(varphi),length(M));


for i = 1:length(varphi)
    
    factor = pi*sin(varphi(i))/2;
    
    for m = 1:length(M)
        
        if factor == 0
            beamforminggain(i,m) = M(m);
        else
            beamforminggain(i,m) = abs(sin(M(m)*factor)/sin(factor))^2/M(m);
        end
        
    end
    
end


%% Plot the simulation results
set(groot,'defaultAxesTickLabelInterpreter','latex');  

figure;
hold on; box on; grid on;
plot(varphi/pi,pow2db(beamforminggain(:,1)),'-b','LineWidth',2)
plot(varphi/pi,pow2db(beamforminggain(:,2)),'r--','LineWidth',2)
plot(varphi/pi,zeros(size(beamforminggain(:,1))),'k--','LineWidth',2)
ax = gca;
set(ax, 'XTick', [-0.5, -1/3, -1/6 0, 1/6, 1/3, 0.5]);
xticklabels({'$-\frac{\pi}{2}$','$-\frac{\pi}{3}$','$-\frac{\pi}{6}$','$0$','$\frac{\pi}{6}$','$\frac{\pi}{3}$','$\frac{\pi}{2}$'});
ylim([-20 20]);
xlabel('Observation angle $\varphi$','Interpreter','latex');
ylabel('Beamforming gain [dB]','Interpreter','latex');
legend({'$M=10$', '$M=20$'},'Interpreter','latex');
set(gca,'fontsize',16);
