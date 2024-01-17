%This Matlab script can be used to reproduce Figure 6.26 in the textbook:
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
M = 4;

%Select angles-of-arrival for the two users
varphi1 = -pi/20;
varphi2 = pi/20;


%Divide the power between the users in the dual uplink
powersplit = 0.1:0.1:0.9;
powersplit_detailed = linspace(0,1,501);


%Select SNRs of the two users (for M=1 antenna and equal power allocation)
SNR1_equalalloc = 10;
SNR2_equalalloc = 5;


%% Generate rate regions in the dual uplink

%Generate array responses with a ULA
h1 = exp(-1i*pi*(0:M-1)'*sin(varphi1));
h2 = exp(-1i*pi*(0:M-1)'*sin(varphi2));

rate1_dualuplink = zeros(4,length(powersplit));
rate2_dualuplink = zeros(4,length(powersplit));

for m = 1:length(powersplit)

    SNR1 = SNR1_equalalloc*2*powersplit(m);
    SNR2 = SNR2_equalalloc*2*(1-powersplit(m));

    %Compute points on the Pareto boundary of the rate region
    rate1_dualuplink(:,m) = [B*log2(1+SNR1*norm(h1)^2) B*log2(1+SNR1*norm(h1)^2) B*log2(1+SNR1*real(h1'*((SNR2*(h2*h2')+eye(M))\h1))) 0]';
    rate2_dualuplink(:,m) = [0 B*log2(1+SNR2*real(h2'*((SNR1*(h1*h1')+eye(M))\h2))) B*log2(1+SNR2*norm(h2)^2) B*log2(1+SNR2*norm(h2)^2)]';

end


%% Generate Pareto boundary of the downlink region

rate1_nonlinear_boundary = zeros(length(powersplit_detailed),1);
rate2_nonlinear_boundary = zeros(length(powersplit_detailed),1);

ordering = 1;
maxSumrate = 0;

for m = 1:length(powersplit_detailed)

    SNR1 = SNR1_equalalloc*2*powersplit_detailed(m);
    SNR2 = SNR2_equalalloc*2*(1-powersplit_detailed(m));

    rate1_option1 = B*log2(1+SNR1*real(h1'*((SNR2*(h2*h2')+eye(M))\h1)));
    rate2_option1 = B*log2(1+SNR2*norm(h2)^2);

    rate1_option2 = B*log2(1+SNR1*norm(h1)^2);
    rate2_option2 = B*log2(1+SNR2*real(h2'*((SNR1*(h1*h1')+eye(M))\h2)));


    if ordering == 1

        if rate1_option1+rate2_option1 > maxSumrate

            rate1_nonlinear_boundary(m) = rate1_option1;
            rate2_nonlinear_boundary(m) = rate2_option1;

            maxSumrate = rate1_option1+rate2_option1;

        else

            ordering = 2;

            rate1_option1 = rate1_nonlinear_boundary(m-1);
            rate2_option1 = rate2_nonlinear_boundary(m-1);

            rate1_maxsum = powersplit_detailed*rate1_option1+(1-powersplit_detailed)*rate1_option2;
            rate2_maxsum = powersplit_detailed*rate2_option1+(1-powersplit_detailed)*rate2_option2;


        end

    end


    if ordering == 2


        rate1_nonlinear_boundary(m) = rate1_option2;
        rate2_nonlinear_boundary(m) = rate2_option2;


    end

end


%Find sum-rate and max-min points
[~,indMMF_DL] = max(min([rate1_nonlinear_boundary.'; rate2_nonlinear_boundary.'],[],1));


%Plot simulation results
set(groot,'defaultAxesTickLabelInterpreter','latex');

figure;
hold on; box on; grid on;

plot(rate1_nonlinear_boundary,rate2_nonlinear_boundary,'k-','LineWidth',2);

plot(rate1_dualuplink(:,1),rate2_dualuplink(:,1),'b:','LineWidth',2);

fill([0 rate1_nonlinear_boundary' 0],[0 rate2_nonlinear_boundary' 0],[252 243 161]/256);

for k = 1:length(powersplit)

    plot(rate1_dualuplink(:,k),rate2_dualuplink(:,k),'b:','LineWidth',2);

end

plot(rate1_nonlinear_boundary,rate2_nonlinear_boundary,'k-','LineWidth',2);

scatter(rate1_nonlinear_boundary(indMMF_DL),rate1_nonlinear_boundary(indMMF_DL),100,'r*','LineWidth',2)
plot(rate1_maxsum,rate2_maxsum,'r:','LineWidth',2)


xlabel('$R_1$ [Mbit/s]','Interpreter','latex');
ylabel('$R_2$ [Mbit/s]','Interpreter','latex');
set(gca,'fontsize',13);
axis([0 70 0 70]);
xticks(0:10:70);
legend({'Capacity region','Dual uplink regions'},'Interpreter','latex','Location','NorthEast');
axis square