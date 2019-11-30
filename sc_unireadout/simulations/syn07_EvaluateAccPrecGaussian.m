%% Evaluate performance of MP-PCA denoising of multimodal spinal cord denoising (accuracy and precision of signal prediction)
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



%% Add useful stuff

addpath(genpath('../dependencies')) 




%% Inputs and options

rootdir = '../sc_phantom';

irsefile = fullfile(rootdir,'multimodal_images','vartissue_irse_M.nii');
dwifile = fullfile(rootdir,'multimodal_images','vartissue_dwi_M.nii');
mesefile = fullfile(rootdir,'multimodal_images','vartissue_mese_M.nii');
qmtfile = fullfile(rootdir,'multimodal_images','vartissue_qmt_M.nii');
dwiirsefile = fullfile(rootdir,'multimodal_images','vartissue_dwiirse_M.nii');
dwiqmtfile = fullfile(rootdir,'multimodal_images','vartissue_dwiqmt_M.nii');
dwimesefile = fullfile(rootdir,'multimodal_images','vartissue_dwimese_M.nii');
dwiqmtirsemesefile = fullfile(rootdir,'multimodal_images','vartissue_dwiqmtirsemese_M.nii');
cordfile = fullfile(rootdir,'cord.nii');
snrvals = [10 12.5 15 17.5 20 30 40];
Nnoise = 300;
b0ref = 25; % Mean WM signal at b = 0; reference signal with respect to which SNR should be calculated
no_resbins = 15; % Number of bins to evaluate the residual slope


%% Load data

Nsnr = length(snrvals);

% Load NIFTIs
irse = nifti(irsefile); irse = irse.dat(:,:,:,:);
mese = nifti(mesefile); mese = mese.dat(:,:,:,:);
dwi = nifti(dwifile); dwi = dwi.dat(:,:,:,:);
qmt = nifti(qmtfile); qmt = qmt.dat(:,:,:,:);

dwiqmt = nifti(dwiqmtfile); dwiqmt = dwiqmt.dat(:,:,:,:);
dwiirse = nifti(dwiirsefile); dwiirse = dwiirse.dat(:,:,:,:);
dwimese = nifti(dwimesefile); dwimese = dwimese.dat(:,:,:,:);
dwiqmtirsemese = nifti(dwiqmtirsemesefile); dwiqmtirsemese = dwiqmtirsemese.dat(:,:,:,:);

cord = nifti(cordfile); cord = cord.dat(:,:,:);

% Calculate image dimensions
Nx = size(dwi,1); Ny = size(dwi,2); Nz = size(dwi,3);
Nmeas_dwi = size(dwi,4); Nmeas_irse = size(irse,4); Nmeas_mese = size(mese,4); Nmeas_qmt = size(qmt,4);



% Allocate output

sigma_denjoint4 = nan(Nsnr,Nnoise);
sigma_dwi_densingle = nan(Nsnr,Nnoise);
sigma_irse_densingle = nan(Nsnr,Nnoise);
sigma_mese_densingle = nan(Nsnr,Nnoise);
sigma_qmt_densingle = nan(Nsnr,Nnoise);
sigma_irse_denjoint2 = nan(Nsnr,Nnoise);
sigma_mese_denjoint2 = nan(Nsnr,Nnoise);
sigma_qmt_denjoint2 = nan(Nsnr,Nnoise);
        
detectsig_denjoint4 = nan(Nsnr,Nnoise);
detectsig_dwi_densingle = nan(Nsnr,Nnoise);
detectsig_irse_densingle = nan(Nsnr,Nnoise);
detectsig_mese_densingle = nan(Nsnr,Nnoise);
detectsig_qmt_densingle = nan(Nsnr,Nnoise);
detectsig_irse_denjoint2 = nan(Nsnr,Nnoise);
detectsig_mese_denjoint2 = nan(Nsnr,Nnoise);
detectsig_qmt_denjoint2 = nan(Nsnr,Nnoise);

