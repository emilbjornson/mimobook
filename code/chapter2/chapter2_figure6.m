%This Matlab script can be used to reproduce Figure 2.6 in the textbook:
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

%Compute PDF of complex Gaussian distribution
[X,Y] = meshgrid(linspace(-5,5,100), linspace(-5,5,100));

sigma2 = 1;

PDF = exp(-(X.^2+Y.^2)/sigma2)/(pi*sigma2);


%Plot simulation result
set(groot,'defaultAxesTickLabelInterpreter','latex');

figure;
surf(X,Y,PDF);
xlabel('Imaginary part','Interpreter','latex');
ylabel('Real part','Interpreter','latex');
zlabel('Probability density function','Interpreter','latex');
colormap(autumn);
set(gca,'fontsize',16);
set(gcf, 'Renderer', 'Painters');
