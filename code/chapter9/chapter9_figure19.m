%This Matlab script can be used to reproduce Figure 9.19 in the textbook:
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


%% Define the surface geometry

%Carrier frequency
fc = 3e9;

%Speed of light
c = 3e8;

%Wavelength
lambda = c/fc;

N_H = 20; %Number of elements per row
N_V = 20; %Number of elements per column
spacing = lambda/4; %Atom spacing

N = N_H*N_V; %Total number of elements

%Define array response vector
arrayresponse_ULA = @(varphi,theta,M) exp(-1i*2*pi*spacing*sin(varphi)*cos(theta)*(0:M-1)/lambda)';

arrayresponse_UPA = @(varphi,theta,M_H,M_V) kron(arrayresponse_ULA(theta,0,M_V),arrayresponse_ULA(varphi,theta,M_H));

%Define Npulse used in Equations (7.5) and (7.6)
Npulse = 16;

%% Define the propagation environment

%Location of transmitting BS (in meters)
BSlocation = [40 -200 0];

%Location of receiving UE (in meters)
UElocation = [20 0 0];

distBS_surf = norm(BSlocation); %Distance from BS to the center of the surface
distUE_surf = norm(UElocation); %Distance from UE to the center of the surface
distBS_UE = norm(BSlocation - UElocation); %Distance from BS to UE

%Compute azimuth angles to the BS and UE as seen from the surface
varphiBS_surf = atan(BSlocation(2)/BSlocation(1));
varphiUE_surf = atan(UElocation(2)/UElocation(1));

%Urban Micro-cell pathloss models from ETSI TR 125 996 (where d is in meter)
%from Table 5.1. Environment parameters 
pathlossLOS = @(d) db2pow(-30.18-26*log10(d));
pathlossNLOS = @(d) db2pow(-34.53-38*log10(d));


%Number of paths (including LOS paths)
%The number of (sub-)paths is 20 according to Table 5.1. Environment parameters
%from ETSI TR 125 996.
%There is no LOS connection between base station and user.
L_t = 21; %From transmitter to surface
L_r = 21; %From surface to receiver
L_s = 20; %From transmitter to receiver



%Subcarrier spacing (Hertz)
subSpacing = 15e3;

%Range of number of subcarriers to consider
subCarriers = [25 50:50:1000];

%Compute the corresponding bandwidths
bandwidths = subSpacing*subCarriers;


%Number of Monte Carlo setups with random multipath components
nbrOfrealizations = 500;

%Prepare to compute the rates at the different methods
%rateScatter corresponds to random configuration
rateScatter = zeros(length(bandwidths),max(subCarriers),nbrOfrealizations);
rateNoSurface = zeros(length(bandwidths),max(subCarriers),nbrOfrealizations);
ratePowerMethod = zeros(length(bandwidths),max(subCarriers),nbrOfrealizations);
rateUpper = zeros(length(bandwidths),max(subCarriers),nbrOfrealizations);



