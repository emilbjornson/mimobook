%This Matlab script can be used to reproduce Figure 4.21 in the textbook:
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
L = 5;

M = [20 10 5];

%% Compute the beamforming gain in different directions
Phi = linspace(-2,2,1000);
Afunction = zeros(length(Phi),length(M));


for i = 1:length(Phi)
    
    for m = 1:length(M)
        
    factor = pi*(L/M(m))*Phi(i);
    

        if factor == 0
            Afunction(i,m) = M(m);
        else
            Afunction(i,m) = abs(sin(M(m)*factor)/sin(factor))^2/M(m);
        end

    end
    
end


%% Plot the simulation results
set(groot,'defaultAxesTickLabelInterpreter','latex');  

figure;
hold on; box on; grid on;
plot(Phi,pow2db(Afunction(:,1)),'-b','LineWidth',2)
plot(Phi,pow2db(Afunction(:,2)),'r:','LineWidth',2)
plot(Phi,pow2db(Afunction(:,3)),'k--','LineWidth',2)
ax = gca;
ylim([-15 15]);
xlabel('$\Phi$','Interpreter','latex');
ylabel('$A(\Phi)$ [dB]','Interpreter','latex');
legend({'$M=20, \Delta=\lambda/4$', '$M=10, \Delta=\lambda/2$', '$M=5, \Delta=\lambda$'},'Interpreter','Latex','Location','NorthWest');
set(gca,'fontsize',16);
