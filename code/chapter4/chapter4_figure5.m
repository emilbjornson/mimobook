%This Matlab script can be used to reproduce Figure 4.5 in the textbook:
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

%Set the wavelength
lambda = 2;

[X,Y] = meshgrid(0:0.1:10,-5:0.25:5);

%For a source infinitely far away along x-axis
Z1 = sin(2*pi*X/lambda);


%Source at a finite location
sourcePoint = -5;

distances = sqrt((X-sourcePoint).^2 + Y.^2);

Z2 = sin(2*pi*distances/lambda);



%% Plot simulation results
set(groot,'defaultAxesTickLabelInterpreter','latex');  

figure;
surf(X,Y,Z1);
set(gca,'fontsize',16);
view(-10,40);
xlabel('$x$','Interpreter','Latex');
ylabel('$y$','Interpreter','Latex');
set(gcf, 'Renderer', 'Painters');

%% Plot simulation results
set(groot,'defaultAxesTickLabelInterpreter','latex');  

figure;
surf(X,Y,Z2);
set(gca,'fontsize',16);
view(-10,40);
xlabel('$x$','Interpreter','Latex');
ylabel('$y$','Interpreter','Latex');
set(gcf, 'Renderer', 'Painters');