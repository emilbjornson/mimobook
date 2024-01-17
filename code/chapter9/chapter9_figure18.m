%This Matlab script can be used to reproduce Figure 9.18 in the textbook:
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

%Define frequency range [in GHz]
fRange = linspace(2,4,100);

%Capacitance values to consider
Cn = [0.66 0.85 0.91 1.07]*1e-12;

R = 1; %Effective resistance


%Compute reflection coefficients
coeff_R1 = zeros(length(fRange),length(Cn));
coeff_R0 = zeros(length(fRange),length(Cn));

for k = 1:length(fRange)

    %Angular frequency
    omega = 2*pi*fRange(k)*1e9;

    for m = 1:length(Cn)

        coeff_R1(k,m) =  refcoefficient(omega,Cn(m),R);
        coeff_R0(k,m) =  refcoefficient(omega,Cn(m),0);

    end

end


%% Plot simulation results
set(groot,'defaultAxesTickLabelInterpreter','latex');

figure;
hold on; box on; grid on;
plot(fRange,angle(coeff_R1(:,1)),'k','LineWidth',2);
plot(fRange,angle(coeff_R1(:,2)),'r--','LineWidth',2);
plot(fRange,angle(coeff_R1(:,3)),'b-.','LineWidth',2);
plot(fRange,angle(coeff_R1(:,4)),'k:','LineWidth',2);
set(gca,'fontsize',16);
xlabel('Frequency $f$ [GHz]','Interpreter','Latex');
ylabel('Phase response','Interpreter','Latex');
legend({[num2str(Cn(1)*1e12) ' pF'],[num2str(Cn(2)*1e12) ' pF'],[num2str(Cn(3)*1e12) ' pF'],[num2str(Cn(4)*1e12) ' pF']},'Interpreter','Latex','Location','NorthEast');
ylim([-pi pi]);
yticks(-pi:pi/4:pi);
yticklabels({'$-\pi$','$-3\pi/4$','$-\pi/2$','$-\pi/4$','$0$','$\pi/4$','$\pi/2$','$3\pi/4$','$\pi$'})



figure;
hold on; box on; grid on;
plot(fRange,pow2db(abs(coeff_R1(:,1))),'k','LineWidth',2);
plot(fRange,pow2db(abs(coeff_R1(:,2))),'r--','LineWidth',2);
plot(fRange,pow2db(abs(coeff_R1(:,3))),'b-.','LineWidth',2);
plot(fRange,pow2db(abs(coeff_R1(:,4))),'k:','LineWidth',2);
plot(fRange,pow2db(abs(coeff_R0(:,1))),'g','LineWidth',2);
plot(fRange,pow2db(abs(coeff_R0(:,2))),'g','LineWidth',2);
plot(fRange,pow2db(abs(coeff_R0(:,3))),'g','LineWidth',2);
plot(fRange,pow2db(abs(coeff_R0(:,4))),'g','LineWidth',2);
set(gca,'fontsize',16);
xlabel('Frequency $f$ [GHz]','Interpreter','Latex');
ylabel('Amplitude response [dB]','Interpreter','Latex');
legend({['$1$ ohm: ' num2str(Cn(1)*1e12) ' pF'],['$1$ ohm: ' num2str(Cn(2)*1e12) ' pF'],['$1$ ohm: ' num2str(Cn(3)*1e12) ' pF'],['$1$ ohm: ' num2str(Cn(4)*1e12) ' pF'],'$0$ ohm'},'Interpreter','Latex','Location','SouthEast');
ylim([-3 0]);






function coeff = refcoefficient(omega,Cn,Rn)

%Define
L1 = 2.5e-9; %Bottom layer inductance
L2 = 0.7e-9; %Top layer inductance
Z0 = 377; %Impedance of free space

%Compute the impedance of the surface
Zn = 1i*omega*L1*(1i*omega*L2+1./(1i*omega*Cn)+Rn)./(1i*omega*L1+(1i*omega*L2+1./(1i*omega*Cn)+Rn));

%Compute reflection coefficient
coeff = (Zn-Z0)./(Zn+Z0);

end