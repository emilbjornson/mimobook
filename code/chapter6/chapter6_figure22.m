%This Matlab script can be used to reproduce Figure 6.22 in the textbook:
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


%Bandwidth in MHz
B = 10;

%Select the range of power division values
p = linspace(0,1,1000);

steps1 = [0 0.25 0.5 0.7 0.82 0.9 0.95];
steps2 = [0 0.02 0.05 0.1 0.18 0.3 0.5 0.7];


%% Generate rate region with different channel quality
set(groot,'defaultAxesTickLabelInterpreter','latex');

%Select SNR values
SNR1 = 10*3;
SNR2 = 5*3;
SNR3 = 2.5*3;


%Plot simulation results
figure;
hold on; box on; grid on;


for n = 1:length(steps1)

    rate1 = zeros(1000,1);
    rate2 = zeros(1000,1);
    rate3 = zeros(1000,1);

    for k = 1:1000

        p1 = (1-steps1(n))*p(k);
        p2 = (1-steps1(n))*(1-p(k));
        p3 = steps1(n);

        rate1(k) = B*log2(1+SNR1*p1);
        rate2(k) = B*log2(1+SNR2*p2./(1+SNR2*p1));
        rate3(k) = B*log2(1+SNR3*p3./(1+SNR3*(p1+p2)));

    end

    if n==1
        plot3(rate1,rate2,rate3,'k-','LineWidth',2);
    else
        plot3(rate1,rate2,rate3,'k--','LineWidth',1);
    end

end

for n = 1:length(steps2)

    rate1 = zeros(1000,1);
    rate2 = zeros(1000,1);
    rate3 = zeros(1000,1);

    for k = 1:1000

        p1 = steps2(n);
        p2 = (1-steps2(n))*p(k);
        p3 = (1-steps2(n))*(1-p(k));

        rate1(k) = B*log2(1+SNR1*p1);
        rate2(k) = B*log2(1+SNR2*p2./(1+SNR2*p1));
        rate3(k) = B*log2(1+SNR3*p3./(1+SNR3*(p1+p2)));

    end

    if n==1
        plot3(rate1,rate2,rate3,'k-','LineWidth',2);
    else
        plot3(rate1,rate2,rate3,'k--','LineWidth',1);
    end


end



rate1 = zeros(1000,1);
rate2 = zeros(1000,1);
rate3 = zeros(1000,1);

for k = 1:1000

    p1 = p(k);
    p2 = 0;
    p3 = 1-p(k);

    rate1(k) = B*log2(1+SNR1*p1);
    rate2(k) = B*log2(1+SNR2*p2./(1+SNR2*p1));
    rate3(k) = B*log2(1+SNR3*p3./(1+SNR3*(p1+p2)));

end

plot3(rate1,rate2,rate3,'k-','LineWidth',2);

view(142.5,30);

xlabel('$R_1$ [Mbit/s]','Interpreter','latex');
ylabel('$R_2$ [Mbit/s]','Interpreter','latex');
zlabel('$R_3$ [Mbit/s]','Interpreter','latex');
set(gca,'fontsize',13);
set(gcf, 'Renderer', 'Painters');
xlim([0 50]);
ylim([0 50]);
zlim([0 50]);
yticks(0:10:50);
