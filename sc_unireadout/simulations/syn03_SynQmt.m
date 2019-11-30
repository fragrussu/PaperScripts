%% Genereate synthetic signals for qMT
%
% Authors: Francesco Grussu, <f.grussu@ucl.ac.uk> 
%          Marco Battiston, <marco.battiston@ucl.ac.uk>  
%
% BSD 2-Clause License
% 
% Copyright (c) 2019, University College London.
% All rights reserved.
% 
% Redistribution and use in source and binary forms, with or without
% modification, are permitted provided that the following conditions are met:
% 
% 1. Redistributions of source code must retain the above copyright notice, this
%    list of conditions and the following disclaimer.
% 
% 2. Redistributions in binary form must reproduce the above copyright notice,
%    this list of conditions and the following disclaimer in the documentation
%    and/or other materials provided with the distribution.
% 
% THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
% AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
% IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
% DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
% FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
% DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
% SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
% CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
% OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
% OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
% 


%% Clear
clc
clear all
close all

%% Add stuff
addpath(genpath('../dependencies')) 


%% Options

%%%% Input files
bufferfile = '../sc_phantom/qmt_M.nii';           %%% 4D NIFTI file (header reference)
vcsf_file = '../sc_phantom/vcsf.nii';    %%% CSF volume fraction
vwm_file = '../sc_phantom/vwm.nii';      %%% WM volume fraction
vgm_file = '../sc_phantom/vgm.nii';      %%% GM volume fraction
tissue_file = '../sc_phantom/tissue.nii';    %%%% tissue
outfile = fullfile('../sc_phantom/multimodal_images','vartissue_qmt_M.nii');           %%% output NIFTI


rho_csf_file =  fullfile('../sc_phantom/multimodal_tissueprops','rhocsf.nii');
rho_wm_file  =  fullfile('../sc_phantom/multimodal_tissueprops','rhowm.nii');
rho_gm_file  =  fullfile('../sc_phantom/multimodal_tissueprops','rhogm.nii');

t2_csf_file  =  fullfile('../sc_phantom/multimodal_tissueprops','t2csf_ms.nii');
t2_wm_file  =  fullfile('../sc_phantom/multimodal_tissueprops','t2wm_ms.nii');
t2_gm_file  =  fullfile('../sc_phantom/multimodal_tissueprops','t2gm_ms.nii');

t1_csf_file  =  fullfile('../sc_phantom/multimodal_tissueprops','t1csf_ms.nii');
t1_wm_file  =  fullfile('../sc_phantom/multimodal_tissueprops','t1wm_ms.nii');
t1_gm_file  =  fullfile('../sc_phantom/multimodal_tissueprops','t1gm_ms.nii');

k_wm_file  =  fullfile('../sc_phantom/multimodal_tissueprops','kwm_hz.nii');
k_gm_file  =  fullfile('../sc_phantom/multimodal_tissueprops','kgm_hz.nii');

bpf_wm_file  =  fullfile('../sc_phantom/multimodal_tissueprops','bpfwm.nii');
bpf_gm_file  =  fullfile('../sc_phantom/multimodal_tissueprops','bpfgm.nii');

t2b_wm_file  =  fullfile('../sc_phantom/multimodal_tissueprops','t2bwm_us.nii');
t2b_gm_file  =  fullfile('../sc_phantom/multimodal_tissueprops','t2bgm_us.nii');



%%%%%% ----> tissue parameter vector should be: BPF[n.u.] T2f[s] T2b[s] kfb[Hz]
%%%%%% ----> auxiliary parameters: R1obs [Hz]

%%%%% Sequence parameters
TE = 24;  % ms
Nspp = 4;
N_rep = 1; 
number_data_points = 44;
pulse_duration = 15*1e-3; % [s]
pulse_gap = 15*1e-3; % [s]
number_pulses_per_train = 25;
end_train_firstexc = 17*1e-3; % [s]
readout_duration = 78*1e-3; % [s]
flipangle_list = [300 1465 1440 426 1429 433 1460 524 1462 1459 1438]; % flip angle with no repetition
delta_list = [96000 8393 13597 1070 14125 1007 1013 2698 3763 1053 3779]; % offset with no repetition in Hz
flipangle_vect =  reshape(repmat(flipangle_list, Nspp, 1), number_data_points, 1);
delta_vect =  reshape(repmat(delta_list, Nspp, 1), number_data_points, 1);
freepar_model = 5; 
model_type = 'MTBlochshared'; 


