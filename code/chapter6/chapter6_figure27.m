%This Matlab script can be used to reproduce Figure 6.27 in the textbook:
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

%Select range of the number of antennas
Mvalues = [1 4 8];

%Select angles-of-arrival for the two users
varphi1 = -pi/20;
varphi2 = pi/20;


%Divide the power between the users in the dual uplink
powersplit_detailed = linspace(0,1,501);


%Select SNRs of the two users (for M=1 antenna and equal power allocation)
SNR1_equalalloc = 10;
SNR2_equalalloc = 5;




%% Generate Pareto boundary of the downlink region

rate1_nonlinear_boundary = zeros(length(powersplit_detailed),length(Mvalues));
rate2_nonlinear_boundary = zeros(length(powersplit_detailed),length(Mvalues));


for m = 1:length(Mvalues)

    %Generate array responses with a ULA
    h1 = exp(-1i*pi*(0:Mvalues(m)-1)'*sin(varphi1));
    h2 = exp(-1i*pi*(0:Mvalues(m)-1)'*sin(varphi2));

    ordering = 1;
    maxSumrate = 0;

    for k = 1:length(powersplit_detailed)

        SNR1 = SNR1_equalalloc*2*powersplit_detailed(k);
        SNR2 = SNR2_equalalloc*2*(1-powersplit_detailed(k));

        rate1_option1 = B*log2(1+SNR1*real(h1'*((SNR2*(h2*h2')+eye(Mvalues(m)))\h1)));
        rate2_option1 = B*log2(1+SNR2*norm(h2)^2);

        rate1_option2 = B*log2(1+SNR1*norm(h1)^2);
        rate2_option2 = B*log2(1+SNR2*real(h2'*((SNR1*(h1*h1')+eye(Mvalues(m)))\h2)));


        if ordering == 1

            if rate1_option1+rate2_option1 > maxSumrate

                rate1_nonlinear_boundary(k,m) = rate1_option1;
                rate2_nonlinear_boundary(k,m) = rate2_option1;

                maxSumrate = rate1_option1+rate2_option1;

            else

                ordering = 2;

            end

        end


        if ordering == 2


            rate1_nonlinear_boundary(k,m) = rate1_option2;
            rate2_nonlinear_boundary(k,m) = rate2_option2;


        end

    end

end


%% Generate Pareto boundary in the absence of interference

rate1_nointerference = zeros(length(powersplit_detailed),length(Mvalues));
rate2_nointerference = zeros(length(powersplit_detailed),length(Mvalues));


for m = 1:length(Mvalues)

    %Generate array responses with a ULA
    h1 = exp(-1i*pi*(0:Mvalues(m)-1)'*sin(varphi1));
    h2 = exp(-1i*pi*(0:Mvalues(m)-1)'*sin(varphi2));

    for k = 1:length(powersplit_detailed)

        SNR1 = SNR1_equalalloc*2*powersplit_detailed(k);
        SNR2 = SNR2_equalalloc*2*(1-powersplit_detailed(k));

        rate1_nointerference(k,m) = B*log2(1+SNR1*norm(h1)^2);
        rate2_nointerference(k,m) = B*log2(1+SNR2*norm(h2)^2);

    end

end



%Plot simulation results
set(groot,'defaultAxesTickLabelInterpreter','latex');

figure;
hold on; box on; grid on;

plot(rate1_nonlinear_boundary(:,1),rate2_nonlinear_boundary(:,1),'r-.','LineWidth',2);
plot(rate1_nonlinear_boundary(:,2),rate2_nonlinear_boundary(:,2),'b--','LineWidth',2);
plot(rate1_nonlinear_boundary(:,3),rate2_nonlinear_boundary(:,3),'k-','LineWidth',2);

plot(rate1_nointerference(:,1),rate2_nointerference(:,1),'k:','LineWidth',2);
plot(rate1_nointerference(:,2),rate2_nointerference(:,2),'k:','LineWidth',2);
plot(rate1_nointerference(:,3),rate2_nointerference(:,3),'k:','LineWidth',2);

xlabel('$R_1$ [Mbit/s]','Interpreter','latex');
ylabel('$R_2$ [Mbit/s]','Interpreter','latex');
set(gca,'fontsize',13);
axis([0 80 0 80]);
xticks(0:10:80);
axis square
legend({'$M=1$','$M=4$','$M=8$','No interf'},'Interpreter','latex','Location','SouthWest');
