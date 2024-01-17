%This Matlab script can be used to reproduce Figure 2.20 in the textbook:
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

seed = 4;
rng(seed)

%Set range of signal strengths
x2dB = 0:20;
x2 = 10.^(x2dB/10);
x = sqrt(x2);

%Set parameter values in MSE computation
beta = 1;
N0 = 1;

%Compute exact MSE values
MSE_exact = beta*N0./(beta*x2+N0);



%Number of samples in Monte Carlo method
L = 100;

%Generate random channel and noise realizations
h = sqrt(beta/2)*(randn(L,length(x2))+1i*randn(L,length(x2)));
n = sqrt(N0/2)*(randn(L,length(x2))+1i*randn(L,length(x2)));


%Prepare to save simulation results
MSE_MonteCarlo_biased = zeros(length(x2),1);
MSE_MonteCarlo = zeros(length(x2),1);


%Go through all signal strengths
for m = 1:length(x2)
    
    %Approach with systematic errors
    y = h(:,1)*x(m)+n(:,1); %Use the same set of randomness for every m
    
    hhat = beta*x(m)/(beta*x2(m)+N0)*y;
    
    MSErealization = abs(h(:,1)-hhat).^2;
    
    MSE_MonteCarlo_biased(m) = mean(MSErealization);
    
    
    %Approach with independent errors
    y = h(:,m)*x(m)+n(:,m); %Use a different set of randomness for every m
    
    hhat = beta*x(m)/(beta*x2(m)+N0)*y;
    
    MSErealization = abs(h(:,m)-hhat).^2;
    
    MSE_MonteCarlo(m) = mean(MSErealization);
    
end




%% Plot simulation result
set(groot,'defaultAxesTickLabelInterpreter','latex');  

figure;
hold on; box on; grid on;
plot(x2dB,MSE_exact,'k-','LineWidth',2);
plot(x2dB,MSE_MonteCarlo_biased,'bs--','LineWidth',2);
plot(x2dB,MSE_MonteCarlo,'rd-.','LineWidth',2);
xlabel('$|x|^2$ [dB]','Interpreter','latex');
ylabel('MSE','Interpreter','latex');
legend({'Exact curve','Monte-Carlo: Systematic errors','Monte-Carlo: Independent errors'},'Interpreter','latex','Location','NorthEast');
set(gca,'YScale','log');
set(gca,'fontsize',16);
ylim([1e-2 1]);
