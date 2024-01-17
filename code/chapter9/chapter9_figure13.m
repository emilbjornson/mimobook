%This Matlab script can be used to reproduce Figure 9.13 in the textbook:
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

%Define the distances in the scenario
horizontalDistance = 10;
d_t = [linspace(0,100,1001) 50 50+20*sqrt(6) 50-20*sqrt(6)];
d_r = 100-d_t;


%Number of atoms
N = 200;

%Select wavelength
lambda = 0.1;

%Select area of an atom
atomArea = (lambda/4)^2;


%Compute the channel gain with ideal configuration
channelGain = N^2*(atomArea/(4*pi))^2./((horizontalDistance^2+d_t.^2).*(horizontalDistance^2+d_r.^2));



%% Plot simulation results
set(groot,'defaultAxesTickLabelInterpreter','latex');

figure;
hold on; box on; grid on;

plot(d_t(1:end-3),pow2db(channelGain(1:end-3)),'b-','LineWidth',2);
plot(d_t(end-2:end),pow2db(channelGain(end-2:end)),'k*','LineWidth',2);
xlabel('Distance $d_{\rm w}$ [m]','Interpreter','latex');
ylabel('Channel gain [dB]','Interpreter','latex');
set(gca,'fontsize',16);
