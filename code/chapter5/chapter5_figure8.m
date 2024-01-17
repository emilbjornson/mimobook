%This Matlab script can be used to reproduce Figure 5.8 in the textbook:
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

seed = 18;
rng(seed)

%Variance of the Gaussian distribution
beta = 1;

%Generate time samples across 0.1 s (100 ms)
t = (0:0.1:100)/1000;

%Compute the time difference between the different points
tMatrix = repmat(t,[length(t),1]);
timeDiff = (tMatrix-tMatrix');


%Select wavelength
lambda = 0.1;


%Select speed of motion (m/s)
upsilon = 0.1; 

%Create the correlation matrix between all the time locations
corrMatrix = beta*sinc(timeDiff*2*upsilon/lambda);


%Generate sequence of channel realizations
corrMatrixSqrt = sqrtm(corrMatrix);
u = (randn(length(t),1)+1i*randn(length(t),1))/sqrt(2);

h_slow = corrMatrixSqrt*u;



%Select speed of motion (m/s)
upsilon = 25; 

%Create the correlation matrix between all the time locations
corrMatrix = beta*sinc(timeDiff*2*upsilon/lambda);

%Generate sequence of channel realizations
corrMatrixSqrt = sqrtm(corrMatrix);
u = (randn(length(t),1)+1i*randn(length(t),1))/sqrt(2);

h_fast = corrMatrixSqrt*u;




%% Plot simulation results
set(groot,'defaultAxesTickLabelInterpreter','latex');

figure;
hold on; box on; grid on;
plot(t,abs(h_slow),'--k','LineWidth',2)
plot(t,abs(h_fast),'-.r','LineWidth',2)
xlabel('Time $t$ [s]','Interpreter','latex');
ylabel('$|h(t)|$','Interpreter','latex');
set(gca,'fontsize',16);
legend({'$\upsilon=0.1\,$m/s','$\upsilon=25\,$m/s'},'Interpreter','latex','Location','NorthEast');
