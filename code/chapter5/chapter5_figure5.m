%This Matlab script can be used to reproduce Figure 5.5 in the textbook:
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

%Create a dense grid of x values for PDF
x = linspace(0,10,10000);

%Select the power of the channel
beta = 1;

%Define the range of Rician k-factors
kappaValues = [0,1,10];

%Initialize the PDFs
y = zeros(length(kappaValues),length(x));

for k = 1:length(kappaValues)

    %Define parameters in the Rician distribution
    nu = sqrt(beta*kappaValues(k)/(kappaValues(k)+1));
    sigma2 = beta/(2*(kappaValues(k)+1));

    %Compute the PDF of the Rician distribution
    y(k,:) = (x/sigma2).*exp(-(x.^2+nu^2)/(2*sigma2)).*besseli(0,x*nu/sigma2);

end


%% Plot Rician fading distribution
set(groot,'defaultAxesTickLabelInterpreter','latex');

figure; hold on; box on; grid on;
plot(x,y(1,:),'b-','LineWidth',2);
plot(x,y(2,:),'r-.','LineWidth',2);
plot(x,y(3,:),'k--','LineWidth',2);
xlabel('$|h|$','Interpreter','latex')
ylabel('Probability density function','Interpreter','latex');
xlim([0 4]);
set(gca,'fontsize',16);
legend({'$\kappa=0$ (Rayleigh)','$\kappa=1$','$\kappa=10$'},'Interpreter','latex','Location','NorthEast');

