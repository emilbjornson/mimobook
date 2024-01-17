%This Matlab script can be used to reproduce Figure 4.15 in the textbook:
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
varphi = linspace(-asin(2/M),asin(2/M),500);
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



rangeHalfPower = varphi(beamforminggain(:,1)>=M/2);
rangeAmplififcation = varphi(beamforminggain(:,1)>=1);


%% Plot the simulation results
set(groot,'defaultAxesTickLabelInterpreter','latex');  

figure;
hold on; box on; grid on;
plot(varphi/pi,pow2db(beamforminggain(:,1)),'-b','LineWidth',2)
plot(rangeAmplififcation/pi,zeros(size(rangeAmplififcation)),'k--','LineWidth',2)
plot(rangeHalfPower/pi,pow2db((M/2))*ones(size(rangeHalfPower)),'k-.','LineWidth',2)
plot([-asin(2/M) asin(2/M)]/pi,[-29 -29],'k:','LineWidth',2)
plot([-asin(2/M) -asin(2/M)]/pi,[-30 -28],'k:','LineWidth',2)
plot([asin(2/M) asin(2/M)]/pi,[-30 -28],'k:','LineWidth',2)
ax = gca;
set(ax, 'YTick', [-30:5:0 7 10]);
set(ax, 'XTick', [-1/15, -1/30, 0, 1/30, 1/15]);
xticklabels({'$-\frac{\pi}{15}$','$-\frac{\pi}{30}$','$0$','$\frac{\pi}{30}$','$\frac{\pi}{15}$'});
xlim([-1/15 1/15]);
ylim([-30 10]);
xlabel('Observation angle $\varphi$','Interpreter','latex');
ylabel('Beamforming gain [dB]','Interpreter','latex');
set(gca,'fontsize',16);