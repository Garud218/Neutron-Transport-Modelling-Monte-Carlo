clc
clear all
close all
format short
%% MFP as function of energy
%E: eV & sigma: barns & mfp: cm 

data = readtable('interpolated_E_sigma_1H_s.csv');
E1H_s = data.E_eV_;
sigma1H_s = data.sigma_barns_;

data2 = readtable('interpolated_E_sigma_1H_a.csv');
E1H_a = data2.E_eV_;
sigma1H_a = data2.sigma_barns_;

data3 = readtable('interpolated_E_sigma_16O_s.csv');
E16O_s = data3.E_eV_;
sigma16O_s = data3.sigma_barns_;

data4 = readtable('interpolated_E_sigma_16O_a.csv');
E16O_a = data4.E_eV_;
sigma16O_a = data4.sigma_barns_;

%Cross section to mean free path
dn_h2o = 0.997; %g/cc
mw_h2o = 18.0153; %g
mol = 6.022*10^23;
N_h2o = (dn_h2o/mw_h2o)*mol;
N_h = 2*N_h2o;

sum_h2o_s = (sigma1H_s*N_h + sigma16O_s*N_h2o)*10^(-24); %scat h2o
sum_h2o_a = (sigma1H_a*N_h + sigma16O_a*N_h2o)*10^(-24); %abs h2o

lamda_s_h2o = 1./sum_h2o_s; %scat h2o
lamda_a_h2o = 1./sum_h2o_a; %abs h2o

%total mean free path
sigH2O_s = 1./lamda_s_h2o;
sigH2O_a = 1./lamda_a_h2o;
sigH2O_t = sigH2O_s + sigH2O_a;
lamda_t_h2o = 1./sigH2O_t;

%plot of ln(E) vs ln(lamda_h2o)
figure
loglog(E16O_s,lamda_s_h2o,linewidth=1.5,color='red')
xlabel('E (eV)',FontName='Times New Roman');
ylabel('\lambda (cm)',FontName='Times New Roman');
title('MFP(E) for H{_2}O scattering',FontName='Times New Roman',FontWeight='normal');
grid('minor')

figure
loglog(E16O_a,lamda_a_h2o,linewidth=1.5,color='red')
xlabel('E (eV)',FontName='Times New Roman');
ylabel('\lambda (cm)',FontName='Times New Roman');
title('MFP(E) for H{_2}O absorption',FontName='Times New Roman',FontWeight='normal');
grid('minor')

figure
loglog(E16O_s,lamda_t_h2o,linewidth=1.5,color='red')
xlabel('E (eV)',FontName='Times New Roman');
ylabel('\lambda (cm)',FontName='Times New Roman');
title('MFP(E) for H{_2}O total',FontName='Times New Roman',FontWeight='normal');
grid('minor')

save('E_mfp_data.mat','lamda_t_h2o','sigH2O_a','sigH2O_s','sigH2O_t','E1H_s')