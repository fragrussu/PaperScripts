%% Denoise one noise realisation to look at residual plots -- Gaussian noise
% Author: Francesco Grussu, <f.grussu@ucl.ac.uk>
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
clear all
close all
clc


%% Input stuff

addpath(genpath('../dependencies')) 

%% Data and options

indir ='../sc_phantom';
outdir = fullfile(indir,'multimodal_noiserealisation_gauss');

dwifile = fullfile(indir,'multimodal_images','vartissue_dwi_M.nii');  
irsefile = fullfile(indir,'multimodal_images','vartissue_irse_M.nii');  
mesefile = fullfile(indir,'multimodal_images','vartissue_mese_M.nii');  
qmtfile = fullfile(indir,'multimodal_images','vartissue_qmt_M.nii');  

dwiirsefile = fullfile(indir,'multimodal_images','vartissue_dwiirse_M.nii');
dwimesefile = fullfile(indir,'multimodal_images','vartissue_dwimese_M.nii');
dwiqmtfile = fullfile(indir,'multimodal_images','vartissue_dwiqmt_M.nii');

dwiqmtirsemesefile = fullfile(indir,'multimodal_images','vartissue_dwiqmtirsemese_M.nii');


dwifile_noisy = fullfile(outdir,'vartissue_dwi_noisy');  
irsefile_noisy  = fullfile(outdir,'vartissue_irse_noisy');  
mesefile_noisy  = fullfile(outdir,'vartissue_mese_noisy');  
qmtfile_noisy  = fullfile(outdir,'vartissue_qmt_noisy');  

dwiirsefile_noisy  = fullfile(outdir,'vartissue_dwiirse_noisy');
dwimesefile_noisy  = fullfile(outdir,'vartissue_dwimese_noisy');
dwiqmtfile_noisy  = fullfile(outdir,'vartissue_dwiqmt_noisy');

dwiqmtirsemesefile_noisy  = fullfile(outdir,'vartissue_dwiqmtirsemese_noisy');

cordfile = fullfile(indir,'cord.nii');

snrvals = [10 12.5 15 17.5 20 30 40];
b0ref = 25;

Nmeas_dwi = 68;
Nmeas_qmt = 44;
Nmeas_irse = 12;
Nmeas_mese = 7;



%% Load data



dwiqmtirsemese = nifti(dwiqmtirsemesefile); dwiqmtirsemese = dwiqmtirsemese.dat(:,:,:,:);


Nsnr = length(snrvals);

if(~isdir(outdir))
    mkdir(outdir);
end