%% Go through random realizations of the multipath components
for r = 1:nbrOfrealizations

    disp(['Realization ' num2str(r) ' out of ' num2str(nbrOfrealizations)]);


    %% Compute random propagation environment

    %Compute angles of arrival/departure of paths to/from the surface according to Step 7
    %of Section 5.3.2 from ETSI TR 125 996. The
    %first path is LOS while other paths have random angles. Note that the
    %distribution for paths given in the report is applied for sub-paths
    %here.
    deviationAzimuthAngleInterval = 40*pi/180; %Uniform distribution -40 to +40 degrees
    varphi_t = varphiBS_surf + [0; deviationAzimuthAngleInterval*(2*rand(L_t-1,1)-1)];
    varphi_r = varphiUE_surf + [0; deviationAzimuthAngleInterval*(2*rand(L_r-1,1)-1)];

    deviationElevationAngleInterval = 10*pi/180; %Uniform distribution -10 to +10 degrees
    theta_t = 0 + [0; deviationElevationAngleInterval*(2*rand(L_t-1,1)-1)];
    theta_r = 0 + [0; deviationElevationAngleInterval*(2*rand(L_r-1,1)-1)];

    %Propagation delays are computed based on the length of the LOS path.
    %Scattered paths have a delay that is uniformly distributed between the
    %LOS delay and twice this value.
    tau_t = distBS_surf*(1 + [0; rand(L_t-1,1)])/c;
    tau_r = distUE_surf*(1 + [0; rand(L_r-1,1)])/c;
    tau_s = distBS_UE*(1 + rand(L_s,1))/c;

    %The propagation loss of the different paths are computed so that the
    %LOS has its share according to the Rice factors, while the remaining
    %power is distributed among the other terms as in ETSI TR 125 996 (Step 6 in Section 5.3.2).
    L_t_powfactor = 10.^(-tau_t(2:end)+0.2*randn(L_t-1,1));
    L_r_powfactor = 10.^(-tau_r(2:end)+0.2*randn(L_r-1,1));
    L_s_powfactor = 10.^(-tau_s+0.2*randn(L_s,1));

    %The propagation losses from ETSI TR 125 996 are for isotropic
    %antennas. This factor compensates for the smaller size of the atoms
    lossComparedToIsotropic = spacing^2/(lambda^2/(4*pi));


    %Compute propagation losses for channels to/from the surface

    %Set Rician factors (the first one is smaller since the distance is
    %larger)
    RicefactorBS_surf = 5;
    RicefactorUE_surf = 10;

    L_t_pathloss = lossComparedToIsotropic*pathlossLOS(distBS_surf)*[RicefactorBS_surf/(1+RicefactorBS_surf); (1/(1+RicefactorBS_surf))*L_t_powfactor/sum(L_t_powfactor)];
    L_r_pathloss = lossComparedToIsotropic*pathlossLOS(distUE_surf)*[RicefactorUE_surf/(1+RicefactorUE_surf); (1/(1+RicefactorUE_surf))*L_r_powfactor/sum(L_r_powfactor)];


    %Compute propagation losses for the direct paths
    L_s_pathloss = pathlossNLOS(distBS_UE)*L_s_powfactor/sum(L_s_powfactor);



    %% Go through the range of considered bandwidths and compute discrete-time channels
    for b = 1:length(bandwidths)

        %Extract the bandwidth
        B = bandwidths(b);

        %Compute discrete-time impulse responses

        %Compute sampling delay according to Eqn. (7.5)
        eta = min(tau_s) - (Npulse-2)/(2*B);

        %Approximate the length of the impulse response based on the delay
        %spread plus Npulse-1 to compensate for the length of the pulse shape
        Tp1 = floor(B*(2*(distBS_surf+distUE_surf)-distBS_UE)/c)+Npulse-1;

        %Compute the number of subcarriers
        S = floor(B/subSpacing);

        %Compute the channels based on the formulas in the book
        h_cascade = zeros(N,S);
        h_s = zeros(S,1);

        %Go through all channel taps
        for k = 1:Tp1

            %Go through all paths to and from the surface
            for l1 = 1:L_t
                for l2 = 1:L_r

                    %Compute elements of the cascaded channels for all
                    %subcarriers
                    h_cascade(:,k) = h_cascade(:,k) + sqrt(L_t_pathloss(l1)*L_r_pathloss(l2))*exp(-1i*2*pi*fc*(tau_t(l1)+tau_r(l2)-eta))* arrayresponse_UPA(varphi_t(l1),theta_t(l1),N_H,N_V) .*  arrayresponse_UPA(varphi_r(l2),theta_r(l2),N_H,N_V)*sinc(k-1+B*(eta-tau_t(l1)-tau_r(l2)));

                end
            end

            %Go through all the static paths
            for l = 1:L_s

                h_s(k,1) = h_s(k,1) + sqrt(L_s_pathloss(l))*exp(-1i*2*pi*fc*(tau_s(l)-eta))*sinc(k-1+B*(eta-tau_s(l)));

            end

        end

        %Compute the frequency-domain channels
        %Compute a SxS DFT matrix
        F = fft(eye(S));
        h_s_bar = F*h_s; 
        h_cascade_bar = F*h_cascade.';

        %% Compute achievable rates

        %Transmit power
        P = 1*B/1e6; %1 W per MHz

        %Noise power spectral density (including 10 dB noise figure)
        N0 = db2pow(-174+10)/1000; %W per Hz

        


        %Baseline with random configuration
        config_scattering = exp(1i*2*pi*rand(N,1));



        %Run the power iteration method
        config_powerMethod = ones(N,1);

        Aval = [h_s_bar h_cascade_bar];
        A = Aval'*Aval;
        A = (A+A')/2;

        for n = 1:20

            %Compute one step in the power method
            w = [1; config_powerMethod];
            w_new = A*w;
            w_new = w_new*conj(w_new(1));

            config_powerMethod = w_new(2:end)./abs(w_new(2:end));

        end



        %Compute the SNR per subcarrier that obtained with the different
        %surface configurations if equal power allocation is used
        SNRsScatter = zeros(S,1);
        SNRsNoSurface = zeros(S,1);
        SNRsPowerMethod = zeros(S,1);
        SNRsUpper = zeros(S,1);
        
        for k = 1:S

            SNRsScatter(k) = P * abs((h_s_bar(k)+h_cascade_bar(k,:)*config_scattering))^2/(B*N0);
            SNRsNoSurface(k) = P * abs(h_s_bar(k))^2/(B*N0);
            SNRsPowerMethod(k) = P * abs((h_s_bar(k)+h_cascade_bar(k,:)*config_powerMethod))^2/(B*N0);
            SNRsUpper(k) = P * (abs(h_s_bar(k)) + sum(abs(h_cascade_bar(k,:))))^2/(B*N0);

        end

        %Compute the rates that are obtained with the different surface
        %configurations if optimal waterfilling power allocation is used
        powerAllocation = functionWaterfilling(S,1./SNRsScatter);
        rateScatter(b,1:S,r) =  B/(S+Tp1-1)*log2(1+(SNRsScatter.*powerAllocation)');

        powerAllocation = functionWaterfilling(S,1./SNRsNoSurface);
        rateNoSurface(b,1:S,r) =  B/(S+Tp1-1)*log2(1+(SNRsNoSurface.*powerAllocation)');

        powerAllocation = functionWaterfilling(S,1./SNRsPowerMethod);
        ratePowerMethod(b,1:S,r) =  B/(S+Tp1-1)*log2(1+(SNRsPowerMethod.*powerAllocation)');

        powerAllocation = functionWaterfilling(S,1./SNRsUpper);
        rateUpper(b,1:S,r) =  B/(S+Tp1-1)*log2(1+(SNRsUpper.*powerAllocation)');


    end


end


set(groot,'defaultAxesTickLabelInterpreter','latex');


%% Plot the simulation results
figure;
hold on; box on; grid on;
plot(bandwidths/1e6,mean(sum(rateUpper,2),3)/1e6,'r-','LineWidth',2);
plot(bandwidths/1e6,mean(sum(ratePowerMethod,2),3)/1e6,'k--.','LineWidth',2);
plot(bandwidths/1e6,mean(sum(rateScatter,2),3)/1e6,'b--','LineWidth',2);
plot(bandwidths/1e6,mean(sum(rateNoSurface,2),3)/1e6,'k:','LineWidth',2);
set(gca,'fontsize',16);
xlabel('Bandwidth [MHz]','Interpreter','Latex');
ylabel('Capacity [Mbps]','Interpreter','Latex');
legend({'Upper bound','Power iteration','Random configuration','No surface'},'Interpreter','latex','Location','NorthWest');