%% Fill protocol structure
Nmeas = Nspp*length(flipangle_list);
protocol.N = number_data_points; 
protocol.M = ones(protocol.N, 1);
protocol.Nspp = 4;
protocol.shape = 'sg_100_100_0';
protocol.tau = pulse_duration*ones(sum(protocol.M), 1);
protocol.gap = pulse_gap*ones(sum(protocol.M), 1);
protocol.n_pulses = number_pulses_per_train*ones(sum(protocol.M), 1);
protocol.delay = end_train_firstexc;
protocol.flipangle = 0; % no excitation interleved within offresonance saturation
protocol.alpha_dur = 0; % no excitation interleved within offresonance saturation
protocol.alpha_shape = []; % no excitation interleved within offresonance saturation
protocol.Tadc = readout_duration;
protocol.shot = 1;
shot_ind = reshape(repmat([1; 2; 3; 4], 1, N_rep), protocol.Nspp*N_rep, 1);
protocol.shot_index = shot_ind;
protocol.R1b = 1;
protocol.flipangle_eff = flipangle_vect;
for n = 1: protocol.N
    protocol.sampling.delta{n} = delta_vect(n);
end
protocol.user_opt.plot_fit = 0;
protocol.user_opt.lineshape = 'superLorentzian';
protocol.user_opt.multistart = 1;
protocol.user_opt.gridsearch = 1;
protocol.user_opt.CVp0 = 0.15;
protocol.user_opt.verbose = 0;
protocol.user_opt.T_quant = 80*1e-6; %optimal_protocol.options.T_quant;
protocol.user_opt.lookup = 1;
protocol.user_opt.freepar = freepar_model;
protocol.user_opt.scalingvect = ones(protocol.user_opt.freepar, 1);
protocol.user_opt.costfun = 'rician'; % options {offsetGauss, gaussian}
protocol.user_opt.update_loop = 1;
protocol.user_opt.voxelwise_corr = 0;

model_ID = model_type;

protocol_syn = protocol;

[datapoints_syn, model_struct_syn] = fill_model_info(protocol_syn, model_ID);
datapoints_orig = datapoints_syn;


%% Load NIFTIs

% Load NIFTIs
buff = nifti(bufferfile); buff = buff.dat(:,:,:,:); qmt = zeros(size(buff));
vcsf = nifti(vcsf_file); vcsf = vcsf.dat(:,:,:);
vgm = nifti(vgm_file); vgm = vgm.dat(:,:,:);
vwm = nifti(vwm_file); vwm = vwm.dat(:,:,:);
tissue = nifti(tissue_file); tissue = tissue.dat(:,:,:);

rho_csf = nifti(rho_csf_file); rho_csf = rho_csf.dat(:,:,:);
rho_gm = nifti(rho_gm_file); rho_gm = rho_gm.dat(:,:,:);
rho_wm = nifti(rho_wm_file); rho_wm = rho_wm.dat(:,:,:);

t2_csf = nifti(t2_csf_file); t2_csf = t2_csf.dat(:,:,:);
t2_gm = nifti(t2_gm_file); t2_gm = t2_gm.dat(:,:,:);
t2_wm = nifti(t2_wm_file); t2_wm = t2_wm.dat(:,:,:);

t1_gm = nifti(t1_gm_file); t1_gm = t1_gm.dat(:,:,:);
t1_wm = nifti(t1_wm_file); t1_wm = t1_wm.dat(:,:,:);

t2b_gm = nifti(t2b_gm_file); t2b_gm = t2b_gm.dat(:,:,:);
t2b_wm = nifti(t2b_wm_file); t2b_wm = t2b_wm.dat(:,:,:);

k_gm = nifti(k_gm_file); k_gm = k_gm.dat(:,:,:);
k_wm = nifti(k_wm_file); k_wm = k_wm.dat(:,:,:);

bpf_gm = nifti(bpf_gm_file); bpf_gm = bpf_gm.dat(:,:,:);
bpf_wm = nifti(bpf_wm_file); bpf_wm = bpf_wm.dat(:,:,:);

r1_gm_sec = 1./(t1_gm/1e3);   % in seconds
r1_wm_sec = 1./(t1_wm/1e3);   % in seconds

t2b_gm_sec = t2b_gm/1e6;  % in seconds
t2b_wm_sec = t2b_wm/1e6;  % in seconds

t2_gm_sec = t2_gm/1e6; % in seconds
t2_wm_sec = t2_wm/1e6; % in seconds


%% Calculate signal

