%This Matlab script can be used to reproduce Figure 7.16 in the textbook:
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

%Set the ratio between bandwidth and carrier frequency
Bfc = 0.1;

%Select the relative subcarrier index from -1 to 1
subcarrierIndex = [0 1/4 1/2];

%Define the frequency-dependent array response as a function of the azimuth
%angle and the ratio f/f_c of the frequency and carrier frequency
arrayresponse_ULA = @(varphi,ffc) exp(-1i*pi*ffc*sin(varphi)*(0:M-1))';

%Select the observation directions
varphi = linspace(-pi/2,pi/2,2000);
beamforminggain = zeros(length(varphi),length(subcarrierIndex));

%This is the angle that the signal comes from
beamAngle = pi/3;

for i = 1:length(varphi)

    for n = 1:length(subcarrierIndex)

        beamforminggain(i,n) = abs(arrayresponse_ULA(varphi(i),1)'*arrayresponse_ULA(beamAngle,1+subcarrierIndex(n)*Bfc)).^2/M;

    end

end



%% Plot the simulation results
set(groot,'defaultAxesTickLabelInterpreter','latex');

figure;
hold on; box on; grid on;
plot(varphi/pi,pow2db(beamforminggain(:,1)),'k-','LineWidth',2)
plot(varphi/pi,pow2db(beamforminggain(:,2)),'r--','LineWidth',2)
plot(varphi/pi,pow2db(beamforminggain(:,3)),'b-.','LineWidth',2)
ax = gca;
set(ax, 'XTick', [-0.5, -1/3, -1/6, 0, 1/6, 1/3, 0.5]);
xticklabels({'$-\frac{\pi}{2}$','$-\frac{\pi}{3}$','$-\frac{\pi}{6}$','$0$','$\frac{\pi}{6}$','$\frac{\pi}{3}$','$\frac{\pi}{2}$'});
ylim([-10 15]);
xlabel('Observation angle $\varphi$','Interpreter','latex');
ylabel('Beamforming gain [dB]','Interpreter','latex');
legend({'$\nu = 0$', '$\nu = S/4$', '$\nu = S/2$'},'Interpreter','Latex','Location','NorthWest');
set(gca,'fontsize',16);