accur_dwi_denjoint4 = nan(Nsnr,Nnoise);
accur_dwi_denjoint2irse = nan(Nsnr,Nnoise);
accur_dwi_denjoint2mese = nan(Nsnr,Nnoise);
accur_dwi_denjoint2qmt = nan(Nsnr,Nnoise);
accur_dwi_densingle = nan(Nsnr,Nnoise);
accur_dwi_noisy = nan(Nsnr,Nnoise);
accur_irse_denjoint4 = nan(Nsnr,Nnoise);
accur_irse_denjoint2 = nan(Nsnr,Nnoise);
accur_irse_densingle = nan(Nsnr,Nnoise);
accur_irse_noisy = nan(Nsnr,Nnoise);
accur_mese_denjoint4 = nan(Nsnr,Nnoise);
accur_mese_denjoint2 = nan(Nsnr,Nnoise);
accur_mese_densingle = nan(Nsnr,Nnoise);
accur_mese_noisy = nan(Nsnr,Nnoise);
accur_qmt_denjoint4 = nan(Nsnr,Nnoise);
accur_qmt_denjoint2 = nan(Nsnr,Nnoise);
accur_qmt_densingle = nan(Nsnr,Nnoise);
accur_qmt_noisy = nan(Nsnr,Nnoise);


prec_dwi_denjoint4 = nan(Nsnr,Nnoise);
prec_dwi_denjoint2irse = nan(Nsnr,Nnoise);
prec_dwi_denjoint2mese = nan(Nsnr,Nnoise);
prec_dwi_denjoint2qmt = nan(Nsnr,Nnoise);
prec_dwi_densingle = nan(Nsnr,Nnoise);
prec_dwi_noisy = nan(Nsnr,Nnoise);
prec_irse_denjoint4 = nan(Nsnr,Nnoise);
prec_irse_denjoint2 = nan(Nsnr,Nnoise);
prec_irse_densingle = nan(Nsnr,Nnoise);
prec_irse_noisy = nan(Nsnr,Nnoise);
prec_mese_denjoint4 = nan(Nsnr,Nnoise);
prec_mese_denjoint2 = nan(Nsnr,Nnoise);
prec_mese_densingle = nan(Nsnr,Nnoise);
prec_mese_noisy = nan(Nsnr,Nnoise);
prec_qmt_denjoint4 = nan(Nsnr,Nnoise);
prec_qmt_denjoint2 = nan(Nsnr,Nnoise);
prec_qmt_densingle = nan(Nsnr,Nnoise);
prec_qmt_noisy = nan(Nsnr,Nnoise);





