%This Matlab script can be used to reproduce Figure 4.40 in the textbook:
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

%Number of horizontal antennas 
Mh = [10 10];

%Number of vertical antennas
Mv = [4 1];

theta_beam = 0;
%% Compute the beamforming gain in different azimuth directions
theta = linspace(-pi/2,pi/2,1000);
beamforminggain = zeros(length(theta),length(Mh));


for i = 1:length(theta)
    
    factor = pi*(sin(theta(i))-sin(theta_beam))/2;
    
    for m = 1:length(Mh)
        
        if factor == 0
            beamforminggain(i,m) = Mh(m)*Mv(m);
        else
            beamforminggain(i,m) = abs(sin(Mv(m)*factor)/sin(factor))^2/Mv(m)*Mh(m);
        end
        
    end
    
end


%% Plot the simulation results
set(groot,'defaultAxesTickLabelInterpreter','latex');  

figure;
hold on; box on; grid on;
plot(theta/pi,pow2db(beamforminggain(:,1)),'r--','LineWidth',2)
plot(theta/pi,pow2db(beamforminggain(:,2)),'-b','LineWidth',2)
ax = gca;
set(ax, 'XTick', [-0.5, -1/3, -1/6 0, 1/6, 1/3, 0.5]);
xticklabels({'$-\frac{\pi}{2}$','$-\frac{\pi}{3}$','$-\frac{\pi}{6}$','$0$','$\frac{\pi}{6}$','$\frac{\pi}{3}$','$\frac{\pi}{2}$'});
ylim([-20 20]);
xlabel('Observation angle $\theta$','Interpreter','latex');
ylabel('Beamforming gain [dB]','Interpreter','latex');
legend({'UPA', 'ULA'},'Interpreter','latex');
set(gca,'fontsize',16);
