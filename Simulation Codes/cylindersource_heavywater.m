clc
clear all
close all
format short
%% Thermal neutron (from cylinder source) transport in heavy water 

lamda_a = 24994.0175; %cm mean free path of absorption
lamda_s = 2.8501; %cm mean free path of scattering

sigma_a = 1/lamda_a; %barns cross section abs
sigma_s = 1/lamda_s; %barns cross section scat

sigma_t = sigma_a + sigma_s; %barns total cross section
lamda_t = 1/sigma_t; %cm mfp

%no of scatter guess before abs
nsctrg = sigma_s/sigma_a;

%neutrons counts from source
nparticles = 5000;

dshield = 10; %any loc for counting n

for j = 1:25 %no of samples
   
    nout = 0; %neutrons at distance > dshield
    nin = 0; %neutrons at distance < dshield
    
    for i = 1:nparticles
        %neutron source loc
        z(i) = 2*(-1+2*rand()); %cylinder source with z = [-2,2] (height: 4cm)
        zs(i) = z(i);
        r0 = 0.025*sqrt(rand()); %dia of cyl = 0.5mm
        theta0 = 2*pi*rand();
        x(i) = r0*cos(theta0);
        y(i) = r0*sin(theta0);
        xs(i) = x(i);
        ys(i) = y(i);
        
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
    
            if rand() < sigma_a/sigma_t
                is_absorbed = 1;
            end
        end
    
        %distance travelled by n from origin
        r(i) = sqrt((z(i)-zs(i))^2 + (y(i)-ys(i))^2 + (x(i)-xs(i))^2);

        if r(i) >= dshield
            nout = nout + 1;
        else
            nin = nin + 1;
        end
    end
    
    mofnh(j) = mean(neutron_history);
    mofdt(j) = mean(r);
    mofmaxdt(j) = max(r);
    mofnout(j) = mean(nout);
    mofnin(j) = mean(nin);

end

figure
hist(r); %histogram of distance travelled from origin

figure
plot3(x,y,z,'b.'); %3d plot of neutrons

probin = 1 - (mean(mofnout)/(mean(mofnout)+mean(mofnin))); %prob of n < rshield

fprintf('mean of neutron history: %.4f\n', mean(mofnh))
fprintf('mean of neutron distance: %.4f\n', mean(mofdt))
fprintf('mean of max n distance: %.4f\n', mean(mofmaxdt))
fprintf('prob of n is within rshield: %.4f\n', probin)