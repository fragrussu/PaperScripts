%% Study SVD of noise-free, noisy and denoised signals -- Rician noise
%
% Author: Francesco Grussu, <f.grussu@ucl.ac.uk> 
%
% BSD 2-Clause License
% 
% Copyright (c) 2019 and 2020, University College London.
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


%% Add libraries
addpath(genpath('../dependencies'));
clear all
close all
clc


%% Input information
noisefreedir = '../sc_phantom/multimodal_images';
noisydir = '../sc_phantom/multimodal_noiserealisation_rician';
cordfile = '../sc_phantom/cord.nii';
slice = 38; % slice to plot
MK = 6; % marker size
LW = 2; % Line width

snr_array = [10 12.5 15 17.5 20 30 40]; % Array of SNRs

snr_example = 15; % SNR for which we plot

cols = createCustomColormap([0*[1 1 1]; 0.25*[1 1 1]; 0.5*[1 1 1]; 0.75*[1 1 1]; 1.0*[1 1 1]],[3 3 10 30]);
            

%% Load cord mask and select slice
cord = niftiread(cordfile);
mask = zeros(size(cord));
mask(:,:,slice) = cord(:,:,slice);
nvox = length(mask(mask==1));

% Loop through SNR levels
for snr=snr_array
    
    % Load noise free scans
    dwi_noisefree = niftiread( fullfile(noisefreedir,'vartissue_dwi_M.nii.gz') );
    dwiirse_noisefree = niftiread( fullfile(noisefreedir,'vartissue_dwiirse_M.nii.gz') );
    dwimese_noisefree = niftiread( fullfile(noisefreedir,'vartissue_dwimese_M.nii.gz') );
    dwiqmt_noisefree = niftiread( fullfile(noisefreedir,'vartissue_dwiqmt_M.nii.gz') );
    dwiqmtirsemese_noisefree = niftiread( fullfile(noisefreedir,'vartissue_dwiqmtirsemese_M.nii.gz') );
    irse_noisefree = niftiread( fullfile(noisefreedir,'vartissue_irse_M.nii.gz') );
    mese_noisefree = niftiread( fullfile(noisefreedir,'vartissue_mese_M.nii.gz') );
    qmt_noisefree = niftiread( fullfile(noisefreedir,'vartissue_qmt_M.nii.gz') );



    % Load noisy scans
    dwi_noisy = niftiread( fullfile(noisydir,['vartissue_dwi_noisy_snr' num2str(snr) '.nii.gz']) );
    dwiirse_noisy = niftiread( fullfile(noisydir,['vartissue_dwiirse_noisy_snr' num2str(snr) '.nii.gz']) );
    dwimese_noisy = niftiread( fullfile(noisydir,['vartissue_dwimese_noisy_snr' num2str(snr) '.nii.gz']) );
    dwiqmt_noisy = niftiread( fullfile(noisydir,['vartissue_dwiqmt_noisy_snr' num2str(snr) '.nii.gz']) );
    dwiqmtirsemese_noisy = niftiread( fullfile(noisydir,['vartissue_dwiqmtirsemese_noisy_snr' num2str(snr) '.nii.gz']) );
    irse_noisy = niftiread( fullfile(noisydir,['vartissue_irse_noisy_snr' num2str(snr) '.nii.gz']) );
    mese_noisy = niftiread( fullfile(noisydir,['vartissue_mese_noisy_snr' num2str(snr) '.nii.gz']) );
    qmt_noisy = niftiread( fullfile(noisydir,['vartissue_qmt_noisy_snr' num2str(snr) '.nii.gz']) );

    
    % Extract 2D matrices corresponding (1 MRI slice) for SVD analysis: noise-free scans
    [dwi_noisefree_mat,~] = ExtractVoxelsWithinMask(dwi_noisefree, mask);
    [dwiirse_noisefree_mat,~] = ExtractVoxelsWithinMask(dwiirse_noisefree, mask);     
    [dwimese_noisefree_mat,~] = ExtractVoxelsWithinMask(dwimese_noisefree, mask);
    [dwiqmt_noisefree_mat,~] = ExtractVoxelsWithinMask(dwiqmt_noisefree, mask);
    [dwiqmtirsemese_noisefree_mat,~] = ExtractVoxelsWithinMask(dwiqmtirsemese_noisefree, mask);
    [irse_noisefree_mat,~] = ExtractVoxelsWithinMask(irse_noisefree, mask);
    [mese_noisefree_mat,~] = ExtractVoxelsWithinMask(mese_noisefree, mask);
    [qmt_noisefree_mat,~] = ExtractVoxelsWithinMask(qmt_noisefree, mask);
    
    % Extract 2D matrices corresponding (1 MRI slice) for SVD analysis: noisy scans
    [dwi_noisy_mat,~] = ExtractVoxelsWithinMask(dwi_noisy, mask);
    [dwiirse_noisy_mat,~] = ExtractVoxelsWithinMask(dwiirse_noisy, mask);     
    [dwimese_noisy_mat,~] = ExtractVoxelsWithinMask(dwimese_noisy, mask);
    [dwiqmt_noisy_mat,~] = ExtractVoxelsWithinMask(dwiqmt_noisy, mask);
    [dwiqmtirsemese_noisy_mat,~] = ExtractVoxelsWithinMask(dwiqmtirsemese_noisy, mask);
    [irse_noisy_mat,~] = ExtractVoxelsWithinMask(irse_noisy, mask);
    [mese_noisy_mat,~] = ExtractVoxelsWithinMask(mese_noisy, mask);
    [qmt_noisy_mat,~] = ExtractVoxelsWithinMask(qmt_noisy, mask);    
    
    % Perform denoising
     [dwi_denoised_mat, ~, dwi_denoised_nsig] = MP(dwi_noisy_mat);
     [dwiirse_denoised_mat, ~, dwiirse_denoised_nsig] = MP(dwiirse_noisy_mat);
     [dwimese_denoised_mat, ~, dwimese_denoised_nsig] = MP(dwimese_noisy_mat);
     [dwiqmt_denoised_mat, ~, dwiqmt_denoised_nsig] = MP(dwiqmt_noisy_mat);
     [dwiqmtirsemese_denoised_mat, ~, dwiqmtirsemese_denoised_nsig] = MP(dwiqmtirsemese_noisy_mat);
     [irse_denoised_mat, ~, irse_denoised_nsig] = MP(irse_noisy_mat);
     [mese_denoised_mat, ~, mese_denoised_nsig] = MP(mese_noisy_mat);
     [qmt_denoised_mat, ~, qmt_denoised_nsig] = MP(qmt_noisy_mat);
     
     
    % Perform SVD of noise-free signals
    dwi_noisefree_sv = svd(dwi_noisefree_mat);
    dwiirse_noisefree_sv = svd(dwiirse_noisefree_mat);    
    dwimese_noisefree_sv = svd(dwimese_noisefree_mat);
    dwiqmt_noisefree_sv = svd(dwiqmt_noisefree_mat);
    dwiqmtirsemese_noisefree_sv = svd(dwiqmtirsemese_noisefree_mat);
    irse_noisefree_sv = svd(irse_noisefree_mat);
    mese_noisefree_sv = svd(mese_noisefree_mat);
    qmt_noisefree_sv = svd(qmt_noisefree_mat);
    
    % Perform SVD of noisy signals
    dwi_noisy_sv = svd(dwi_noisy_mat);
    dwiirse_noisy_sv = svd(dwiirse_noisy_mat);    
    dwimese_noisy_sv = svd(dwimese_noisy_mat);
    dwiqmt_noisy_sv = svd(dwiqmt_noisy_mat);
    dwiqmtirsemese_noisy_sv = svd(dwiqmtirsemese_noisy_mat);
    irse_noisy_sv = svd(irse_noisy_mat);
    mese_noisy_sv = svd(mese_noisy_mat);
    qmt_noisy_sv = svd(qmt_noisy_mat);
    
    % Perform SVD of denoised signals
    dwi_denoised_sv = svd(dwi_denoised_mat);
    dwiirse_denoised_sv = svd(dwiirse_denoised_mat);    
    dwimese_denoised_sv = svd(dwimese_denoised_mat);
    dwiqmt_denoised_sv = svd(dwiqmt_denoised_mat);
    dwiqmtirsemese_denoised_sv = svd(dwiqmtirsemese_denoised_mat);
    irse_denoised_sv = svd(irse_denoised_mat);
    mese_denoised_sv = svd(mese_denoised_mat);
    qmt_denoised_sv = svd(qmt_denoised_mat);
    
    % Plot 1: all singular values
    figure('Name',['SVD plots, SNR = ' num2str(snr)])
    
    subplot(4,2,1)
    plot(dwiqmtirsemese_noisefree_sv,'o','MarkerSize',MK+4,'LineWidt',LW); hold on
    plot(dwiqmtirsemese_noisy_sv,'x','MarkerSize',MK+2,'LineWidt',LW); hold on
    plot(dwiqmtirsemese_denoised_sv,'^','MarkerSize',MK+2,'LineWidt',LW); hold on
    plot(eps(dwiqmtirsemese_noisy_sv),'--','LineWidt',LW+1); hold on
    set(gca,'YScale','log');
    xlabel('SV index')
    ylabel('SV')
    title(['A) Joint DWI-qMT-IR-mTE; SNR=' num2str(snr)])
    set(gca,'YLim',[1e-16 1e4],'YTick',[1e-16 1e-12 1e-8 1e-4 1e0 1e4]);
    xlim = get(gca,'XLim'); xlim(1) = 1; xlim(2) = length(dwiqmtirsemese_noisefree_sv); set(gca,'XLim',xlim);
    grid on
    
    subplot(4,2,2) 
    plot(dwi_noisefree_sv,'o','MarkerSize',MK+4,'LineWidt',LW); hold on
    plot(dwi_noisy_sv,'x','MarkerSize',MK+2,'LineWidt',LW); hold on
    plot(dwi_denoised_sv,'^','MarkerSize',MK+2,'LineWidt',LW); hold on
    plot(eps(dwi_noisy_sv),'--','LineWidt',LW+1); hold on    
    set(gca,'YScale','log');
    xlabel('SV index')
    ylabel('SV')
    title(['B) DWI; SNR=' num2str(snr)])
    set(gca,'YLim',[1e-16 1e4],'YTick',[1e-16 1e-12 1e-8 1e-4 1e0 1e4]);
    xlim = get(gca,'XLim'); xlim(1) = 1; xlim(2) = length(dwi_noisefree_sv); set(gca,'XLim',xlim);
    grid on
    
    subplot(4,2,3) 
    plot(dwiqmt_noisefree_sv,'o','MarkerSize',MK+4,'LineWidt',LW); hold on
    plot(dwiqmt_noisy_sv,'x','MarkerSize',MK+2,'LineWidt',LW); hold on
    plot(dwiqmt_denoised_sv,'^','MarkerSize',MK+2,'LineWidt',LW); hold on
    plot(eps(dwiqmt_noisy_sv),'--','LineWidt',LW+1); hold on 
    set(gca,'YScale','log');
    xlabel('SV index')
    ylabel('SV')
    title(['C) Joint DWI-qMT; SNR=' num2str(snr)])
    set(gca,'YLim',[1e-16 1e4],'YTick',[1e-16 1e-12 1e-8 1e-4 1e0 1e4]);
    xlim = get(gca,'XLim'); xlim(1) = 1; xlim(2) = length(dwiqmt_noisefree_sv); set(gca,'XLim',xlim);
    grid on
    
    subplot(4,2,4) 
    plot(qmt_noisefree_sv,'o','MarkerSize',MK+4,'LineWidt',LW); hold on
    plot(qmt_noisy_sv,'x','MarkerSize',MK+2,'LineWidt',LW); hold on
    plot(qmt_denoised_sv,'^','MarkerSize',MK+2,'LineWidt',LW); hold on
    plot(eps(qmt_noisy_sv),'--','LineWidt',LW+1); hold on 
    set(gca,'YScale','log');
    xlabel('SV index')
    ylabel('SV')
    title(['D) qMT; SNR=' num2str(snr)])
    set(gca,'YLim',[1e-16 1e4],'YTick',[1e-16 1e-12 1e-8 1e-4 1e0 1e4]);
    xlim = get(gca,'XLim'); xlim(1) = 1; xlim(2) = length(qmt_noisefree_sv); set(gca,'XLim',xlim);
    grid on
    
    
    subplot(4,2,5) 
    plot(dwiirse_noisefree_sv,'o','MarkerSize',MK+4,'LineWidt',LW); hold on
    plot(dwiirse_noisy_sv,'x','MarkerSize',MK+2,'LineWidt',LW); hold on
    plot(dwiirse_denoised_sv,'^','MarkerSize',MK+2,'LineWidt',LW); hold on
    plot(eps(dwiirse_noisy_sv),'--','LineWidt',LW+1); hold on 
    set(gca,'YScale','log');
    xlabel('SV index')
    ylabel('SV')
    title(['E) Joint DWI-IR; SNR=' num2str(snr)])
    set(gca,'YLim',[1e-16 1e4],'YTick',[1e-16 1e-12 1e-8 1e-4 1e0 1e4]);
    xlim = get(gca,'XLim'); xlim(1) = 1; xlim(2) = length(dwiirse_noisefree_sv); set(gca,'XLim',xlim);
    grid on
    
    subplot(4,2,6) 
    plot(irse_noisefree_sv,'o','MarkerSize',MK+4,'LineWidt',LW); hold on
    plot(irse_noisy_sv,'x','MarkerSize',MK+2,'LineWidt',LW); hold on
    plot(irse_denoised_sv,'^','MarkerSize',MK+2,'LineWidt',LW); hold on
    plot(eps(irse_noisy_sv),'--','LineWidt',LW+1); hold on 
    set(gca,'YScale','log');
    xlabel('SV index')
    ylabel('SV')
    title(['F) IR; SNR=' num2str(snr)])
    set(gca,'YLim',[1e-16 1e4],'YTick',[1e-16 1e-12 1e-8 1e-4 1e0 1e4]);
    xlim = get(gca,'XLim'); xlim(1) = 1; xlim(2) = length(irse_noisefree_sv); set(gca,'XLim',xlim);
    grid on
    
    subplot(4,2,7) 
    plot(dwimese_noisefree_sv,'o','MarkerSize',MK+4,'LineWidt',LW); hold on
    plot(dwimese_noisy_sv,'x','MarkerSize',MK+2,'LineWidt',LW); hold on
    plot(dwimese_denoised_sv,'^','MarkerSize',MK+2,'LineWidt',LW); hold on
    plot(eps(dwimese_noisy_sv),'--','LineWidt',LW+1); hold on 
    set(gca,'YScale','log');
    xlabel('SV index')
    ylabel('SV')
    title(['G) Joint DWI-mTE; SNR=' num2str(snr)])
    set(gca,'YLim',[1e-16 1e4],'YTick',[1e-16 1e-12 1e-8 1e-4 1e0 1e4]);
    xlim = get(gca,'XLim'); xlim(1) = 1; xlim(2) = length(dwimese_noisefree_sv); set(gca,'XLim',xlim);
    grid on
    legend({'Noise-free SV','Noisy SV','Denoised SV','Machine precision for noisy SV' })
        
    subplot(4,2,8) 
    plot(mese_noisefree_sv,'o','MarkerSize',MK+4,'LineWidt',LW); hold on
    plot(mese_noisy_sv,'x','MarkerSize',MK+2,'LineWidt',LW); hold on
    plot(mese_denoised_sv,'^','MarkerSize',MK+2,'LineWidt',LW); hold on
    plot(eps(mese_noisy_sv),'--','LineWidt',LW+1); hold on 
    set(gca,'YScale','log');
    xlabel('SV index')
    ylabel('SV')
    title(['H) mTE; SNR=' num2str(snr)])
    set(gca,'YLim',[1e-16 1e4],'YTick',[1e-16 1e-12 1e-8 1e-4 1e0 1e4]);
    xlim = get(gca,'XLim'); xlim(1) = 1; xlim(2) = length(mese_noisefree_sv); set(gca,'XLim',xlim);
    grid on
    legend({'Noise-free SV','Noisy SV','Denoised SV','Machine precision for noisy SV' })
    
    % Plot 2: example of matrix + singular values (plot only for one representative SNR)
    if(snr==snr_example)
        
        
            figure('Name',['Matrix plots, Rician noise, SNR = ' num2str(snr)])
            subplot(2,4,1)
            imagesc(dwiqmtirsemese_noisefree_mat,[-10 110]); c = colorbar('southoutside'); colormap(cols); title(c,'Signal [a.u.]');
            set(gca,'XTick',[1 size(dwiqmtirsemese_noisefree_mat,2)],'YTick',[1 size(dwiqmtirsemese_noisefree_mat,1)])
            ylabel('Voxel index'); xlabel('Measurement index')
            title('A) Noise-free matrix')
            
            subplot(2,4,2)
            imagesc(dwiqmtirsemese_noisy_mat,[-10 110]); c = colorbar('southoutside'); colormap(cols); title(c,'Signal [a.u.]');
            set(gca,'XTick',[1 size(dwiqmtirsemese_noisefree_mat,2)],'YTick',[1 size(dwiqmtirsemese_noisefree_mat,1)])
            ylabel('Voxel index'); xlabel('Measurement index')
            title(['B) Noisy matrix (SNR=' num2str(snr) ')'])
                        
            subplot(2,4,3)
            imagesc(dwiqmtirsemese_denoised_mat,[-10 110]); c = colorbar('southoutside'); colormap(cols); title(c,'Signal [a.u.]');
            set(gca,'XTick',[1 size(dwiqmtirsemese_noisefree_mat,2)],'YTick',[1 size(dwiqmtirsemese_noisefree_mat,1)])
            ylabel('Voxel index'); xlabel('Measurement index')
            title(['C) Denoised matrix'])  
            
            subplot(2,4,4)
            imagesc(dwiqmtirsemese_denoised_mat - dwiqmtirsemese_noisy_mat,[-5 5]); c = colorbar('southoutside'); colormap(cols); title(c,'Signal [a.u.]');
            set(gca,'XTick',[1 size(dwiqmtirsemese_noisefree_mat,2)],'YTick',[1 size(dwiqmtirsemese_noisefree_mat,1)])
            ylabel('Voxel index'); xlabel('Measurement index')
            title(['D) Residuals (denoised - noisy)'])  
            
            subplot(2,4,[5 8])
            plot(dwiqmtirsemese_noisefree_sv,'o','MarkerSize',MK+4,'LineWidt',LW); hold on
            plot(dwiqmtirsemese_noisy_sv,'x','MarkerSize',MK+2,'LineWidt',LW); hold on
            plot(dwiqmtirsemese_denoised_sv,'^','MarkerSize',MK+2,'LineWidt',LW); hold on
            set(gca,'YScale','log');
            xlabel('SV index')
            ylabel('SV')
            title(['E) Singular values (SV)'])
            set(gca,'YLim',[1e-16 1e4],'YTick',[1e-16 1e-12 1e-8 1e-4 1e0 1e4]);
            xlim = get(gca,'XLim'); xlim(1) = 1; xlim(2) = length(dwiqmtirsemese_noisefree_sv); set(gca,'XLim',xlim);
            legend({'Noise-free SV',['Noisy SV (SNR=' num2str(snr_example) ')'],'Denoised SV' })
            grid on
            
            
    end

     
     
     
    
end




