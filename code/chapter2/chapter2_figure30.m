%This Matlab script can be used to reproduce Figure 2.30 in the textbook:
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

nu = 5;
S = 7;

frequencies = nu/S;

integerSamples = (0:S-1);
realSamples = linspace(0,S-1,1000);

sampledValues = exp(1i*2*pi*frequencies'*integerSamples);

sampledValuesDenser = exp(1i*2*pi*frequencies'*realSamples);

sampledValues_dft = fftshift(fft(sampledValues(1,:))/sqrt(S));


%% Plot the simulation results
set(groot,'defaultAxesTickLabelInterpreter','latex');  

figure;
hold on; box on; grid on;

plot(realSamples,real(sampledValuesDenser),'b-','LineWidth',2);
plot(realSamples,imag(sampledValuesDenser),'r--','LineWidth',2);
plot(integerSamples,real(sampledValues),'k*','LineWidth',2);
plot(integerSamples,imag(sampledValues),'k*','LineWidth',2);
xlabel('Sample time','Interpreter','latex');
legend({'Real part', 'Imaginary part','Samples'},'Interpreter','Latex','Location','NorthEast');
set(gca,'fontsize',16);


figure;
hold on; box on; grid on;
plot(0:S-1,real(sampledValues_dft),'ro','LineWidth',2);
plot(0:S-1,imag(sampledValues_dft),'k*','LineWidth',2);
plot(0:S-1,real(sampledValues_dft),'ro','LineWidth',2);
xlabel('Normalized frequency','Interpreter','latex');
legend({'Real part', 'Imaginary part'},'Interpreter','Latex','Location','NorthEast');
set(gca,'fontsize',16);
xticklabels({'$-\frac{3}{7}$', '$-\frac{2}{7}$', '$-\frac{1}{7}$', '$0$','$\frac{1}{7}$','$\frac{2}{7}$','$\frac{3}{7}$'});
ylim([-0.5,3])