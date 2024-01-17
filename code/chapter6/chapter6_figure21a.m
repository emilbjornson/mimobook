%This Matlab script can be used to reproduce Figure 6.21(a) in the textbook:
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

%Select the range of xi-values (start at a small non-zero value to avoid
%division by zero).
eps = 1e-8;
xi1 = linspace(eps,1-eps,2000);
xi2 = 1 - xi1;

%Select the range of power division values
powerFraction1 = linspace(0,1,2000);
powerFraction2 = 1-powerFraction1;

%Bandwidth in MHz
B = 10;


%% Generate rate region with different channel quality (the *2 is used to define the SNR values for equal power allocation)
SNR1 = 10*2;
SNR2 = 5*2;


%Compute a range of rate values with orthogonal multiple access and
%different power and bandwidth divisions
rate1_OMA = zeros(length(powerFraction1),length(xi1));
rate2_OMA = zeros(length(powerFraction1),length(xi1));

for k = 1:length(xi1)

    rate1_OMA(:,k) = B*xi1(k)*log2(1+powerFraction1'*SNR1/xi1(k));
    rate2_OMA(:,k) = B*xi2(k)*log2(1+powerFraction2'*SNR2/xi2(k));

end

rate1_OMA_all = rate1_OMA(:);
rate2_OMA_all = rate2_OMA(:);


%Determine the outer boundary by identifying the simulated point that
%maximizes min(R1/xi,R2/(1-xi)) for different values of xi. This is like
%looking for the outmost feasible point on different lines from the origin.
rate1_OMA2 = zeros(length(xi1),1);
rate2_OMA2 = zeros(length(xi1),1);

for k = 1:length(xi1)

    [~,maxind] = max(min([rate1_OMA_all/xi1(k) rate2_OMA_all/xi2(k)],[],2));

    rate1_OMA2(k) = rate1_OMA_all(maxind);
    rate2_OMA2(k) = rate2_OMA_all(maxind);

end




%Rates with non-orthogonal multiple access
rate1_NOMA = B*log2(1+SNR1*powerFraction1);
rate2_NOMA = B*log2(1+SNR2*powerFraction2./(1+SNR2*powerFraction1));


%Find sum-rate and max-min points
[sumrateValue,indSR] = max(rate1_NOMA+rate2_NOMA);
[maxminValue,indMMF] = max(min([rate1_NOMA; rate2_NOMA],[],1));
[maxminValue_OMA,indMMF_OMA] = max(min([rate1_OMA2'; rate2_OMA2'],[],1));



%Plot simulation results
set(groot,'defaultAxesTickLabelInterpreter','latex');

figure;
hold on; box on; grid on
plot(rate1_NOMA,rate2_NOMA,'k','LineWidth',2);
plot(rate1_OMA2,rate2_OMA2,'k--','LineWidth',2);
fill([0 rate1_NOMA 0],[0 rate2_NOMA 0],[252 243 161]/256);
plot(rate1_OMA2,rate2_OMA2,'k--','LineWidth',2);
scatter(rate1_NOMA(indMMF),rate2_NOMA(indMMF),100,'r*','LineWidth',2)
scatter(rate1_OMA2(indMMF_OMA),rate2_OMA2(indMMF_OMA),100,'r*','LineWidth',2)
scatter(rate1_NOMA(indSR),rate2_NOMA(indSR),100,'rs','LineWidth',2)
xlabel('$R_1$ [Mbit/s]','Interpreter','latex');
ylabel('$R_2$ [Mbit/s]','Interpreter','latex');
set(gca,'fontsize',13);
axis([0 50 0 50]);
xticks(0:5:50);
yticks(0:5:50);
legend({'NOMA','OMA (FDMA)'},'Interpreter','latex','Location','NorthEast');
axis square