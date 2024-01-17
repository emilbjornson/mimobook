%This Matlab script can be used to reproduce Figure 4.20 in the textbook:
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

spacings_norm = 0.5;

%% Compute the beamforming gain in different directions
Phi = linspace(-2,2,1000);
Afunction = zeros(length(Phi),1);


for i = 1:length(Phi)
    
    factor = pi*spacings_norm*Phi(i);
    

        if factor == 0
            Afunction(i) = M;
        else
            Afunction(i) = abs(sin(M*factor)/sin(factor))^2/M;
        end
    
end


%% Plot the simulation results
set(groot,'defaultAxesTickLabelInterpreter','latex');  

figure;
hold on; box on; grid on;
plot(Phi,pow2db(Afunction(:,1)),'b-','LineWidth',2)
ax = gca;
ylim([-10 10]);
xlabel('$\Phi$','Interpreter','latex');
ylabel('$A(\Phi)$ [dB]','Interpreter','latex');
set(gca,'fontsize',16);