for nn=1:Nsnr

    
    
    
    fprintf('\n\n%d out of %d\n\n',nn,Nsnr);
    
    %%% Generate data
    
    sigma = b0ref/snrvals(nn);

 
    dwiqmtirsemese_noisy = dwiqmtirsemese + sigma*randn(size(dwiqmtirsemese)); 
    
    dwi_noisy = dwiqmtirsemese_noisy(:,:,:,1:Nmeas_dwi);
    qmt_noisy = dwiqmtirsemese_noisy(:,:,:,Nmeas_dwi+1:Nmeas_dwi+Nmeas_qmt);
    irse_noisy = dwiqmtirsemese_noisy(:,:,:,Nmeas_dwi+Nmeas_qmt+1:Nmeas_dwi+Nmeas_qmt+Nmeas_irse);
    mese_noisy = dwiqmtirsemese_noisy(:,:,:,Nmeas_dwi+Nmeas_qmt+Nmeas_irse+1:Nmeas_dwi+Nmeas_qmt+Nmeas_irse+Nmeas_mese);
    
    
    dwiqmt_noisy = dwiqmtirsemese_noisy(:,:,:,1:Nmeas_dwi+Nmeas_qmt);
    dwiirse_noisy = dwiqmtirsemese_noisy(:,:,:,[1:Nmeas_dwi (Nmeas_dwi+Nmeas_qmt+1):(Nmeas_dwi+Nmeas_qmt+Nmeas_irse)]);
    dwimese_noisy = dwiqmtirsemese_noisy(:,:,:,[1:Nmeas_dwi (Nmeas_dwi+Nmeas_qmt+Nmeas_irse+1):(Nmeas_dwi+Nmeas_qmt+Nmeas_irse+Nmeas_mese)]);
    
    copyfile(dwiqmtirsemesefile,[dwiqmtirsemesefile_noisy '_snr' num2str(snrvals(nn)) '.nii']);
    buff = nifti([dwiqmtirsemesefile_noisy '_snr' num2str(snrvals(nn)) '.nii']);
    buff.dat(:,:,:,:) = dwiqmtirsemese_noisy;
    
    copyfile(dwifile,[dwifile_noisy '_snr' num2str(snrvals(nn)) '.nii']);
    buff = nifti([dwifile_noisy '_snr' num2str(snrvals(nn)) '.nii']);
    buff.dat(:,:,:,:) = dwi_noisy;
    
    copyfile(qmtfile,[qmtfile_noisy '_snr' num2str(snrvals(nn)) '.nii']);
    buff = nifti([qmtfile_noisy '_snr' num2str(snrvals(nn)) '.nii']);
    buff.dat(:,:,:,:) = qmt_noisy;
    
    copyfile(irsefile,[irsefile_noisy '_snr' num2str(snrvals(nn)) '.nii']);
    buff = nifti([irsefile_noisy '_snr' num2str(snrvals(nn)) '.nii']);
    buff.dat(:,:,:,:) = irse_noisy;
    
    copyfile(mesefile,[mesefile_noisy '_snr' num2str(snrvals(nn)) '.nii']);
    buff = nifti([mesefile_noisy '_snr' num2str(snrvals(nn)) '.nii']);
    buff.dat(:,:,:,:) = mese_noisy;
    
  
    copyfile(dwiqmtfile,[dwiqmtfile_noisy '_snr' num2str(snrvals(nn)) '.nii']);
    buff = nifti([dwiqmtfile_noisy '_snr' num2str(snrvals(nn)) '.nii']);
    buff.dat(:,:,:,:) = dwiqmt_noisy;
    
    copyfile(dwiirsefile,[dwiirsefile_noisy '_snr' num2str(snrvals(nn)) '.nii']);
    buff = nifti([dwiirsefile_noisy '_snr' num2str(snrvals(nn)) '.nii']);
    buff.dat(:,:,:,:) = dwiirse_noisy;
    
    copyfile(dwimesefile,[dwimesefile_noisy '_snr' num2str(snrvals(nn)) '.nii']);
    buff = nifti([dwimesefile_noisy '_snr' num2str(snrvals(nn)) '.nii']);
    buff.dat(:,:,:,:) = dwimese_noisy;

    %%% Denoise data
    MP_slicewise_nifti([dwiqmtirsemesefile_noisy '_snr' num2str(snrvals(nn)) '.nii'],cordfile,[dwiqmtirsemesefile_noisy '_snr' num2str(snrvals(nn))]);
    
    MP_slicewise_nifti([dwifile_noisy '_snr' num2str(snrvals(nn)) '.nii'],cordfile,[dwifile_noisy '_snr' num2str(snrvals(nn))]);
    MP_slicewise_nifti([irsefile_noisy '_snr' num2str(snrvals(nn)) '.nii'],cordfile,[irsefile_noisy '_snr' num2str(snrvals(nn))]);
    MP_slicewise_nifti([qmtfile_noisy '_snr' num2str(snrvals(nn)) '.nii'],cordfile,[qmtfile_noisy '_snr' num2str(snrvals(nn))]);
    MP_slicewise_nifti([mesefile_noisy '_snr' num2str(snrvals(nn)) '.nii'],cordfile,[mesefile_noisy '_snr' num2str(snrvals(nn))]);
    
    MP_slicewise_nifti([dwiirsefile_noisy '_snr' num2str(snrvals(nn)) '.nii'],cordfile,[dwiirsefile_noisy '_snr' num2str(snrvals(nn))]);
    MP_slicewise_nifti([dwiqmtfile_noisy '_snr' num2str(snrvals(nn)) '.nii'],cordfile,[dwiqmtfile_noisy '_snr' num2str(snrvals(nn))]);
    MP_slicewise_nifti([dwimesefile_noisy '_snr' num2str(snrvals(nn)) '.nii'],cordfile,[dwimesefile_noisy '_snr' num2str(snrvals(nn))]);
    
    
end


