%This Matlab script can be used to reproduce Figure 4.17 in the textbook:
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

%Set the angles of the beams
beamAngles = [0 pi/4 pi/3];

%Number of antennas in the ULA
M = 10;

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
plot(varphi/pi,pow2db(beamforminggain(:,1)),'-b','LineWidth',2)
plot(varphi/pi,pow2db(beamforminggain(:,2)),'-.r','LineWidth',2)
plot(varphi/pi,pow2db(beamforminggain(:,3)),'--g','LineWidth',2)
ax = gca;
set(ax, 'XTick', [-0.5, -1/3, -1/6 0, 1/6, 1/3, 0.5]);
xticklabels({'$-\frac{\pi}{2}$','$-\frac{\pi}{3}$','$-\frac{\pi}{6}$','$0$','$\frac{\pi}{6}$','$\frac{\pi}{3}$','$\frac{\pi}{2}$'});
ylim([-30 10]);
xlabel('Observation angle $\varphi$','Interpreter','latex');
ylabel('Beamforming gain [dB]','Interpreter','latex');
legend({'$\varphi_{\textrm{beam}}=0$', '$\varphi_{\textrm{beam}}=\pi/4$', '$\varphi_{\textrm{beam}}=\pi/3$'},'Interpreter','latex','Location','NorthWest');
set(gca,'fontsize',16);