fprintf('\n\nqMT\n\n')

% Generate signalss
for kk=1:size(qmt,3)
    
    tic
    
    fprintf('           Slice %d out of %d\n',kk,size(qmt,3));
    
    for jj=1:size(qmt,2)
        for ii=1:size(qmt,1)

            tissueval = tissue(ii,jj,kk);
            
            if(tissueval)
                
                f_csf = vcsf(ii,jj,kk);
                f_gm = vgm(ii,jj,kk);
                f_wm = vwm(ii,jj,kk);        

                rhoval_csf = rho_csf(ii,jj,kk);
                rhoval_gm = rho_gm(ii,jj,kk);
                rhoval_wm = rho_wm(ii,jj,kk);

                t2val_csf = t2_csf(ii,jj,kk);
                t2val_gm = t2_gm(ii,jj,kk);
                t2val_gm_sec = t2_gm_sec(ii,jj,kk);
                t2val_wm = t2_wm(ii,jj,kk);
                t2val_wm_sec = t2_wm_sec(ii,jj,kk);

                r1val_gm_sec = r1_gm_sec(ii,jj,kk);
                r1val_wm_sec = r1_wm_sec(ii,jj,kk);

                bpfval_gm = bpf_gm(ii,jj,kk);
                bpfval_wm = bpf_wm(ii,jj,kk);

                kval_gm = k_gm(ii,jj,kk);
                kval_wm = k_wm(ii,jj,kk);

                t2bval_gm = t2b_gm(ii,jj,kk);
                t2bval_wm = t2b_wm(ii,jj,kk);
                t2bval_gm_sec = t2b_gm_sec(ii,jj,kk);
                t2bval_wm_sec = t2b_wm_sec(ii,jj,kk);

                %%%% CSF signal is trivial
                sig_csf = rhoval_csf*exp(-TE/t2val_csf)*ones(1,Nmeas);

                %%%% WM signal
                % Set parameters for WM
                M0f_wm = rhoval_wm*exp(-TE/t2val_wm);
                M0b_wm = M0f_wm*bpfval_wm/(1-bpfval_wm);  
                model_struct_syn.model.p = [M0f_wm; M0b_wm; t2val_wm_sec; t2bval_wm_sec; kval_wm];
                model_struct_syn.aux = r1val_wm_sec;

                % Generate signal            
                if strcmp(model_ID, 'MTBlochnormshared') || strcmp(model_ID, 'MTBlochshared') || strcmp(model_ID, 'MTBlochnormsharedMS')
                    datapoints_syn(:,3) = circshift(datapoints_orig(:, 3), shot_ind(1)-1);
                end
                model_struct_syn.shot = shot_ind(1);
                sig_wm = model_prediction(model_struct_syn.model.p, datapoints_syn, model_ID, model_struct_syn);

                %%%% GM signal
                % Set parameters for GM
                M0f_gm = rhoval_gm*exp(-TE/t2val_gm);
                M0b_gm = M0f_gm*bpfval_gm/(1-bpfval_gm);  
                model_struct_syn.model.p = [M0f_gm; M0b_gm; t2val_gm_sec; t2bval_gm_sec; kval_gm];
                model_struct_syn.aux = r1val_gm_sec;

                % Generate signal            
                if strcmp(model_ID, 'MTBlochnormshared') || strcmp(model_ID, 'MTBlochshared') || strcmp(model_ID, 'MTBlochnormsharedMS')
                    datapoints_syn(:,3) = circshift(datapoints_orig(:, 3), shot_ind(1)-1);
                end
                model_struct_syn.shot = shot_ind(1);
                sig_gm = model_prediction(model_struct_syn.model.p, datapoints_syn, model_ID, model_struct_syn);

                % Reshape to have consistent array dimensions
                sig_csf = reshape(sig_csf,1,numel(sig_csf));
                sig_wm = reshape(sig_wm,1,numel(sig_wm));
                sig_gm = reshape(sig_gm,1,numel(sig_gm));

                % Combine signals using tissue volume fractions
                sig = f_csf*sig_csf + f_gm*sig_gm + f_wm*sig_wm;

                qmt(ii,jj,kk,:) = sig;
            
            else
                
                qmt(ii,jj,kk,:) = zeros(1,Nmeas);
                
            end
            
            
            
            
            
        end
    end
    
    toc
    
    fprintf('\n')
    
end

% Save output NIFTI
copyfile(bufferfile,outfile);
mynifti = nifti(outfile);
mynifti.dat(:,:,:,:) = qmt;