% Loop over SNR levels
fprintf('*****************************************************************\n');
fprintf('           %s        \n',mfilename);
fprintf('*****************************************************************\n\n');
for ss=1:Nsnr
   
    fprintf('    SNR level %d out of %d (SNR = %f)\n\n',ss,Nsnr,snrvals(ss));
    
    % Calculate sigma of noise given SNR @ b = 0 in WM
    sigma = b0ref/snrvals(ss); 
    
    % Loop over noise instantiations
    for qq=1:Nnoise
        
        
        fprintf('            noise instantation %d out of %d (SNR %d out of %d)\n',qq,Nnoise,ss,Nsnr);
        
        % Synthesise noise
        noise_real = sigma*randn(size(dwiqmtirsemese));    % Gaussian noise (real-valued)
        
        % Add noise to data
        dwiqmtirsemese_noisy = dwiqmtirsemese + noise_real;
        
        % Extract subexperiments
        dwiirse_noisy = dwiqmtirsemese_noisy(:,:,:,[1:Nmeas_dwi (Nmeas_dwi+Nmeas_qmt+1):(Nmeas_dwi+Nmeas_qmt+Nmeas_irse)]);
        dwiqmt_noisy = dwiqmtirsemese_noisy(:,:,:,1:(Nmeas_dwi+Nmeas_qmt));
        dwimese_noisy = dwiqmtirsemese_noisy(:,:,:,[1:Nmeas_dwi (Nmeas_dwi+Nmeas_qmt+Nmeas_irse+1):(Nmeas_dwi+Nmeas_qmt+Nmeas_irse+Nmeas_mese)]);

        dwi_noisy = dwiqmtirsemese_noisy(:,:,:,1:Nmeas_dwi);   % Noisy magnitude DWI only
        qmt_noisy = dwiqmtirsemese_noisy(:,:,:,(Nmeas_dwi+1):(Nmeas_dwi+Nmeas_qmt));   % Noisy magnitude DWI only
        irse_noisy = dwiqmtirsemese_noisy(:,:,:,(Nmeas_dwi+Nmeas_qmt+1):(Nmeas_dwi+Nmeas_qmt+Nmeas_irse)); % Noisy magnitude IRSE only
        mese_noisy = dwiqmtirsemese_noisy(:,:,:,(Nmeas_dwi+Nmeas_qmt+Nmeas_irse+1):(Nmeas_dwi+Nmeas_qmt+Nmeas_irse+Nmeas_mese)); % Noisy measurements MESE only
        
        % Denoise slice-wise
        wc_irse = [];
        wc_dwi = [];
        wc_mese = [];
        wc_qmt = [];
        wc_irse_noisy = [];
        wc_dwi_noisy = [];
        wc_mese_noisy = [];
        wc_qmt_noisy = [];
        wc_qmt_densingle = [];    % _densingle stands for denoising performed individually
        wc_qmt_denjoint2 = [];    % _joint stands for joint denoisiny between 2 modalities
        wc_qmt_denjoint4 = [];    % _joint stands for joint denoisiny between 3 modalities
        wc_irse_densingle = [];    % _densingle stands for denoising performed individually
        wc_irse_denjoint2 = [];    % _joint stands for joint denoisiny between 2 modalities
        wc_irse_denjoint4 = [];    % _joint stands for joint denoisiny between 3 modalities
        wc_dwi_densingle = [];    % _densingle stands for denoising performed individually
        wc_dwi_denjoint2irse = [];    % _joint stands for joint denoisiny between 2 modalities
        wc_dwi_denjoint2mese = [];    % _joint stands for joint denoisiny between 2 modalities
        wc_dwi_denjoint2qmt = [];    % _joint stands for joint denoisiny between 2 modalities
        wc_dwi_denjoint4 = [];    % _joint stands for joint denoisiny between 3 modalities
        wc_mese_densingle = [];    % _densingle stands for denoising performed individually
        wc_mese_denjoint2 = [];    % _joint stands for joint denoisiny between 2 modalities
        wc_mese_denjoint4 = [];    % _joint stands for joint denoisiny between 3 modalities
        
        buffsigma_denjoint4 = nan(1,Nz);
        buffsigma_dwi_densingle = nan(1,Nz);
        buffsigma_qmt_densingle = nan(1,Nz);
        buffsigma_irse_densingle = nan(1,Nz);
        buffsigma_mese_densingle = nan(1,Nz);
        buffsigma_irse_denjoint2 = nan(1,Nz);
        buffsigma_mese_denjoint2 = nan(1,Nz);
        buffsigma_qmt_denjoint2 = nan(1,Nz);
        
        buffdetectsig_denjoint4 = nan(1,Nz);
        buffdetectsig_dwi_densingle = nan(1,Nz);
        buffdetectsig_qmt_densingle = nan(1,Nz);
        buffdetectsig_irse_densingle = nan(1,Nz);
        buffdetectsig_mese_densingle = nan(1,Nz);
        buffdetectsig_irse_denjoint2 = nan(1,Nz);
        buffdetectsig_mese_denjoint2 = nan(1,Nz);
        buffdetectsig_qmt_denjoint2 = nan(1,Nz);
        
        for zz=1:Nz
           
            % Keep mask of current slice only
            cord_sl = zeros(size(cord));
            cord_sl(:,:,zz) = cord(:,:,zz);
            
            if( isempty(cord_sl(cord_sl==1))==0 )
            
                % Extract ROIs
                roi_dwiqmtirsemese = transpose(ExtractVoxelsWithinMask(dwiqmtirsemese,cord_sl));
                roi_dwiirse = transpose(ExtractVoxelsWithinMask(dwiirse,cord_sl));
                roi_dwimese = transpose(ExtractVoxelsWithinMask(dwimese,cord_sl));
                roi_dwiqmt = transpose(ExtractVoxelsWithinMask(dwiqmt,cord_sl));
                roi_irse = transpose(ExtractVoxelsWithinMask(irse,cord_sl));
                roi_mese = transpose(ExtractVoxelsWithinMask(mese,cord_sl));
                roi_dwi = transpose(ExtractVoxelsWithinMask(dwi,cord_sl));
                roi_qmt = transpose(ExtractVoxelsWithinMask(qmt,cord_sl));

                roi_dwiqmtirsemese_noisy = transpose(ExtractVoxelsWithinMask(dwiqmtirsemese_noisy,cord_sl));
                roi_dwiirse_noisy = transpose(ExtractVoxelsWithinMask(dwiirse_noisy,cord_sl));
                roi_dwimese_noisy = transpose(ExtractVoxelsWithinMask(dwimese_noisy,cord_sl));
                roi_dwiqmt_noisy = transpose(ExtractVoxelsWithinMask(dwiqmt_noisy,cord_sl));
                roi_irse_noisy = transpose(ExtractVoxelsWithinMask(irse_noisy,cord_sl));
                roi_mese_noisy = transpose(ExtractVoxelsWithinMask(mese_noisy,cord_sl));
                roi_dwi_noisy = transpose(ExtractVoxelsWithinMask(dwi_noisy,cord_sl));
                roi_qmt_noisy = transpose(ExtractVoxelsWithinMask(qmt_noisy,cord_sl));

                % Save ROIs of current slice
                wc_mese = cat(2,wc_mese,roi_mese);
                wc_mese_noisy = cat(2,wc_mese_noisy,roi_mese_noisy);
                wc_irse = cat(2,wc_irse,roi_irse);
                wc_irse_noisy = cat(2,wc_irse_noisy,roi_irse_noisy);
                wc_dwi = cat(2,wc_dwi,roi_dwi);
                wc_dwi_noisy = cat(2,wc_dwi_noisy,roi_dwi_noisy);
                wc_qmt = cat(2,wc_qmt,roi_qmt);
                wc_qmt_noisy = cat(2,wc_qmt_noisy,roi_qmt_noisy);

                % Perform denoising: 4 modalities
                [roi_den,sigma_est,nsig_est,~] = mppca_mat(roi_dwiqmtirsemese_noisy,0);
                wc_dwi_denjoint4 = cat(2,wc_dwi_denjoint4,roi_den(1:Nmeas_dwi,:));
                wc_qmt_denjoint4 = cat(2,wc_qmt_denjoint4,roi_den(Nmeas_dwi+1:Nmeas_dwi+Nmeas_qmt,:));
                wc_irse_denjoint4 = cat(2,wc_irse_denjoint4,roi_den(Nmeas_dwi+Nmeas_qmt+1:Nmeas_dwi+Nmeas_qmt+Nmeas_irse,:));
                wc_mese_denjoint4 = cat(2,wc_mese_denjoint4,roi_den(Nmeas_dwi+Nmeas_qmt+Nmeas_irse+1:Nmeas_dwi+Nmeas_qmt+Nmeas_irse+Nmeas_mese,:));
                buffsigma_denjoint4(zz) = sigma_est/sigma;
                buffdetectsig_denjoint4(zz) = nsig_est;

                % Perform denoising: IRSE 2 modalities
                [roi_den,sigma_est,nsig_est,~] = mppca_mat(roi_dwiirse_noisy,0);
                wc_dwi_denjoint2irse = cat(2,wc_dwi_denjoint2irse,roi_den(1:Nmeas_dwi,:));
                wc_irse_denjoint2 = cat(2,wc_irse_denjoint2,roi_den(Nmeas_dwi+1:Nmeas_dwi+Nmeas_irse,:));
                buffsigma_irse_denjoint2(zz) = sigma_est/sigma;
                buffdetectsig_irse_denjoint2(zz) = nsig_est;

                % Perform denoising: MESE 2 modalities
                [roi_den,sigma_est,nsig_est,~] = mppca_mat(roi_dwimese_noisy,0);
                wc_dwi_denjoint2mese = cat(2,wc_dwi_denjoint2mese,roi_den(1:Nmeas_dwi,:));
                wc_mese_denjoint2 = cat(2,wc_mese_denjoint2,roi_den(Nmeas_dwi+1:Nmeas_dwi+Nmeas_mese,:));
                buffsigma_mese_denjoint2(zz) = sigma_est/sigma;
                buffdetectsig_mese_denjoint2(zz) = nsig_est;

                % Perform denoising: qMT 2 modalities
                [roi_den,sigma_est,nsig_est,~] = mppca_mat(roi_dwiqmt_noisy,0);
                wc_dwi_denjoint2qmt = cat(2,wc_dwi_denjoint2qmt,roi_den(1:Nmeas_dwi,:));
                wc_qmt_denjoint2 = cat(2,wc_qmt_denjoint2,roi_den(Nmeas_dwi+1:Nmeas_dwi+Nmeas_qmt,:));
                buffsigma_mese_denjoint2(zz) = sigma_est/sigma;
                buffdetectsig_mese_denjoint2(zz) = nsig_est;

                % Perform denoising: DWI
                [roi_den,sigma_est,nsig_est,~] = mppca_mat(roi_dwi_noisy,0);
                wc_dwi_densingle = cat(2,wc_dwi_densingle,roi_den);
                buffsigma_dwi_densingle(zz) = sigma_est/sigma;
                buffdetectsig_dwi_densingle(zz) = nsig_est;

                % Perform denoising: IRSE
                [roi_den,sigma_est,nsig_est,~] = mppca_mat(roi_irse_noisy,0);
                wc_irse_densingle = cat(2,wc_irse_densingle,roi_den);
                buffsigma_irse_densingle(zz) = sigma_est/sigma;
                buffdetectsig_irse_densingle(zz) = nsig_est;

                % Perform denoising: MESE
                [roi_den,sigma_est,nsig_est,~] = mppca_mat(roi_mese_noisy,0);
                wc_mese_densingle = cat(2,wc_mese_densingle,roi_den);
                buffsigma_mese_densingle(zz) = sigma_est/sigma;
                buffdetectsig_mese_densingle(zz) = nsig_est;

                % Perform denoising: qMT
                [roi_den,sigma_est,nsig_est,~] = mppca_mat(roi_qmt_noisy,0);
                wc_qmt_densingle = cat(2,wc_qmt_densingle,roi_den);
                buffsigma_qmt_densingle(zz) = sigma_est/sigma;
                buffdetectsig_qmt_densingle(zz) = nsig_est;
            
            end
            
        end
        
        % Save whole cord stats of the prediction via MP denoising
        
        % sigma
        sigma_denjoint4(ss,qq) = median(buffsigma_denjoint4);
        sigma_dwi_densingle(ss,qq) = median(buffsigma_dwi_densingle);
        sigma_irse_densingle(ss,qq) = median(buffsigma_irse_densingle);
        sigma_mese_densingle(ss,qq) = median(buffsigma_mese_densingle);
        sigma_qmt_densingle(ss,qq) = median(buffsigma_qmt_densingle);
        sigma_irse_denjoint2(ss,qq) = median(buffsigma_irse_denjoint2);
        sigma_mese_denjoint2(ss,qq) = median(buffsigma_mese_denjoint2);
        sigma_qmt_denjoint2(ss,qq) = median(buffsigma_qmt_denjoint2);
        
        % detected signal components
        detectsig_denjoint4(ss,qq) = round(median(buffdetectsig_denjoint4));
        detectsig_dwi_densingle(ss,qq) = round(median(buffdetectsig_dwi_densingle));
        detectsig_irse_densingle(ss,qq) = round(median(buffdetectsig_irse_densingle));
        detectsig_mese_densingle(ss,qq) = round(median(buffdetectsig_mese_densingle));
        detectsig_qmt_densingle(ss,qq) = round(median(buffdetectsig_qmt_densingle));
        detectsig_irse_denjoint2(ss,qq) = round(median(buffdetectsig_irse_denjoint2));
        detectsig_mese_denjoint2(ss,qq) = round(median(buffdetectsig_mese_denjoint2));
        detectsig_qmt_denjoint2(ss,qq) = round(median(buffdetectsig_qmt_denjoint2));
        
        % Accuracy and precision
        accur_dwi_densingle(ss,qq) = median(100*(wc_dwi_densingle(:) - wc_dwi(:))./wc_dwi(:));
        prec_dwi_densingle(ss,qq) = iqr(100*(wc_dwi_densingle(:) - wc_dwi(:))./wc_dwi(:));
        accur_irse_densingle(ss,qq) = median(100*(wc_irse_densingle(:) - wc_irse(:))./wc_irse(:));
        prec_irse_densingle(ss,qq) = iqr(100*(wc_irse_densingle(:) - wc_irse(:))./wc_irse(:));
        accur_mese_densingle(ss,qq) = median(100*(wc_mese_densingle(:) - wc_mese(:))./wc_mese(:));
        prec_mese_densingle(ss,qq) = iqr(100*(wc_mese_densingle(:) - wc_mese(:))./wc_mese(:));
        accur_qmt_densingle(ss,qq) = median(100*(wc_qmt_densingle(:) - wc_qmt(:))./wc_qmt(:));
        prec_qmt_densingle(ss,qq) = iqr(100*(wc_qmt_densingle(:) - wc_qmt(:))./wc_qmt(:));
        
        accur_dwi_denjoint4(ss,qq) = median(100*(wc_dwi_denjoint4(:) - wc_dwi(:))./wc_dwi(:));
        prec_dwi_denjoint4(ss,qq) = iqr(100*(wc_dwi_denjoint4(:) - wc_dwi(:))./wc_dwi(:));
        accur_irse_denjoint4(ss,qq) = median(100*(wc_irse_denjoint4(:) - wc_irse(:))./wc_irse(:));
        prec_irse_denjoint4(ss,qq) = iqr(100*(wc_irse_denjoint4(:) - wc_irse(:))./wc_irse(:));
        accur_mese_denjoint4(ss,qq) = median(100*(wc_mese_denjoint4(:) - wc_mese(:))./wc_mese(:));
        prec_mese_denjoint4(ss,qq) = iqr(100*(wc_mese_denjoint4(:) - wc_mese(:))./wc_mese(:));
        accur_qmt_denjoint4(ss,qq) = median(100*(wc_qmt_denjoint4(:) - wc_qmt(:))./wc_qmt(:));
        prec_qmt_denjoint4(ss,qq) = iqr(100*(wc_qmt_denjoint4(:) - wc_qmt(:))./wc_qmt(:));    
        
        accur_dwi_denjoint2irse(ss,qq) = median(100*(wc_dwi_denjoint2irse(:) - wc_dwi(:))./wc_dwi(:));
        prec_dwi_denjoint2irse(ss,qq) = iqr(100*(wc_dwi_denjoint2irse(:) - wc_dwi(:))./wc_dwi(:));
        accur_dwi_denjoint2mese(ss,qq) = median(100*(wc_dwi_denjoint2mese(:) - wc_dwi(:))./wc_dwi(:));
        prec_dwi_denjoint2mese(ss,qq) = iqr(100*(wc_dwi_denjoint2mese(:) - wc_dwi(:))./wc_dwi(:));
        accur_dwi_denjoint2qmt(ss,qq) = median(100*(wc_dwi_denjoint2qmt(:) - wc_dwi(:))./wc_dwi(:));
        prec_dwi_denjoint2qmt(ss,qq) = iqr(100*(wc_dwi_denjoint2qmt(:) - wc_dwi(:))./wc_dwi(:));    
        accur_irse_denjoint2(ss,qq) = median(100*(wc_irse_denjoint2(:) - wc_irse(:))./wc_irse(:));
        prec_irse_denjoint2(ss,qq) = iqr(100*(wc_irse_denjoint2(:) - wc_irse(:))./wc_irse(:));
        accur_mese_denjoint2(ss,qq) = median(100*(wc_mese_denjoint2(:) - wc_mese(:))./wc_mese(:));
        prec_mese_denjoint2(ss,qq) = iqr(100*(wc_mese_denjoint2(:) - wc_mese(:))./wc_mese(:));
        accur_qmt_denjoint2(ss,qq) = median(100*(wc_qmt_denjoint2(:) - wc_qmt(:))./wc_qmt(:));
        prec_qmt_denjoint2(ss,qq) = iqr(100*(wc_qmt_denjoint2(:) - wc_qmt(:))./wc_qmt(:));
        
        accur_dwi_noisy(ss,qq) = median(100*(wc_dwi_noisy(:) - wc_dwi(:))./wc_dwi(:));
        prec_dwi_noisy(ss,qq) = iqr(100*(wc_dwi_noisy(:) - wc_dwi(:))./wc_dwi(:));
        accur_irse_noisy(ss,qq) = median(100*(wc_irse_noisy(:) - wc_irse(:))./wc_irse(:));
        prec_irse_noisy(ss,qq) = iqr(100*(wc_irse_noisy(:) - wc_irse(:))./wc_irse(:));
        accur_mese_noisy(ss,qq) = median(100*(wc_mese_noisy(:) - wc_mese(:))./wc_mese(:));
        prec_mese_noisy(ss,qq) = iqr(100*(wc_mese_noisy(:) - wc_mese(:))./wc_mese(:));
        accur_qmt_noisy(ss,qq) = median(100*(wc_qmt_noisy(:) - wc_qmt(:))./wc_qmt(:));
        prec_qmt_noisy(ss,qq) = iqr(100*(wc_qmt_noisy(:) - wc_qmt(:))./wc_qmt(:));

        
        
        
    end
    fprintf('\n\n');
    
    
    
    
end


save([mfilename '.mat']);

