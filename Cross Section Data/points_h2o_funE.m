clc
clear all
close all
format short
%% Neutron (from point source) transport in light water as fn of energy 

%neutrons counts from source
nparticles = 10;

%dshield = 5; %any loc for counting n

load('E_mfp_data.mat','lamda_t_h2o','sigH2O_s','sigH2O_a','sigH2O_t','E1H_s');

for k = 1:10
    
    lamda_t = lamda_t_h2o(k); %cm mfp
   
    %no of scatter guess before abs
    nsctrg = sigH2O_s(k)/sigH2O_a(k);

    for j = 1:1 %no of samples
    
        nout = 0; %neutrons at distance > dshield
        nin = 0; %neutrons at distance < dshield
    
        for i = 1:nparticles
            %neutron source loc
            x(i) = 0;
            y(i) = 0;
            z(i) = 0;
    
            %rand() varies b/w [0,1]
    
            is_absorbed = 0; %neutron not absorbed
            neutron_history(i) = 0; %no of collision
            while is_absorbed == 0
                s = -lamda_t*log(rand()); %length travelled by neutron
                theta = asin(-1+2*rand()); 
                phi = 2*pi*rand();
    
                %distance in coordinates
                dx = s*cos(theta)*cos(phi);
                dy = s*cos(theta)*sin(phi);
                dz = s*sin(theta);
    
                x(i) = x(i) + dx;
                y(i) = y(i) + dy;
                z(i) = z(i) + dz;
                neutron_history(i) = neutron_history(i) + 1; %no of steps = no of collision before abs
    
                if rand() < sigH2O_a/sigH2O_t
                    is_absorbed = 1;
                end
            end
    
            %distance travelled by n from origin
            r(i) = sqrt(x(i)^2 + y(i)^2 + z(i)^2);
    
            %if r(i) >= dshield
            %    nout = nout + 1;
            %else
            %    nin = nin + 1;
            %end
        end
    
        mofnh(j) = mean(neutron_history);
        mofdt(j) = mean(r);
        mofmaxdt(j) = max(r);
        %mofnout(j) = mean(nout);
        %mofnin(j) = mean(nin);
    
    end
    mofnh_data(k) = mean(mofnh);
    mofdt_data(k) = mean(mofdt);
    mofmaxdt_data(k) = mean(mofmaxdt);
end

%figure
%hist(r); %histogram of distance travelled from origin
%
%figure
%plot3(x,y,z,'b.'); %3d plot of neutrons
%
%probin = 1 - (mean(mofnout)/(mean(mofnout)+mean(mofnin))); %prob of n < rshield

for p = 1:10
    %fprintf('mean of neutron history: %.4f\n', mean(mofnh))
    fprintf('mean of neutron distance for N.E. %f eV is %f\n cm', E1H_s(k), mofdt_data(k))
    %fprintf('mean of max n distance: %.4f\n', mean(mofmaxdt))
    %fprintf('prob of n is within rshield: %.4f\n', probin)
end