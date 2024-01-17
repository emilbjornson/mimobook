%This Matlab script can be used to reproduce Figure 5.20 in the textbook:
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
clear


%Create a dense grid of x values for the PDF
x = linspace(0,6,10000);


%Select range of number of antennas
Mvalues = [1 8 32];


y = zeros(length(x),length(Mvalues));

for m = 1:length(Mvalues)

    M = Mvalues(m);

    %Compute the PDF of the channel capacity of an iid Rayleigh fading
    %channel where q||h||^2/N0 has the scaled chi-squared distribution. If
    %x is the capacity value, then since %q||h||^2/N0 = 2^x-1 we have the
    %CDF (2.^x-1).^(M-1).*exp(-(2.^x-1))/factorial(M-1) and the PDF becomes

    y(:,m) = log(2)*2.^x.*(2.^x-1).^(M-1).*exp(-(2.^x-1))/factorial(M-1);

end



%% Plot simulation result
figure;
set(groot,'defaultAxesTickLabelInterpreter','latex');

box on; hold on; grid on;
plot(x,y(:,1),'b-.','LineWidth',2);
plot(x,y(:,2),'r--','LineWidth',2);
plot(x,y(:,3),'k-','LineWidth',2);
xlabel('Capacity $C_{\mathbf{h}}$','Interpreter','latex');
ylabel('Probability density function','Interpreter','latex');
set(gca,'fontsize',16);
legend({'$M=1$','$M=8$','$M=32$'},'Interpreter','latex','Location','northwest')
xlim([0 6]);
