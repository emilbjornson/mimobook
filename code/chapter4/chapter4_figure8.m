%This Matlab script can be used to reproduce Figure 4.8 in the textbook:
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

%% Compute the beamforming gain in different directions
varphi_interf = linspace(-pi/2,pi/2,1000);
beamforminggain = zeros(length(varphi_interf),length(M));


for i = 1:length(varphi_interf)
    
    factor = pi*sin(varphi_interf(i))/2;
    
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
plot(varphi_interf/pi,beamforminggain(:,1),'-b','LineWidth',2)
ax = gca;
set(ax, 'XTick', [-0.5, -1/3, -1/6 0, 1/6, 1/3, 0.5]);
xticklabels({'$-\frac{\pi}{2}$','$-\frac{\pi}{3}$','$-\frac{\pi}{6}$','$0$','$\frac{\pi}{6}$','$\frac{\pi}{3}$','$\frac{\pi}{2}$'});
xlabel('Interfering signal angle','Interpreter','latex');
ylabel('Beamforming gain','Interpreter','latex');
set(gca,'fontsize',16);
