%This Matlab script can be used to reproduce Figure 7.15 in the textbook:
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
M = 20;

%Select the beamforming directions
varphi = [0 pi/6 pi/3];

%Set the ratio between bandwidth and carrier frequency
Bfc = 0.1;

%% Compute the beamforming gain at different subcarriers
nuS = linspace(-1/2,1/2,1000);
beamforminggain = zeros(length(nuS),length(varphi));


for m = 1:length(varphi)

    for i = 1:length(nuS)

        factor = nuS(i)*Bfc*pi*sin(varphi(m))/2;

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
plot(nuS,pow2db(beamforminggain(:,1)),'k-','LineWidth',2)
plot(nuS,pow2db(beamforminggain(:,2)),'r--','LineWidth',2)
plot(nuS,pow2db(beamforminggain(:,3)),'b-.','LineWidth',2)
ax = gca;
set(ax, 'XTick', [-1/2 -1/3 -1/6 0 1/6 1/3 1/2]);
xticklabels({'$-\frac{S}{2}$','$-\frac{S}{3}$','$-\frac{S}{6}$','$0$','$\frac{S}{6}$','$\frac{S}{3}$','$\frac{S}{2}$'});
ylim([0 15]);
xlabel('Subcarrier index $\nu$','Interpreter','latex');
ylabel('Beamforming gain [dB]','Interpreter','latex');
legend({'$\varphi = 0$', '$\varphi = \pi/6$', '$\varphi = \pi/3$'},'Interpreter','Latex','Location','SouthWest');
set(gca,'fontsize',16);
