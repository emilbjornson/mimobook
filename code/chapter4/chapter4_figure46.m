%This Matlab script can be used to reproduce Figure 4.46 in the textbook:
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


beamAngles = pi/4;
arrayRotation = [0 pi/4];

%Number of antennas in the ULA
M = 10;

%% Compute the beamforming gain in different directions
varphi = linspace(-pi/2,pi/2,1000);
beamforminggain = zeros(length(varphi),length(arrayRotation));


for i = 1:length(varphi)
    
    for m = 1:length(arrayRotation)
        
        factor = pi*(sin(varphi(i)-arrayRotation(m))-sin(beamAngles-arrayRotation(m)))/2;
        
        antennaGain = 4*cos(varphi(i)-arrayRotation(m));
        if antennaGain<0
            antennaGain = 0;
        end
        
        if factor == 0
            beamforminggain(i,m) = antennaGain*M;
        else
            beamforminggain(i,m) = antennaGain*abs(sin(M*factor)/sin(factor))^2/M;
        end
        
    end
    
end


%% Plot the simulation results
set(groot,'defaultAxesTickLabelInterpreter','latex');  

figure;
hold on; box on; grid on;
plot(varphi/pi,pow2db(beamforminggain(:,1)),'-b','LineWidth',2)
plot(varphi/pi,pow2db(beamforminggain(:,2)),'-.r','LineWidth',2)
ax = gca;
set(ax, 'XTick', [-0.5, -0.25, 0, 0.25, 0.5]);
xticklabels({'$-\frac{\pi}{2}$','$-\frac{\pi}{4}$','$0$','$\frac{\pi}{4}$','$\frac{\pi}{2}$'});
ylim([-20 20]);
xlabel('Observation angle $\varphi$','Interpreter','latex');
ylabel('Beamforming and antenna gain [dBi]','Interpreter','latex');
legend({'Electrical beamforming', 'Mechanical beamforming'},'Interpreter','latex','Location','NorthWest');
set(gca,'fontsize',16);

