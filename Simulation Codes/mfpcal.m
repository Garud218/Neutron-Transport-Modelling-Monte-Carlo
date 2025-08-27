clc
clear all
close all
format short
%% Mean free path calculator
% MFP = 1/SUMN
% SUMN = sigma*N

%Thermal n cross section data from JANIS
sigmaH_a = 0.332; %barns, abs cross section: H(n,y)
sigmaH_s = 20.491; %barns, scat cross section: H(n,n)
sigmaD_a = 0.000506; %barns, abs cross section: D(n,y)
sigmaD_s = 3.39; %barns, scat cross section: D(n,n)
sigmaO_a = 0.000190; %barns, abs cross section: O(n,y)
sigmaO_s = 3.761; %barns, scat cross section: O(n,n)

E_thn = 25.3; %meV, thermal n energy @20*C

%Density data
dn_h2o = 0.997; %g/cc
dn_d2o = 1.107; %g/cc

%molar weight
mw_h2o = 18.0153; %g
mw_d2o = 20.0276; %g

mol = 6.022*10^23;

%no of atoms
N_h2o = (dn_h2o/mw_h2o)*mol;
N_d2o = (dn_d2o/mw_d2o)*mol;
N_h = 2*N_h2o; N_d = 2*N_d2o;

%SUMN = sum of (sigma*N)
sum_h2o_a = (sigmaH_a*N_h + sigmaO_a*N_h2o)*10^(-24); %abs h2o
sum_d2o_a = (sigmaD_a*N_d + sigmaO_a*N_d2o)*10^(-24); %abs d2o
sum_h2o_s = (sigmaH_s*N_h + sigmaO_s*N_h2o)*10^(-24); %scat h2o
sum_d2o_s = (sigmaD_s*N_d + sigmaO_s*N_d2o)*10^(-24); %scat d2o

%mean free path in cm
lamda_a_h2o = 1/sum_h2o_a; %abs h2o
lamda_a_d2o = 1/sum_d2o_a; %abs d2o
lamda_s_h2o = 1/sum_h2o_s; %scat h2o
lamda_s_d2o = 1/sum_d2o_s; %scat d2o

fprintf('MFP of thermal n abs in h2o: %.4f\n',lamda_a_h2o);
fprintf('MFP of thermal n scat in h2o: %.4f\n',lamda_s_h2o);
fprintf('MFP of thermal n abs in d2o: %.4f\n',lamda_a_d2o);
fprintf('MFP of thermal n scat in d2o: %.4f\n',lamda_s_d2o);

